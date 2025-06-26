import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart' as strategy;
import 'package:go_router/go_router.dart' as g;
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class DefaultNavigationPlugin extends NavigationPlugin {
  GoRouter _router = GoRouter(routes: []);

  var _routingConfig = RoutingConfigNotifier([]);
  static g.GoRouterRedirect? _redirect;

  final bool includeFallbackRoute;

  DefaultNavigationPlugin({
    this.includeFallbackRoute = true,
    final bool urlReflectsImperativeAPIs = false,
    g.GoRouterRedirect? redirect,
  }) : super(
          name: 'vyuh.plugin.navigation.default',
          title: 'Default Navigation Plugin (GoRouter)',
        ) {
    if (urlReflectsImperativeAPIs) {
      enableURLReflectsImperativeAPIs();
    }

    if (redirect != null) {
      setRouterRedirect(redirect);
    }
  }

  @override
  GoRouter get instance => _router;

  static void enableURLReflectsImperativeAPIs() {
    GoRouter.optionURLReflectsImperativeAPIs = true;
  }

  static void usePathStrategy() {
    strategy.usePathUrlStrategy();
  }

  static void useHashStrategy() {
    strategy.setUrlStrategy(const strategy.HashUrlStrategy());
  }

  static void setRouterRedirect(g.GoRouterRedirect redirect) {
    _redirect = redirect;
  }

  @override
  void initRouter(
      {String? initialLocation,
      required List<g.RouteBase> routes,
      required GlobalKey<NavigatorState> rootNavigatorKey}) {
    final allRoutes = _finalizeRoutes(routes);
    _routingConfig = RoutingConfigNotifier(allRoutes, redirect: _redirect);

    final observers = vyuh.plugins
        .whereType<RouteObservers>()
        .expand((p) => p.observers)
        .toList();

    _router = GoRouter.routingConfig(
      initialLocation: initialLocation ?? '/',
      routingConfig: _routingConfig,
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: kDebugMode,
      observers: observers,
      errorBuilder: (context, state) => vyuh.widgetBuilder.routeErrorView(
        context,
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
    if (includeFallbackRoute) {
      final fallbackRoutes = routes.where((r) {
        final isFallbackRoute = r == NavigationPlugin.fallbackRoute;
        final hasFallbackPath =
            r is GoRoute && r.path == NavigationPlugin.fallbackRoute.path;
        return isFallbackRoute || hasFallbackPath;
      }).toList(growable: false);

      if (fallbackRoutes.isNotEmpty) {
        vyuh.log.warn(
            ('We found one or more fallback Routes "/:path(.*)", which will be removed'));
      }

      for (final route in fallbackRoutes) {
        routes.remove(route);
      }

      return [
        ...routes,
        NavigationPlugin.fallbackRoute,
      ];
    }

    return routes;
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

final class RoutingConfigNotifier extends ValueNotifier<g.RoutingConfig> {
  final g.GoRouterRedirect? redirect;

  RoutingConfigNotifier(List<g.RouteBase> routes, {this.redirect})
      : super(redirect == null
            ? g.RoutingConfig(routes: routes)
            : g.RoutingConfig(routes: routes, redirect: redirect));

  void setRoutes(List<g.RouteBase> routes) {
    value = redirect == null
        ? g.RoutingConfig(routes: routes)
        : g.RoutingConfig(routes: routes, redirect: redirect!);
  }
}
