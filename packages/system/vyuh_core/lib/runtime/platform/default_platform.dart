part of '../run_app.dart';

class _PluginInstanceCache {
  final Set<Plugin> _plugins = {};

  _PluginInstanceCache();

  final Map<Type, Plugin?> _pluginsMap = {};

  T? getPlugin<T extends Plugin>() {
    if (_pluginsMap.containsKey(T)) {
      return _pluginsMap[T] as T?;
    }

    final plugin = _plugins.firstWhereOrNull((final plugin) => plugin is T);

    _pluginsMap[T] = plugin;

    return plugin as T?;
  }

  /// Add Items to List.
  ///
  /// NOTE: This remove the Lookup cache.
  void addAll(Iterable<Plugin> plugins) {
    _plugins.addAll(plugins);
    _pluginsMap.clear();
  }

  // Get the list
  List<Plugin> get items => List.unmodifiable(_plugins);
}

final class _DefaultVyuhPlatform extends VyuhPlatform {
  final _PluginInstanceCache _plugins = _PluginInstanceCache();

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
  List<vc.FeatureDescriptor> get features => _features;

  final Map<String, Future<void>> _readyFeatures = {};

  @override
  Future<void>? featureReady(String featureName) => _readyFeatures[featureName];

  final FeaturesBuilder _featuresBuilder;

  @override
  List<Plugin> get plugins => _plugins.items;

  @override
  final PlatformWidgetBuilder widgetBuilder;

  _DefaultVyuhPlatform({
    required FeaturesBuilder featuresBuilder,
    required PluginDescriptor pluginDescriptor,
    required this.widgetBuilder,
    this.initialLocation,
  }) : _featuresBuilder = featuresBuilder {
    _plugins.addAll(pluginDescriptor.plugins);

    _tracker = _PlatformInitTracker(this);
  }

  @override
  Future<void> run() async {
    final preLoadedPlugins = plugins.whereType<vc.PreloadedPlugin>();

    for (final plugin in preLoadedPlugins) {
      await plugin.init();
    }

    _userInitialLocation = PlatformDispatcher.instance.defaultRouteName;

    flutter.runApp(const _FrameworkInitView());
  }

  @override
  Future<void> initPlugins(vc.Trace parentTrace) => telemetry.trace(
      name: 'Plugins',
      operation: 'Init',
      parentTrace: parentTrace,
      fn: (trace) async {
        // Run a cleanup first
        final disposeFns = plugins.map((e) => e.dispose());
        await Future.wait(disposeFns, eagerError: true);

        // Check
        final initFns = plugins.map((e) {
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
  Future<void> initFeatures(vc.Trace parentTrace) async {
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
      FeatureDescriptor feature, vc.Trace? parentTrace) async {
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
        fn: (_) => builder.init(extensions[entry.key] ?? []),
      );
    }
  }

  @override
  T? getPlugin<T extends vc.Plugin>() => _plugins.getPlugin<T>();

  @override
  ExtensionBuilder? getExtensionBuilder<T extends ExtensionDescriptor>() {
    return _featureExtensionBuilderMap[T];
  }
}
