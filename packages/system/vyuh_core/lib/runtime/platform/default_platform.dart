import 'package:collection/collection.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/plugin/auth/anonymous_auth_plugin.dart';
import 'package:vyuh_core/runtime/platform/framework_init_view.dart';
import 'package:vyuh_core/runtime/platform/platform_init_tracker.dart';
import 'package:vyuh_core/vyuh_core.dart' as vt;
import 'package:vyuh_core/vyuh_core.dart';

final class DefaultVyuhPlatform extends VyuhPlatform {
  final Map<PluginType, Plugin> _pluginMap = {};
  final Map<Type, ExtensionBuilder> _featureExtensionBuilderMap = {};

  /// Initialize first time to avoid any late-init errors.
  /// Eventually this will be initialized anytime we restart the platform
  GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final SystemInitTracker _tracker;

  /// The initial Location that will be used by the router
  final String? initialLocation;

  @override
  GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  @override
  SystemInitTracker get tracker => _tracker;

  List<FeatureDescriptor> _features = [];

  @override
  List<vt.FeatureDescriptor> get features => _features;

  final Map<String, Future<void>> _readyFeatures = {};

  @override
  Future<void>? featureReady(String featureName) => _readyFeatures[featureName];

  DefaultVyuhPlatform({
    required super.featuresBuilder,
    required List<Plugin> plugins,
    required super.widgetBuilder,
    this.initialLocation,
  }) : super(plugins: _ensureRequiredPlugins(plugins)) {
    _tracker = PlatformInitTracker(this);

    for (final plugin in this.plugins) {
      _pluginMap[plugin.pluginType] = plugin;
    }

    reaction((_) => _tracker.currentState.value == InitState.notStarted,
        (notStarted) {
      if (notStarted) {
        // Ensure the navigator key is established everytime the system is restarted
        // This avoids the error of a duplicate GlobalKey across GoRouter instances
        _rootNavigatorKey = GlobalKey<NavigatorState>();
      }
    });
  }

  static List<Plugin> _ensureRequiredPlugins(List<Plugin> plugins) {
    // Ensure there is only one plugin for a PluginType
    final pluginTypes = plugins.groupListsBy((element) => element.pluginType);
    for (final entry in pluginTypes.entries) {
      assert(entry.value.length == 1,
          'There can be only one plugin for a pluginType. We found ${entry.value.length} for ${entry.key}');
    }

    final allPlugins = [...plugins];
    for (final type in VyuhPlatform.requiredPlugins) {
      // Put a default plugin instance when a required plugin is not explicitly given
      if (!allPlugins.any((element) => element.pluginType == type)) {
        final instance = type.defaultInstance();

        assert(instance != null,
            'The default instance for the required plugin: $type has not been provided.');

        if (instance != null) {
          allPlugins.add(instance);
        }
      }
    }

    return allPlugins;
  }

  @override
  Future<void> run() async {
    for (final plugin in VyuhPlatform.preloadedPlugins) {
      await _pluginMap[plugin]?.init();
    }

    flutter.runApp(const FrameworkInitView());
  }

  @override
  Future<void> initPlugins(vt.AnalyticsTrace parentTrace) =>
      analytics.runWithTrace(
          name: 'Plugins',
          operation: 'Init',
          parentTrace: parentTrace,
          fn: (trace) async {
            // Run a cleanup first
            final disposeFns = _pluginMap.entries.map((e) => e.value.dispose());
            await Future.wait(disposeFns, eagerError: true);

            // Check
            final initFns = _pluginMap.entries.map((e) {
              return analytics.runWithTrace<void>(
                name: 'Plugin: ${e.value.title}',
                operation: 'Init',
                parentTrace: trace,
                fn: (_) => e.value.init(),
              );
            });

            await Future.wait(initFns, eagerError: true);
          });

  @override
  Future<void> initFeatures(vt.AnalyticsTrace parentTrace) async {
    // Run a cleanup first
    final disposeFns =
        _features.where((e) => e.dispose != null).map((e) => e.dispose!());
    await Future.wait(disposeFns, eagerError: true);

    return analytics.runWithTrace<void>(
      name: 'Features',
      operation: 'Init',
      parentTrace: parentTrace,
      fn: (trace) async {
        _readyFeatures.clear();
        _features = await featuresBuilder();

        final initFns = _features
            .map((feature) => analytics.runWithTrace<List<g.RouteBase>>(
                  name: 'Feature: ${feature.title}',
                  operation: 'Init',
                  parentTrace: trace,
                  fn: (trace) {
                    final future = _initFeature(feature, trace);

                    _readyFeatures[feature.name] = future;

                    return future;
                  },
                ));

        final allRoutes = await Future.wait(initFns, eagerError: true);
        _initRouter(
          allRoutes
              .where((routes) => routes != null)
              .cast<List<g.RouteBase>>()
              .expand((routes) => routes)
              .toList(),
        );

        _initContent(_features);
        _initFeatureExtensions(_features);
      },
    );
  }

  void _initContent(List<vt.FeatureDescriptor> featureList) {
    content.setup(featureList);
  }

  Future<List<g.RouteBase>> _initFeature(
      FeatureDescriptor feature, vt.AnalyticsTrace? parentTrace) async {
    await feature.init?.call();

    if (feature.routes == null) {
      return [];
    }

    final featureRoutes = await analytics.runWithTrace<List<g.RouteBase>>(
      name: 'Routes: ${feature.title}',
      operation: 'Init',
      parentTrace: parentTrace,
      fn: (_) => feature.routes!(),
    );

    return featureRoutes ?? [];
  }

  Future<void> _initRouter(List<g.RouteBase> routes) async {
    router.initRouter(
      routes: routes,
      initialLocation: initialLocation ?? '/',
      rootNavigatorKey: _rootNavigatorKey,
    );
  }

  void _initFeatureExtensions(List<FeatureDescriptor> featureList) {
    // Run a cleanup first
    _features
        .expand((e) => e.extensionBuilders ?? <vt.ExtensionBuilder>[])
        .forEach((e) => e.dispose());

    final builders = featureList
        .expand((element) => element.extensionBuilders ?? <ExtensionBuilder>[])
        .groupListsBy((element) => element.extensionType);

    for (final entry in builders.entries) {
      assert(entry.value.length == 1,
          'There can be only one FeatureExtensionBuilder for a schema-type. We found ${entry.value.length} for ${entry.key}');

      _featureExtensionBuilderMap[entry.key] = entry.value.first;

      // Run one time init
      entry.value.first.init();
    }

    final extensions = featureList
        .expand((element) => element.extensions ?? <ExtensionDescriptor>[])
        .groupListsBy((element) => element.runtimeType);

    extensions.forEach((runtimeType, descriptors) {
      final builder = _featureExtensionBuilderMap[runtimeType];

      assert(builder != null,
          'Missing FeatureExtensionBuilder for FeatureExtensionDescriptor of schemaType: $runtimeType');

      builder?.build(descriptors);
    });
  }

  @override
  Plugin? getPlugin(PluginType type) => _pluginMap[type];
}

final class RoutingConfigNotifier extends ValueNotifier<g.RoutingConfig> {
  RoutingConfigNotifier(List<g.RouteBase> routes)
      : super(g.RoutingConfig(routes: routes));

  void setRoutes(List<g.RouteBase> routes) {
    value = g.RoutingConfig(routes: routes);
  }
}

extension on PluginType {
  Plugin? defaultInstance() => switch (this) {
        PluginType.analytics =>
          AnalyticsPlugin(providers: [NoOpAnalyticsProvider()]),
        PluginType.content => NoOpContentPlugin(),
        PluginType.di => GetItDIPlugin(),
        PluginType.network => HttpNetworkPlugin(),
        PluginType.auth => UnknownAuthPlugin(),
        PluginType.navigation => DefaultNavigationPlugin(),
        _ => null
      };
}
