part of '../run_app.dart';

/// Manages lazy feature loading, placeholder route generation,
/// and route replacement after features are loaded.
final class _LazyFeatureManager {
  final _DefaultVyuhPlatform _platform;

  /// Lazy features that have NOT yet been loaded.
  final Map<String, LazyFeatureDescriptor> _pending = {};

  /// Lazy features currently being loaded (prevents double-loads).
  final Map<String, Future<void>> _loading = {};

  /// Lazy features that have been fully loaded and activated.
  final Set<String> _loaded = {};

  /// Every registered lazy descriptor, kept after loading for failure text.
  final Map<String, LazyFeatureDescriptor> _descriptors = {};

  int _generation = 0;
  final Set<Future<void>> _activations = {};

  _LazyFeatureManager(this._platform);

  /// Register lazy features for deferred loading.
  void registerLazyFeatures(List<LazyFeatureDescriptor> features) {
    for (final feature in features) {
      _pending[feature.name] = feature;
      _descriptors[feature.name] = feature;
    }
    final visited = <String>{};
    final visiting = <String>{};
    void visit(String name) {
      if (visited.contains(name)) return;
      if (!visiting.add(name)) {
        throw StateError('Circular lazy feature dependency involving: $name');
      }
      final feature = _pending[name];
      if (feature == null) {
        if (!_platform.features.any((feature) => feature.name == name)) {
          throw StateError('No feature registered for dependency: $name');
        }
      } else {
        for (final dependency in feature.dependencies) {
          visit(dependency);
        }
      }
      visiting.remove(name);
      visited.add(name);
    }

    for (final name in _pending.keys) {
      visit(name);
    }
  }

  /// Build GoRoute placeholders that show a loading screen and
  /// trigger the lazy load when navigated to.
  List<g.RouteBase> buildPlaceholderRoutes() {
    final routes = <g.RouteBase>[];

    for (final entry in _pending.entries) {
      final lazy = entry.value;
      for (final prefix in lazy.routePrefixes) {
        routes.add(
          g.GoRoute(
            path: prefix,
            routes: [
              g.GoRoute(
                path: ':rest(.*)',
                pageBuilder: (context, state) => flutter.MaterialPage(
                  child: _LazyLoadingPage(
                    featureName: lazy.name,
                    manager: this,
                    targetLocation: state.uri.toString(),
                  ),
                ),
              ),
            ],
            pageBuilder: (context, state) => flutter.MaterialPage(
              child: _LazyLoadingPage(
                featureName: lazy.name,
                manager: this,
                targetLocation: state.uri.toString(),
              ),
            ),
          ),
        );
      }
    }

    return routes;
  }

  /// Load a feature by name. Handles dependency resolution,
  /// deduplication, and activation.
  Future<void> loadFeature(String name) async {
    if (_loaded.contains(name)) return;

    // Deduplicate concurrent loads
    if (_loading.containsKey(name)) {
      await _loading[name];
      return;
    }

    final lazy = _pending[name];
    if (lazy == null) {
      throw StateError('No lazy feature registered with name: $name');
    }

    final generation = _generation;
    final pending = _loadAndActivate(lazy, generation);
    _loading[name] = pending;
    try {
      await pending;
      _emit(FeatureLoadedEvent(featureName: name, isLazy: true));
    } catch (error, stack) {
      // A load cancelled by dispose or restart is not a feature failure.
      if (generation == _generation) {
        _emit(
          FeatureLoadFailedEvent(
            featureName: name,
            failure: _failureFor(lazy, error, stack),
          ),
        );
      }
      rethrow;
    } finally {
      if (identical(_loading[name], pending)) {
        _loading.remove(name);
      }
    }
  }

  Future<void> _loadAndActivate(
    LazyFeatureDescriptor lazy,
    int generation,
  ) async {
    void checkActive() {
      if (generation != _generation) {
        throw StateError(
          'Lazy feature load cancelled by platform lifecycle change',
        );
      }
    }

    final name = lazy.name;

    // Check feature flag if configured
    if (lazy.featureFlag != null) {
      final flagPlugin = vyuh.featureFlag;
      if (flagPlugin != null) {
        final enabled = await flagPlugin.getBool(
          lazy.featureFlag!,
          defaultValue: true,
        );
        if (!enabled) {
          throw _FeatureDisabledException(
            featureName: name,
            flagName: lazy.featureFlag!,
          );
        }
      }
    }

    // Load dependencies first
    for (final dep in lazy.dependencies) {
      if (!_loaded.contains(dep) && _pending.containsKey(dep)) {
        await loadFeature(dep);
      } else {
        await _platform.featureReady(dep);
      }
    }

    checkActive();

    // Load the feature itself
    final feature = await lazy.loader();

    checkActive();

    // Validate that the loaded feature name matches
    if (feature.name != name) {
      throw StateError(
        'Lazy feature "$name" loaded a descriptor named "${feature.name}"',
      );
    }

    final activation = _platform._activateLazyFeature(
      feature,
      lazy.routePrefixes,
      checkActive,
    );
    _activations.add(activation);
    try {
      await activation;
    } finally {
      _activations.remove(activation);
    }
    checkActive();

    _loaded.add(name);
    _pending.remove(name);
  }

  /// Emits a lifecycle event without ever masking the caller's outcome.
  static void _emit(SystemEvent event) {
    try {
      vyuh.event.emit(event);
    } catch (error, stack) {
      debugPrint('Vyuh: could not emit ${event.name}: $error\n$stack');
    }
  }

  static VyuhFailure _failureFor(
    LazyFeatureDescriptor lazy,
    Object error,
    StackTrace? stack, [
    Uri? location,
  ]) => error is _FeatureDisabledException
      ? VyuhFailure(
          kind: FailureKind.featureDisabled,
          title: VyuhStrings.current.featureDisabledTitle(lazy.title),
          message: VyuhStrings.current.featureDisabledMessage,
          error: error,
          location: location,
          featureName: lazy.name,
        )
      : VyuhFailure(
          kind: FailureKind.featureLoad,
          title: VyuhStrings.current.featureLoadFailedTitle(lazy.title),
          message: VyuhStrings.current.checkConnectionMessage,
          error: error,
          stackTrace: stack,
          location: location,
          featureName: lazy.name,
        );

  /// The registered descriptor for [name], loaded or pending.
  LazyFeatureDescriptor? descriptor(String name) => _descriptors[name];

  /// Whether a lazy feature has been loaded.
  bool isLoaded(String name) => _loaded.contains(name);

  /// Wait for entered activation hooks to clean up before services are disposed.
  Future<void> drainActivations() async {
    await Future.wait(
      _activations.toList().map((future) async {
        try {
          await future;
        } catch (_) {
          /* The load caller receives the failure. */
        }
      }),
    );
  }

  /// Reset all state. Called during platform dispose.
  void reset() {
    _generation++;
    _pending.clear();
    _loading.clear();
    _loaded.clear();
    _descriptors.clear();
  }
}

/// Shown while a lazy feature is being loaded.
/// After loading completes, re-navigates to the target location.
class _LazyLoadingPage extends flutter.StatefulWidget {
  final String featureName;
  final _LazyFeatureManager manager;
  final String targetLocation;

  const _LazyLoadingPage({
    required this.featureName,
    required this.manager,
    required this.targetLocation,
  });

  @override
  flutter.State<_LazyLoadingPage> createState() => _LazyLoadingPageState();
}

class _LazyLoadingPageState extends flutter.State<_LazyLoadingPage> {
  VyuhFailure? _failure;

  @override
  void initState() {
    super.initState();
    _loadAndNavigate();
  }

  Future<void> _loadAndNavigate() async {
    try {
      await widget.manager.loadFeature(widget.featureName);

      if (mounted) {
        // Feature loaded — real routes are now registered.
        // Re-navigate to trigger GoRouter matching with real routes.
        vyuh.router.go(widget.targetLocation);
      }
    } catch (e, st) {
      final lazy = widget.manager.descriptor(widget.featureName);
      if (mounted && lazy != null) {
        setState(() {
          _failure = _LazyFeatureManager._failureFor(
            lazy,
            e,
            st,
            Uri.tryParse(widget.targetLocation),
          );
        });
      }
    }
  }

  @override
  flutter.Widget build(flutter.BuildContext context) {
    final failure = _failure;
    if (failure != null) {
      return RouteFailureView(
        // A new key reports the failure again after a failed retry.
        key: flutter.ObjectKey(failure),
        failure: failure,
        onRetry: failure.kind == FailureKind.featureDisabled
            ? null
            : () {
                setState(() => _failure = null);
                _loadAndNavigate();
              },
      );
    }

    return vyuh.widgetBuilder.routeLoader(
      context,
      Uri.tryParse(widget.targetLocation),
    );
  }
}

/// Thrown when a lazy feature is disabled via feature flags.
class _FeatureDisabledException implements Exception {
  final String featureName;
  final String flagName;

  _FeatureDisabledException({
    required this.featureName,
    required this.flagName,
  });

  @override
  String toString() => 'Feature "$featureName" is disabled (flag: "$flagName")';
}
