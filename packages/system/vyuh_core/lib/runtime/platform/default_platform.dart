part of '../run_app.dart';

final class _DefaultVyuhPlatform extends VyuhPlatform {
  /// We only track this to pass it on to [VyuhBinding]
  final PluginDescriptor _pluginDescriptor;

  /// We only track this to pass it on to [VyuhBinding]
  final PlatformWidgetBuilder _widgetBuilder;

  final Map<Type, ExtensionBuilder> _featureExtensionBuilderMap = {};

  /// Initialize first time to avoid any late-init errors.
  /// Eventually this will be initialized anytime we restart the platform
  GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final SystemInitTracker _tracker;

  String _userInitialLocation = '/';

  /// The initial Location that will be used by the router
  final String? initialLocation;

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

  @override
  List<Plugin> get plugins => VyuhBinding.instance.plugins;

  @override
  PlatformWidgetBuilder get widgetBuilder => VyuhBinding.instance.widgetBuilder;

  _DefaultVyuhPlatform({
    required FeaturesBuilder featuresBuilder,
    required PluginDescriptor pluginDescriptor,
    required PlatformWidgetBuilder widgetBuilder,
    this.initialLocation,
  })  : _featuresBuilder = featuresBuilder,
        _pluginDescriptor = pluginDescriptor,
        _widgetBuilder = widgetBuilder {
    _tracker = _PlatformInitTracker(this);
  }

  @override
  Future<void> run() async {
    VyuhBinding.instance
        ._appInit(plugins: _pluginDescriptor, widgetBuilder: _widgetBuilder);

    _userInitialLocation = PlatformDispatcher.instance.defaultRouteName;

    flutter.runApp(const _FrameworkInitView());
  }

  @override
  Future<void> dispose() async {
    if (!VyuhBinding.instance.initialized) {
      return;
    }

    await VyuhBinding.instance._appDispose();

    _features.clear();
    _readyFeatures.clear();
    _featureExtensionBuilderMap.clear();
    _userInitialLocation = '';
  }

  @override
  Future<void> initPlugins(Trace parentTrace) => telemetry.trace(
      name: 'Plugins',
      operation: 'Init',
      parentTrace: parentTrace,
      fn: (trace) async {
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
      });

  @override
  Future<void> initFeatures(Trace parentTrace) async {
    // Run a cleanup first
    final disposeFns =
        _features.where((e) => e.dispose != null).map((e) => e.dispose!());
    await Future.wait(disposeFns, eagerError: true);

    return telemetry.trace<void>(
      name: 'Features',
      operation: 'Init',
      parentTrace: parentTrace,
      fn: (trace) async {
        _readyFeatures.clear();
        _features = await _featuresBuilder();

        // Ensure feature names are unique
        final featureNames = <String>{};
        for (final feature in _features) {
          if (featureNames.contains(feature.name)) {
            throw StateError(
                'Feature name "${feature.name}" is not unique. Ensure only uniquely named features are included.');
          } else {
            featureNames.add(feature.name);
          }
        }

        final initFns =
            _features.map((feature) => telemetry.trace<List<g.RouteBase>>(
                  name: 'Feature: ${feature.title}',
                  operation: 'Init',
                  parentTrace: trace,
                  fn: (trace) {
                    final future = _initFeature(feature, trace);

                    _readyFeatures[feature.name] = future;

                    return future;
                  },
                ));

        await telemetry.trace<void>(
          name: 'Feature Routes',
          operation: 'Init',
          parentTrace: trace,
          fn: (_) async {
            final allRoutes = await Future.wait(initFns, eagerError: true);

            return _initRouter(
              allRoutes
                  .where((routes) => routes != null)
                  .cast<List<g.RouteBase>>()
                  .expand((routes) => routes)
                  .toList(),
            );
          },
        );

        return telemetry.trace<void>(
          name: 'Feature Extensions',
          operation: 'Init',
          parentTrace: trace,
          fn: (_) => _initFeatureExtensions(_features),
        );
      },
    );
  }

  Future<List<g.RouteBase>> _initFeature(
      FeatureDescriptor feature, Trace? parentTrace) async {
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

    router.initRouter(
      routes: routes,
      initialLocation: _userInitialLocation == '/'
          ? initialLocation ?? '/'
          : _userInitialLocation,
      rootNavigatorKey: _rootNavigatorKey,
    );
  }

  Future<void> _initFeatureExtensions(List<FeatureDescriptor> features) async {
    final disposeFutures = <Future<void>>[];

    final builders = features
        .expand((element) => element.extensionBuilders ?? <ExtensionBuilder>[]);

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
    final groupedBuilders =
        builders.groupListsBy((element) => element.extensionType);

    for (final entry in groupedBuilders.entries) {
      assert(entry.value.length == 1,
          'There can be only one FeatureExtensionBuilder for a schema-type. We found ${entry.value.length} for ${entry.key}');

      _featureExtensionBuilderMap[entry.key] = entry.value.first;
    }

    final extensions = features
        .expand((element) => element.extensions ?? <ExtensionDescriptor>[])
        .groupListsBy((element) => element.runtimeType);

    // Ensure for every ExtensionDescriptor, there is a corresponding ExtensionBuilder registered
    extensions.forEach((runtimeType, descriptors) {
      final builder = _featureExtensionBuilderMap[runtimeType];

      assert(builder != null,
          'Missing ExtensionBuilder for ExtensionDescriptor of schemaType: $runtimeType');
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

  @override
  T? getPlugin<T extends Plugin>() => VyuhBinding.instance.get<T>();

  @override
  ExtensionBuilder? extensionBuilder<T extends ExtensionDescriptor>() {
    return _featureExtensionBuilderMap[T];
  }
}
