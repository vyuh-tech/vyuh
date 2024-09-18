import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/plugin/navigation/fallback_route_page_builder.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract class NavigationPlugin extends Plugin {
  GoRouter get instance;

  static final fallbackRoute = GoRoute(
    path: '/:path(.*)',
    pageBuilder: fallbackRoutePageBuilder,
  );

  NavigationPlugin({required super.name, required super.title});

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
