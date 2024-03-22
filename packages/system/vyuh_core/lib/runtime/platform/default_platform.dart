import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/plugin_types/content/noop_content_plugin.dart';
import 'package:vyuh_core/runtime/platform/fallback_route_page_builder.dart';
import 'package:vyuh_core/runtime/platform/framework_init_view.dart';
import 'package:vyuh_core/runtime/platform/platform_init_tracker.dart';
import 'package:vyuh_core/vyuh_core.dart' as vt;
import 'package:vyuh_core/vyuh_core.dart';

final class DefaultVyuhPlatform extends VyuhPlatform {
  final Map<PluginType, Plugin> _pluginMap = {};
  final Map<Type, ExtensionBuilder> _featureExtensionBuilderMap = {};

  late RoutingConfigNotifier _routingConfig;

  late g.GoRouter _router;

  /// Initialize first time to avoid any late-init errors.
  /// Eventually this will be initialized anytime we restart the platform
  GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final SystemInitTracker _tracker;

  /// The initial Location that will be used by the router
  final String? initialLocation;

  @override
  g.GoRouter get router => _router;

  @override
  GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  @override
  SystemInitTracker get tracker => _tracker;

  final Map<String, Future<void>> _readyFeatures = {};

  @override
  Future<void>? featureReady(String featureName) => _readyFeatures[featureName];

  DefaultVyuhPlatform({
    required super.features,
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
  Future<void> initPlugins() =>
      analytics.runWithTrace('Init Plugins', () async {
        // Run a cleanup first
        final disposeFns = _pluginMap.entries.map((e) => e.value.dispose());
        await Future.wait(disposeFns, eagerError: true);

        // Check
        final initFns = _pluginMap.entries.map((e) {
          return analytics.runWithTrace<void>(
              'Init Plugin: ${e.value.title}', e.value.init);
        });

        await Future.wait(initFns, eagerError: true);
      });

  @override
  Future<void> initFeatures() =>
      analytics.runWithTrace<void>('Init Features', () async {
        _readyFeatures.clear();

        final initFns = features.map((feature) => analytics
                .runWithTrace<List<g.RouteBase>>(
                    'Init Feature: ${feature.title}', () {
              final future = _initFeature(feature);

              _readyFeatures[feature.name] = future;

              return future;
            }));

        final allRoutes = await Future.wait(initFns, eagerError: true);
        _initRouter(
          allRoutes
              .where((routes) => routes != null)
              .cast<List<g.RouteBase>>()
              .expand((routes) => routes)
              .toList()
            ..add(g.GoRoute(
              path: '/:path(.*)',
              pageBuilder: fallbackRoutePageBuilder,
            ))
            ..toList(growable: false),
        );

        _initContent();
        _initFeatureExtensions();
      });

  void _initContent() {
    content.setup(features);
  }

  Future<List<g.RouteBase>> _initFeature(FeatureDescriptor feature) async {
    await feature.init?.call();

    final featureRoutes = feature.routes == null
        ? null
        : await analytics.runWithTrace<List<g.RouteBase>>(
            'Init Routes: ${feature.title}', feature.routes!);

    return featureRoutes ?? [];
  }

  Future<void> _initRouter(List<g.RouteBase> routes) async {
    _routingConfig = RoutingConfigNotifier(routes);
    _router = g.GoRouter.routingConfig(
      initialLocation: initialLocation ?? '/',
      routingConfig: _routingConfig,
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: kDebugMode,
      observers: analytics.observers,
      errorBuilder: (_, state) => widgetBuilder.routeErrorView(
        path: state.matchedLocation,
        title: 'Failed to load route',
        error: state.error,
        onRetry: () {
          vyuh.tracker.init(tracker.currentState.value);
        },
      ),
    );
  }

  void _initFeatureExtensions() {
    final builders = features
        .expand((element) => element.extensionBuilders ?? <ExtensionBuilder>[])
        .groupListsBy((element) => element.extensionType);

    for (final entry in builders.entries) {
      assert(entry.value.length == 1,
          'There can be only one FeatureExtensionBuilder for a schema-type. We found ${entry.value.length} for ${entry.key}');

      _featureExtensionBuilderMap[entry.key] = entry.value.first;

      // Run one time init
      entry.value.first.init();
    }

    final extensions = features
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
        _ => null
      };
}
