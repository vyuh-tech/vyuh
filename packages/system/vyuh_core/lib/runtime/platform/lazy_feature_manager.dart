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

  int _generation = 0;
  final Set<Future<void>> _activations = {};

  _LazyFeatureManager(this._platform);

  /// Register lazy features for deferred loading.
  void registerLazyFeatures(List<LazyFeatureDescriptor> features) {
    for (final feature in features) {
      _pending[feature.name] = feature;
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

    final pending = _loadAndActivate(lazy, _generation);
    _loading[name] = pending;
    try {
      await pending;
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

  /// Whether a lazy feature has been loaded.
  bool isLoaded(String name) => _loaded.contains(name);

  /// Whether a feature name is registered as lazy (loaded or pending).
  bool isLazyFeature(String name) =>
      _pending.containsKey(name) || _loaded.contains(name);

  /// All lazy feature names (pending + loaded).
  Iterable<String> get allNames => {..._pending.keys, ..._loaded};

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
  Object? _error;
  StackTrace? _stackTrace;

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
      if (mounted) {
        setState(() {
          _error = e;
          _stackTrace = st;
        });
      }
    }
  }

  @override
  flutter.Widget build(flutter.BuildContext context) {
    if (_error != null) {
      if (_error is _FeatureDisabledException) {
        final disabled = _error as _FeatureDisabledException;
        return vyuh.widgetBuilder.routeErrorView(
          context,
          title: 'Feature Not Available',
          subtitle: disabled.featureName,
          error: 'The feature "${disabled.featureName}" is currently disabled.',
        );
      }

      return vyuh.widgetBuilder.routeErrorView(
        context,
        title: 'Failed to load feature',
        subtitle: widget.featureName,
        error: _error,
        stackTrace: _stackTrace,
        onRetry: () {
          setState(() {
            _error = null;
            _stackTrace = null;
          });
          _loadAndNavigate();
        },
      );
    }

    return vyuh.widgetBuilder.appLoader(context);
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
