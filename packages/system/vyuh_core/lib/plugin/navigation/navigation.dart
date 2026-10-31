import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

abstract class NavigationPlugin extends Plugin {
  GoRouter get instance;

  /// The path of a catch-all route. A feature can contribute one `GoRoute`
  /// with this path to handle every location no other route matches; the
  /// router always places it last. Without one, unmatched locations show the
  /// not-found [RouteFailureView].
  static const catchAllPath = '/:path(.*)';

  NavigationPlugin({required super.name, required super.title});

  /// Redirects contributed by features through [FeatureDescriptor.redirects].
  ///
  /// The platform adds and removes entries as features start and stop.
  /// Implementations evaluate them with [RedirectRegistry.evaluate] and call
  /// [watchRedirectTriggers] so they re-run when their triggers fire.
  final RedirectRegistry featureRedirects = RedirectRegistry();

  /// Calls [refresh] whenever a feature redirect's trigger fires: one of its
  /// `refreshOn` events is emitted, or its `listenable` notifies. Also calls
  /// [refresh] when the set of redirects changes. Returns a function that
  /// stops watching.
  @protected
  VoidCallback watchRedirectTriggers(VoidCallback refresh) {
    Listenable? merged;

    void rewatch() {
      merged?.removeListener(refresh);
      final listenables = featureRedirects.listenables;
      merged = listenables.isEmpty ? null : Listenable.merge(listenables);
      merged?.addListener(refresh);
    }

    void onRedirectsChanged() {
      rewatch();
      refresh();
    }

    rewatch();
    featureRedirects.addListener(onRedirectsChanged);
    final cancelEvents = vyuh.event.on<VyuhEvent>((event) {
      if (featureRedirects.refreshesOn(event.runtimeType)) refresh();
    });

    return () {
      cancelEvents();
      featureRedirects.removeListener(onRedirectsChanged);
      merged?.removeListener(refresh);
      merged = null;
    };
  }

  /// The location of the home route, used by error views to offer a way
  /// back. Set by the platform from `runApp(homeLocation: ...)`.
  String homeLocation = '/';

  /// Navigates to [homeLocation].
  void goHome() => go(homeLocation);

  void initRouter({
    String? initialLocation,
    required List<g.RouteBase> routes,
    required GlobalKey<NavigatorState> rootNavigatorKey,
  });

  void replaceRoutes(List<g.RouteBase> routes);

  void appendRoutes(List<g.RouteBase> routes);

  void appendInitialRoutes(List<g.RouteBase> routes);

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

  Future<T?> pushReplacement<T extends Object?>(
    String location, {
    Object? extra,
  });

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
