import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/runtime/platform/default_platform.dart';
import 'package:vyuh_core/runtime/platform/fallback_route_page_builder.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract class NavigationPlugin extends Plugin {
  GoRouter get instance;

  static final fallbackRoute = GoRoute(
    path: '/:path(.*)',
    pageBuilder: fallbackRoutePageBuilder,
  );

  NavigationPlugin({required super.name, required super.title})
      : super(pluginType: PluginType.navigation);

  void initRouter({
    String? initialLocation,
    required List<g.RouteBase> routes,
    required GlobalKey<NavigatorState> rootNavigatorKey,
  });

  void replaceRoutes(List<g.RouteBase> routes);

  void appendRoutes(List<g.RouteBase> routes);

  void pop<T extends Object?>([T? result]);

  void go(String location, {Object? extra});

  void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  });

  Future<T?> push<T extends Object?>(String location, {Object? extra});

  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  });

  Future<T?> pushReplacement<T extends Object?>(String location,
      {Object? extra});

  Future<T?> pushReplacementNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  });

  Future<T?> replace<T extends Object?>(String location, {Object? extra});

  Future<T?> replaceNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  });
}

final class DefaultNavigationPlugin extends NavigationPlugin {
  GoRouter _router = GoRouter(routes: []);

  final RoutingConfigNotifier _routingConfig = RoutingConfigNotifier([]);

  DefaultNavigationPlugin()
      : super(
          name: 'vyuh.plugin.navigation.default',
          title: 'Default Navigation Plugin (GoRouter)',
        );

  @override
  GoRouter get instance => _router;

  @override
  void initRouter(
      {String? initialLocation,
      required List<g.RouteBase> routes,
      required GlobalKey<NavigatorState> rootNavigatorKey}) {
    final allRoutes = _finalizeRoutes(routes);
    _routingConfig.value = RoutingConfig(routes: allRoutes);

    _router = GoRouter.routingConfig(
      initialLocation: initialLocation ?? '/',
      routingConfig: _routingConfig,
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: kDebugMode,
      observers: vyuh.analytics.observers,
      errorBuilder: (_, state) => vyuh.widgetBuilder.routeErrorView(
        title: 'Failed to load route',
        subtitle: state.matchedLocation,
        error: state.error,
        onRetry: () {
          vyuh.tracker.init(vyuh.tracker.currentState.value);
        },
      ),
    );
  }

  @override
  replaceRoutes(List<g.RouteBase> routes) {
    // Ensure we have a fallback route at the very end
    final newRoutes = _finalizeRoutes(routes);

    _routingConfig.value = RoutingConfig(routes: newRoutes);
  }

  @override
  appendRoutes(List<g.RouteBase> routes) {
    final currentRoutes = _routingConfig.value.routes;

    replaceRoutes([
      ...currentRoutes,
      ...routes,
    ]);
  }

  List<g.RouteBase> _finalizeRoutes(List<g.RouteBase> routes) {
    routes.removeWhere((r) => r == NavigationPlugin.fallbackRoute);

    return [
      ...routes,
      NavigationPlugin.fallbackRoute,
    ];
  }

  @override
  Future<void> init() {
    return Future.value();
  }

  @override
  Future<void> dispose() {
    return Future.value();
  }

  @override
  void go(String location, {Object? extra}) {
    instance.go(location, extra: extra);
  }

  @override
  void goNamed(String name,
      {Map<String, String> pathParameters = const <String, String>{},
      Map<String, dynamic> queryParameters = const <String, dynamic>{},
      Object? extra}) {
    instance.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  @override
  void pop<T extends Object?>([T? result]) {
    instance.pop(result);
  }

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    return instance.push(location, extra: extra);
  }

  @override
  Future<T?> pushNamed<T extends Object?>(String name,
      {Map<String, String> pathParameters = const <String, String>{},
      Map<String, dynamic> queryParameters = const <String, dynamic>{},
      Object? extra}) {
    return instance.pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  @override
  Future<T?> pushReplacement<T extends Object?>(String location,
      {Object? extra}) {
    return instance.pushReplacement(location, extra: extra);
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?>(String name,
      {Map<String, String> pathParameters = const <String, String>{},
      Map<String, dynamic> queryParameters = const <String, dynamic>{},
      Object? extra}) {
    return instance.pushReplacementNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  @override
  Future<T?> replace<T extends Object?>(String location, {Object? extra}) {
    return instance.replace(location, extra: extra);
  }

  @override
  Future<T?> replaceNamed<T extends Object?>(String name,
      {Map<String, String> pathParameters = const <String, String>{},
      Map<String, dynamic> queryParameters = const <String, dynamic>{},
      Object? extra}) {
    return instance.replaceNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}
