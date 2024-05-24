import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract class NavigationPlugin extends Plugin {
  GoRouter get instance;

  NavigationPlugin({required super.name, required super.title})
      : super(pluginType: PluginType.navigation);

  void setRouter(GoRouter router);

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
  GoRouter _router = GoRouter(
    routes: [],
  );

  DefaultNavigationPlugin()
      : super(
          name: 'vyuh.plugin.navigation.default',
          title: 'Default Navigation Plugin (GoRouter)',
        );

  @override
  GoRouter get instance => _router;

  @override
  void setRouter(GoRouter router) {
    _router = router;
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
