part of '../run_app.dart';

final class _DefaultVyuhPlatform extends VyuhPlatform {
  /// We only track this to pass it on to [VyuhBinding]
  final PluginDescriptor _pluginDescriptor;

  /// We only track this to pass it on to [VyuhBinding]
  final PlatformWidgetBuilder _widgetBuilder;

  /// The app runner that controls how the app is launched.
  final AppRunner _appRunner;

  final Map<Type, ExtensionBuilder> _featureExtensionBuilderMap = {};

  /// Initialize first time to avoid any late-init errors.
  /// Eventually this will be initialized anytime we restart the platform
  GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final SystemInitTracker _tracker;

  String _userInitialLocation = '/';

  /// The initial Location that will be used by the router
  final String? initialLocation;

  /// Where error views send the user with "Go home".
  final String? homeLocation;

  /// Whether to route uncaught errors to telemetry and show themed
  /// fallbacks for widgets that fail to build.
  final bool captureErrors;

  /// Event subscriptions of each running feature, cancelled when it stops.
  final Map<String, List<DisposeFunction>> _featureSubscriptions = {};

  @override
  GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  @override
  SystemInitTracker get tracker => _tracker;

  List<FeatureDescriptor> _features = [];

  @override
  List<FeatureDescriptor> get features => _features;

  final Map<String, Future<void>> _readyFeatures = {};

  @override
  Future<void>? featureReady(String featureName) => _readyFeatures[featureName];

  final FeaturesBuilder _featuresBuilder;
  final LazyFeaturesBuilder? _lazyFeaturesBuilder;
  late final _LazyFeatureManager _lazyFeatureManager;

  @override
  List<Plugin> get plugins => VyuhBinding.instance.plugins;

  @override
  PlatformWidgetBuilder get widgetBuilder => VyuhBinding.instance.widgetBuilder;

  _DefaultVyuhPlatform({
    required this._featuresBuilder,
    this._lazyFeaturesBuilder,
    required this._pluginDescriptor,
    required this._widgetBuilder,
    required this._appRunner,
    this.initialLocation,
    this.homeLocation,
    this.captureErrors = true,
  }) {
    _tracker = _PlatformInitTracker(this);
    _lazyFeatureManager = _LazyFeatureManager(this);
  }

  @override
  Future<void> run() async {
    await VyuhBinding.instance._appInit(
      plugins: _pluginDescriptor,
      widgetBuilder: _widgetBuilder,
    );

    _userInitialLocation = PlatformDispatcher.instance.defaultRouteName;

    if (captureErrors) _installErrorHandlers();

    _appRunner(const _FrameworkInitView());
  }

  @override
  Future<void> dispose() async {
    if (!VyuhBinding.instance.initialized) {
      return;
    }

    await _disposeFeatures();
    for (final builder in _featureExtensionBuilderMap.values) {
      await builder.dispose();
    }
    await VyuhBinding.instance.dispose();

    _features.clear();
    _readyFeatures.clear();
    _featureExtensionBuilderMap.clear();
    _lazyFeatureManager.reset();
    _userInitialLocation = '';
  }

  @override
  Future<void> initPlugins(Trace parentTrace) => telemetry.trace(
    name: 'Plugins',
    operation: 'Init',
    parentTrace: parentTrace,
    fn: (trace) async {
      // On restart, stop the previous features while the services they use
      // still exist, then reset the plugins.
      await _disposeFeatures();

      // Only run init on non-preloaded plugins
      final effectivePlugins = plugins.whereNot((p) => p is PreloadedPlugin);

      // Run a cleanup first
      final disposeFns = effectivePlugins.map((e) => e.dispose());
      await Future.wait(disposeFns, eagerError: true);

      // Check
      final initFns = effectivePlugins.map((e) {
        return telemetry.trace<void>(
          name: 'Plugin: ${e.title}',
          operation: 'Init',
          parentTrace: trace,
          fn: (_) => e.init(),
        );
      });

      await Future.wait(initFns, eagerError: true);
    },
  );

  @override
  Future<void> initFeatures(Trace parentTrace) async {
    // A no-op when initPlugins already stopped them.
    await _disposeFeatures();

    return telemetry.trace<void>(
      name: 'Features',
      operation: 'Init',
      parentTrace: parentTrace,
      fn: (trace) async {
        _readyFeatures.clear();
        _features = List.of(await _featuresBuilder());

        // Register lazy features
        final lazyFeatures = _lazyFeaturesBuilder?.call() ?? [];
        _lazyFeatureManager.reset();
        _lazyFeatureManager.registerLazyFeatures(lazyFeatures);

        // Ensure feature names are unique across eager and lazy features
        final featureNames = <String>{};
        for (final feature in _features) {
          if (featureNames.contains(feature.name)) {
            throw StateError(
              'Feature name "${feature.name}" is not unique. Ensure only uniquely named features are included.',
            );
          } else {
            featureNames.add(feature.name);
          }
        }
        for (final lazy in lazyFeatures) {
          if (featureNames.contains(lazy.name)) {
            throw StateError(
              'Lazy feature name "${lazy.name}" is not unique. Ensure only uniquely named features are included.',
            );
          } else {
            featureNames.add(lazy.name);
          }
        }

        // Topologically sort eager features by dependencies
        _features = _topologicalSort(_features);

        // Start app-level hooks first, so features hear events emitted
        // while other features initialize.
        for (final feature in _features) {
          _startFeatureHooks(feature);
        }

        final initFns = _features.map(
          (feature) => telemetry.trace<List<g.RouteBase>>(
            name: 'Feature: ${feature.title}',
            operation: 'Init',
            parentTrace: trace,
            fn: (trace) {
              final future = () async {
                for (final dependency in feature.dependencies) {
                  await _readyFeatures[dependency];
                }
                final routes = await _initFeature(feature, trace);
                _LazyFeatureManager._emit(
                  FeatureLoadedEvent(featureName: feature.name, isLazy: false),
                );
                return routes;
              }();

              _readyFeatures[feature.name] = future;

              return future;
            },
          ),
        );

        await telemetry.trace<void>(
          name: 'Feature Extensions',
          operation: 'Init',
          parentTrace: trace,
          fn: (_) => _initFeatureExtensions(_features),
        );

        return telemetry.trace<void>(
          name: 'Feature Routes',
          operation: 'Init',
          parentTrace: trace,
          fn: (_) async {
            final allRoutes = await Future.wait(initFns, eagerError: true);

            // Build placeholder routes for lazy features
            final placeholderRoutes = _lazyFeatureManager
                .buildPlaceholderRoutes();

            return _initRouter([
              ...allRoutes
                  .where((routes) => routes != null)
                  .cast<List<g.RouteBase>>()
                  .expand((routes) => routes),
              ...placeholderRoutes,
            ]);
          },
        );
      },
    );
  }

  Future<List<g.RouteBase>> _initFeature(
    FeatureDescriptor feature,
    Trace? parentTrace,
  ) async {
    await feature.init?.call();

    if (feature.routes == null) {
      return [];
    }

    final featureRoutes = await telemetry.trace<List<g.RouteBase>>(
      name: 'Routes: ${feature.title}',
      operation: 'Init',
      parentTrace: parentTrace,
      fn: (_) => feature.routes!(),
    );

    return featureRoutes ?? [];
  }

  Future<void> _initRouter(List<g.RouteBase> routes) async {
    _rootNavigatorKey = GlobalKey<NavigatorState>();

    router.homeLocation = homeLocation ?? initialLocation ?? '/';
    router.initRouter(
      routes: routes,
      // A deep link. flutter_test cannot set the route name of
      // PlatformDispatcher.instance, only of its own test dispatcher.
      initialLocation: _userInitialLocation == '/'
          ? initialLocation ?? '/'
          : _userInitialLocation, // coverage:ignore-line
      rootNavigatorKey: _rootNavigatorKey,
    );
  }

  Future<void> _initFeatureExtensions(List<FeatureDescriptor> features) async {
    final disposeFutures = <Future<void>>[];

    final builders = features.expand(
      (element) => element.extensionBuilders ?? <ExtensionBuilder>[],
    );

    for (final builder in builders) {
      try {
        if (builder.isInitialized) {
          disposeFutures.add(builder.dispose());
        }
      } catch (e, st) {
        vyuh.telemetry.reportError(e, stackTrace: st);
      }
    }

    // Wait for all disposals to complete
    await Future.wait(disposeFutures, eagerError: false);

    // Do some consistency checks on the ExtensionBuilders
    final groupedBuilders = builders.groupListsBy(
      (element) => element.extensionType,
    );

    for (final entry in groupedBuilders.entries) {
      if (entry.value.length != 1) {
        throw StateError(
          'There can be only one ExtensionBuilder for ${entry.key}',
        );
      }

      _featureExtensionBuilderMap[entry.key] = entry.value.first;
    }

    final extensions = features
        .expand((element) => element.extensions ?? <ExtensionDescriptor>[])
        .groupListsBy((element) => element.runtimeType);

    // Ensure for every ExtensionDescriptor, there is a corresponding ExtensionBuilder registered
    extensions.forEach((runtimeType, descriptors) {
      final builder = _featureExtensionBuilderMap[runtimeType];

      if (builder == null) {
        throw StateError(
          'Missing ExtensionBuilder for ExtensionDescriptor of schemaType: $runtimeType',
        );
      }
    });

    // Initialize all extension builders
    for (final entry in _featureExtensionBuilderMap.entries) {
      final builder = entry.value;

      await telemetry.trace(
        name: 'Extension: ${builder.title}',
        operation: 'Init',
        fn: (_) =>
            builder.init(extensions[entry.key] ?? <ExtensionDescriptor>[]),
      );
    }
  }

  /// Called by [_LazyFeatureManager] after a feature is loaded.
  /// Runs the feature's init, registers extensions, and swaps routes.
  Future<void> _activateLazyFeature(
    FeatureDescriptor feature,
    List<String> routePrefixes,
    void Function() checkActive,
  ) async {
    final rollbacks = <VoidCallback>[];
    List<g.RouteBase>? originalRoutes;
    var replacingRoutes = false;
    try {
      checkActive();
      await feature.init?.call();
      checkActive();
      final featureRoutes = await feature.routes?.call() ?? <g.RouteBase>[];
      checkActive();

      // Capture every participant before mutating any registry.
      final descriptors = feature.extensions ?? <ExtensionDescriptor>[];
      for (final descriptor in descriptors) {
        final builder = _featureExtensionBuilderMap[descriptor.runtimeType];
        if (builder == null) {
          throw StateError(
            'Missing ExtensionBuilder for ${descriptor.runtimeType}',
          );
        }
        rollbacks.add(builder.captureLazyState(descriptor));
      }
      for (final descriptor in descriptors) {
        descriptor.setSourceFeature(feature.name);
        _featureExtensionBuilderMap[descriptor.runtimeType]!.registerLazy(
          descriptor,
        );
      }
      checkActive();
      originalRoutes = router.instance.configuration.routes.toList();
      final routes = originalRoutes
          .where(
            (route) =>
                route is! g.GoRoute || !routePrefixes.contains(route.path),
          )
          .toList();
      replacingRoutes = true;
      router.replaceRoutes([...routes, ...featureRoutes]);
      checkActive();
      _startFeatureHooks(feature);
      _features.add(feature);
      _readyFeatures[feature.name] = Future.value();
    } catch (error, stack) {
      _features.remove(feature);
      _stopFeatureHooks(feature.name);
      // Restore routing even if a custom navigation plugin mutates then throws.
      if (replacingRoutes && originalRoutes != null) {
        try {
          router.replaceRoutes(originalRoutes);
        } catch (rollbackError, rollbackStack) {
          telemetry.reportError(rollbackError, stackTrace: rollbackStack);
        }
      }
      for (final rollback in rollbacks.reversed) {
        try {
          rollback();
        } catch (rollbackError, rollbackStack) {
          telemetry.reportError(rollbackError, stackTrace: rollbackStack);
        }
      }
      try {
        await feature.dispose?.call();
      } catch (cleanupError, cleanupStack) {
        telemetry.reportError(cleanupError, stackTrace: cleanupStack);
      }
      Error.throwWithStackTrace(error, stack);
    }
  }

  /// Stops every running feature, in reverse order: cancels in-flight lazy
  /// loads, removes event handlers and redirects, then runs `dispose`.
  /// A feature whose `dispose` throws is reported and the rest still stop.
  Future<void> _disposeFeatures() async {
    _lazyFeatureManager.reset();
    await _lazyFeatureManager.drainActivations();
    _stopAllFeatureHooks();

    final running = _features.reversed.toList();
    _features = [];
    _readyFeatures.clear();
    for (final feature in running) {
      try {
        await feature.dispose?.call();
      } catch (error, stack) {
        try {
          telemetry.reportError(error, stackTrace: stack);
        } catch (_) {}
      }
    }
  }

  /// Subscribes the feature's event handlers and adds its redirects.
  void _startFeatureHooks(FeatureDescriptor feature) {
    _stopFeatureHooks(feature.name);
    _featureSubscriptions[feature.name] = [
      for (final handler in feature.events) handler.subscribe(event),
    ];
    router.featureRedirects.add(feature.name, feature.redirects);
  }

  /// Cancels the feature's event handlers and removes its redirects.
  void _stopFeatureHooks(String featureName) {
    for (final cancel in _featureSubscriptions.remove(featureName) ?? []) {
      cancel();
    }
    router.featureRedirects.remove(featureName);
  }

  void _stopAllFeatureHooks() {
    for (final name in _featureSubscriptions.keys.toList()) {
      _stopFeatureHooks(name);
    }
    router.featureRedirects.clear();
  }

  static bool _errorHandlersInstalled = false;

  /// Sends uncaught Flutter and platform errors to telemetry, keeping any
  /// handlers that were already installed. In release builds a widget that
  /// fails to build shows a themed placeholder instead of a grey box.
  void _installErrorHandlers() {
    // flutter_test owns these handlers and checks they are restored after
    // each test, so leave them alone there.
    if (_errorHandlersInstalled || isFlutterTest) return;
    // coverage:ignore-start
    _errorHandlersInstalled = true;

    final previousFlutterHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      try {
        telemetry.reportFlutterError(details);
      } catch (_) {}
      (previousFlutterHandler ?? FlutterError.presentError)(details);
    };

    final previousPlatformHandler = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      try {
        telemetry.reportError(error, stackTrace: stack);
      } catch (_) {}
      return previousPlatformHandler?.call(error, stack) ?? false;
    };

    if (!kDebugMode) {
      ErrorWidget.builder = (details) => BuildFailureView(details: details);
    }
    // coverage:ignore-end
  }

  /// Topologically sort features based on their [FeatureDescriptor.dependencies].
  static List<FeatureDescriptor> _topologicalSort(
    List<FeatureDescriptor> features,
  ) {
    // If no features have dependencies, return as-is (common case)
    if (features.every((f) => f.dependencies.isEmpty)) {
      return features;
    }

    final featureMap = {for (final f in features) f.name: f};
    final sorted = <FeatureDescriptor>[];
    final visited = <String>{};
    final visiting = <String>{}; // cycle detection

    void visit(String name) {
      if (visited.contains(name)) return;
      if (visiting.contains(name)) {
        throw StateError(
          'Circular dependency detected involving feature: $name',
        );
      }

      visiting.add(name);
      final feature = featureMap[name];
      if (feature == null) {
        throw StateError('No eager feature registered for dependency: $name');
      }
      for (final dep in feature.dependencies) {
        visit(dep);
      }
      sorted.add(feature);
      visiting.remove(name);
      visited.add(name);
    }

    for (final feature in features) {
      visit(feature.name);
    }

    return sorted;
  }

  @override
  bool isFeatureLoaded(String featureName) {
    // Check eager features
    if (_features.any((f) => f.name == featureName)) return true;

    // Check lazy features
    return _lazyFeatureManager.isLoaded(featureName);
  }

  @override
  Future<void> loadFeature(String featureName) async {
    // Already loaded as eager feature
    if (_features.any((f) => f.name == featureName)) return;

    // Load lazy feature
    await _lazyFeatureManager.loadFeature(featureName);
  }

  @override
  T? getPlugin<T extends Plugin>() => VyuhBinding.instance.get<T>();

  @override
  ExtensionBuilder? extensionBuilder<T extends ExtensionDescriptor>() {
    return _featureExtensionBuilderMap[T];
  }
}
