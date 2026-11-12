import 'dart:convert';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart' as strategy;
import 'package:go_router/go_router.dart' as g;
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// How URLs look on the web. Has no effect on other platforms.
enum RouterUrlStyle {
  /// `example.com/#/orders` (Flutter's default).
  hash,

  /// `example.com/orders`. Your host must serve the app for every path.
  path,
}

final class DefaultNavigationPlugin extends NavigationPlugin {
  GoRouter _router = GoRouter(routes: []);

  var _routingConfig = RoutingConfigNotifier([]);

  /// The global redirect for this router, run before every feature redirect.
  final g.GoRouterRedirect? redirect;

  /// Intercepts transitions before redirect evaluation.
  final g.OnEnter? onEnter;
  final int redirectLimit;
  final Listenable? refreshListenable;
  final g.GoExceptionHandler? onException;
  final g.GoRouterWidgetBuilder? errorBuilder;
  final g.GoRouterPageBuilder? errorPageBuilder;
  final Codec<Object?, Object?>? extraCodec;
  final String? restorationScopeId;
  final bool requestFocus;
  final bool routerNeglect;
  final bool overridePlatformDefaultLocation;

  static g.GoRouterRedirect? _legacyRedirect;

  g.GoRouterRedirect? get _redirect => redirect ?? _legacyRedirect;

  var _initialized = false;
  final List<g.RouteBase> _initialRoutes = [];
  VoidCallback? _stopWatchingRedirects;

  /// Creates the GoRouter-based navigation plugin.
  ///
  /// * [redirect]: a global redirect, run before every feature redirect.
  /// * [urlStyle]: hash or path URLs on the web. Applied immediately, so
  ///   create the plugin before `runApp`.
  /// * [urlReflectsImperativeAPIs]: whether `push` and friends update the
  ///   browser URL.
  DefaultNavigationPlugin({
    bool urlReflectsImperativeAPIs = false,
    this.redirect,
    super.maxRetainedBranches,
    this.onEnter,
    this.redirectLimit = 5,
    this.refreshListenable,
    this.onException,
    this.errorBuilder,
    this.errorPageBuilder,
    this.extraCodec,
    this.restorationScopeId,
    this.requestFocus = true,
    this.routerNeglect = false,
    this.overridePlatformDefaultLocation = false,
    RouterUrlStyle? urlStyle,
  }) : super(
         name: 'vyuh.plugin.navigation.default',
         title: 'Default Navigation Plugin (GoRouter)',
       ) {
    if (urlReflectsImperativeAPIs) {
      enableURLReflectsImperativeAPIs();
    }

    switch (urlStyle) {
      case RouterUrlStyle.path:
        usePathStrategy();
      case RouterUrlStyle.hash:
        useHashStrategy();
      case null:
        break;
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

  @Deprecated(
    'Pass redirect to the DefaultNavigationPlugin constructor, or contribute '
    'FeatureDescriptor.redirects. This global applies to every instance.',
  )
  static void setRouterRedirect(g.GoRouterRedirect redirect) {
    _legacyRedirect = redirect;
  }

  @override
  void initRouter({
    String? initialLocation,
    required List<g.RouteBase> routes,
    required GlobalKey<NavigatorState> rootNavigatorKey,
  }) {
    if (_initialized) {
      throw StateError('Router already initialized');
    }

    final allRoutes = _finalizeRoutes([...routes, ..._initialRoutes]);
    _routingConfig = RoutingConfigNotifier(
      allRoutes,
      redirect: _composedRedirect,
      onEnter: onEnter,
      redirectLimit: redirectLimit,
    );

    final observers = vyuh.plugins
        .whereType<RouteObservers>()
        .expand((p) => p.observers)
        .toList();

    _router.dispose();
    _router = GoRouter.routingConfig(
      initialLocation: initialLocation ?? '/',
      routingConfig: _routingConfig,
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: kDebugMode,
      observers: observers,
      refreshListenable: refreshListenable,
      onException: onException,
      errorPageBuilder: onException == null ? errorPageBuilder : null,
      extraCodec: extraCodec,
      restorationScopeId: restorationScopeId,
      requestFocus: requestFocus,
      routerNeglect: routerNeglect,
      overridePlatformDefaultLocation: overridePlatformDefaultLocation,
      errorBuilder: onException != null || errorPageBuilder != null
          ? null
          : errorBuilder ?? _buildError,
    );

    _stopWatchingRedirects?.call();
    _stopWatchingRedirects = watchRedirectTriggers(() => _router.refresh());

    _initialized = true;
  }

  Widget _buildError(BuildContext context, GoRouterState state) =>
      RouteFailureView(
        failure: VyuhFailure(
          kind: FailureKind.notFound,
          title: VyuhStrings.current.pageNotFoundTitle,
          message: VyuhStrings.current.noRouteMessage(state.uri),
          error: state.error,
          location: state.uri,
        ),
        onRetry: () => _router.refresh(),
      );

  @override
  replaceRoutes(List<g.RouteBase> routes) {
    // Ensure we have a fallback route at the very end
    final newRoutes = _finalizeRoutes(routes);

    _routingConfig.setRoutes(newRoutes);
  }

  @override
  void appendInitialRoutes(List<g.RouteBase> routes) {
    if (_initialized) {
      throw StateError(
        'Cannot append initial routes after Router is initialized',
      );
    }

    _initialRoutes.addAll(routes);
  }

  @override
  appendRoutes(List<g.RouteBase> routes) {
    final currentRoutes = _routingConfig.value.routes;

    replaceRoutes([...currentRoutes, ...routes]);
  }

  /// Keeps one catch-all route (path [NavigationPlugin.catchAllPath]) and
  /// moves it to the end, so it only sees locations no other route matches.
  List<g.RouteBase> _finalizeRoutes(List<g.RouteBase> routes) {
    bool isCatchAll(g.RouteBase r) =>
        r is GoRoute && r.path == NavigationPlugin.catchAllPath;

    final catchAll = routes.where(isCatchAll).toList(growable: false);
    if (catchAll.isEmpty) {
      return routes;
    }

    if (catchAll.length > 1) {
      vyuh.log.warn(
        'Found ${catchAll.length} catch-all routes "${NavigationPlugin.catchAllPath}". '
        'Only the first one is used.',
      );
    }

    return [...routes.where((r) => !isCatchAll(r)), catchAll.first];
  }

  @override
  Future<void> init() {
    _initialized = false;
    _initialRoutes.clear();
    _routingConfig = RoutingConfigNotifier(
      _initialRoutes,
      redirect: _composedRedirect,
      onEnter: onEnter,
      redirectLimit: redirectLimit,
    );

    return Future.value();
  }

  /// The global redirect first, then every feature redirect in order.
  Future<String?> _composedRedirect(
    BuildContext context,
    g.GoRouterState state,
  ) => featureRedirects.evaluate(context, state, base: _redirect);

  @override
  Future<void> dispose() {
    _stopWatchingRedirects?.call();
    _stopWatchingRedirects = null;
    if (_initialized) {
      _router.dispose();
      _routingConfig.dispose();
      _router = GoRouter(routes: []);
      _initialRoutes.clear();
      _initialized = false;
    }

    return Future.value();
  }

  @override
  void go(String location, {Object? extra}) {
    instance.go(location, extra: extra);
  }

  @override
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
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
  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    return instance.pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  @override
  Future<T?> pushReplacement<T extends Object?>(
    String location, {
    Object? extra,
  }) {
    return instance.pushReplacement(location, extra: extra);
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
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
  Future<T?> replaceNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
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
  final g.OnEnter? onEnter;
  final int redirectLimit;

  RoutingConfigNotifier(
    List<g.RouteBase> routes, {
    this.redirect,
    this.onEnter,
    this.redirectLimit = 5,
  }) : super(_configuration(routes, redirect, onEnter, redirectLimit));

  void setRoutes(List<g.RouteBase> routes) {
    value = _configuration(routes, redirect, onEnter, redirectLimit);
  }

  static g.RoutingConfig _configuration(
    List<g.RouteBase> routes,
    g.GoRouterRedirect? redirect,
    g.OnEnter? onEnter,
    int redirectLimit,
  ) => g.RoutingConfig(
    routes: routes,
    onEnter: onEnter,
    redirect: redirect ?? (_, _) => null,
    redirectLimit: redirectLimit,
  );
}
