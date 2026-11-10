import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

import 'helpers.dart';

/// A builder whose `isInitialized` check fails, as a broken third-party
/// builder might.
class _BrokenCheckBuilder extends TestBuilder {
  @override
  bool get isInitialized => throw StateError('cannot tell');
}

/// A builder that supports lazy registration, with hooks to make it fail.
class _LazyBuilder extends TestBuilder {
  final bool failRegister;
  final bool failRollback;
  final List<String> calls = [];

  _LazyBuilder({this.failRegister = false, this.failRollback = false});

  @override
  VoidCallback captureLazyState(vc.ExtensionDescriptor descriptor) {
    calls.add('capture');
    return () {
      calls.add('rollback');
      if (failRollback) throw StateError('rollback failed');
    };
  }

  @override
  void registerLazy(vc.ExtensionDescriptor descriptor) {
    calls.add('register');
    if (failRegister) throw StateError('register failed');
  }
}

/// A navigation plugin that can fail to replace routes.
final class _FlakyNavigation extends vc.NavigationPlugin {
  final inner = vc.DefaultNavigationPlugin();
  bool failReplace = false;

  _FlakyNavigation() : super(name: 'test.navigation', title: 'Flaky');

  @override
  GoRouter get instance => inner.instance;

  @override
  void initRouter({
    String? initialLocation,
    required List<RouteBase> routes,
    required GlobalKey<NavigatorState> rootNavigatorKey,
  }) => inner.initRouter(
    initialLocation: initialLocation,
    routes: routes,
    rootNavigatorKey: rootNavigatorKey,
  );

  @override
  void replaceRoutes(List<RouteBase> routes) {
    if (failReplace) throw StateError('replace failed');
    inner.replaceRoutes(routes);
  }

  @override
  void appendRoutes(List<RouteBase> routes) => inner.appendRoutes(routes);

  @override
  void appendInitialRoutes(List<RouteBase> routes) =>
      inner.appendInitialRoutes(routes);

  @override
  void go(String location, {Object? extra}) => inner.go(location);

  @override
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) => throw UnimplementedError();

  @override
  void pop<T extends Object?>([T? result]) => inner.pop(result);

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) =>
      throw UnimplementedError();

  @override
  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) => throw UnimplementedError();

  @override
  Future<T?> pushReplacement<T extends Object?>(
    String location, {
    Object? extra,
  }) => throw UnimplementedError();

  @override
  Future<T?> pushReplacementNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) => throw UnimplementedError();

  @override
  Future<T?> replace<T extends Object?>(String location, {Object? extra}) =>
      throw UnimplementedError();

  @override
  Future<T?> replaceNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) => throw UnimplementedError();

  @override
  Future<void> init() => inner.init();

  @override
  Future<void> dispose() => inner.dispose();
}

void main() {
  tearDown(disposePlatform);

  testWidgets('the root navigator key belongs to the running router', (
    tester,
  ) async {
    vc.runApp(features: () => [home()]);
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    expect(vc.vyuh.rootNavigatorKey.currentState, isNotNull);
  });

  testWidgets('a deep link wins over the initial location', (tester) async {
    tester.platformDispatcher.defaultRouteNameTestValue = '/deep';
    addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);

    vc.runApp(
      features: () => [
        feature('app', routes: [page('/'), page('/deep')]),
      ],
      initialLocation: '/',
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    expect(find.text('page /deep'), findsOneWidget);
  });

  testWidgets('a feature whose route builder returns null has no routes', (
    tester,
  ) async {
    vc.runApp(
      features: () => [
        home(),
        vc.FeatureDescriptor(name: 'empty', title: 'Empty', routes: () => null),
      ],
    );
    await vc.vyuh.getReady(tester);

    expect(vc.vyuh.tracker.currentState.value, vc.InitState.ready);
    expect(vc.vyuh.isFeatureLoaded('empty'), isTrue);
  });

  testWidgets('a lazy feature cannot reuse an eager feature name', (
    tester,
  ) async {
    vc.runApp(
      features: () => [home()],
      lazyFeatures: () => [
        vc.LazyFeatureDescriptor(
          name: 'home',
          title: 'Home again',
          routePrefixes: ['/again'],
          loader: () async => home(),
        ),
      ],
    );
    await vc.vyuh.getReady(tester);

    expect(
      vc.vyuh.tracker.error,
      isA<StateError>().having(
        (e) => e.message,
        'message',
        contains('Lazy feature name "home" is not unique'),
      ),
    );
  });

  testWidgets('circular eager dependencies fail startup', (tester) async {
    vc.runApp(
      features: () => [
        feature('a', dependencies: ['b']),
        feature('b', dependencies: ['a']),
      ],
    );
    await vc.vyuh.getReady(tester);

    expect(
      vc.vyuh.tracker.error,
      isA<StateError>().having(
        (e) => e.message,
        'message',
        contains('Circular dependency'),
      ),
    );
  });

  group('extension builders', () {
    testWidgets('extensionBuilder<T>() returns the registered builder', (
      tester,
    ) async {
      final builder = TestBuilder();
      final descriptor = TestDescriptor();
      vc.runApp(
        features: () => [
          feature(
            'home',
            routes: [page('/')],
            extensionBuilders: [builder],
            extensions: [descriptor],
          ),
        ],
      );
      await vc.vyuh.getReady(tester);

      expect(vc.vyuh.extensionBuilder<TestDescriptor>(), same(builder));
      expect(builder.registered, [descriptor]);
      expect(descriptor.sourceFeature, 'home');
    });

    testWidgets('a builder that fails its initialized check is reported, '
        'and still starts', (tester) async {
      final telemetry = RecordingTelemetry();
      final builder = _BrokenCheckBuilder();
      vc.runApp(
        plugins: recordingPlugins(telemetry),
        features: () => [
          feature('home', routes: [page('/')], extensionBuilders: [builder]),
        ],
      );
      await vc.vyuh.getReady(tester);

      expect(vc.vyuh.tracker.currentState.value, vc.InitState.ready);
      expect(
        telemetry.errors,
        contains(
          isA<StateError>().having((e) => e.message, 'm', 'cannot tell'),
        ),
      );
    });

    testWidgets('two builders for one extension type fail startup', (
      tester,
    ) async {
      vc.runApp(
        features: () => [
          feature('a', extensionBuilders: [TestBuilder(title: 'one')]),
          feature('b', extensionBuilders: [TestBuilder(title: 'two')]),
        ],
      );
      await vc.vyuh.getReady(tester);

      expect(
        vc.vyuh.tracker.error,
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('only one ExtensionBuilder for TestDescriptor'),
        ),
      );
    });
  });

  group('lazy activation rollback', () {
    vc.LazyFeatureDescriptor lazy(vc.FeatureDescriptor Function() load) =>
        vc.LazyFeatureDescriptor(
          name: 'lazy',
          title: 'Lazy',
          routePrefixes: ['/lazy'],
          loader: () async => load(),
        );

    testWidgets('a lazy extension without a builder fails to load', (
      tester,
    ) async {
      vc.runApp(
        features: () => [home()],
        lazyFeatures: () => [
          lazy(() => feature('lazy', extensions: [TestDescriptor()])),
        ],
      );
      await vc.vyuh.getReady(tester);

      await expectLater(
        vc.vyuh.loadFeature('lazy'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Missing ExtensionBuilder for TestDescriptor',
          ),
        ),
      );
      expect(vc.vyuh.isFeatureLoaded('lazy'), isFalse);
    });

    testWidgets('a failed lazy registration rolls back, reporting rollback '
        'and dispose failures', (tester) async {
      final telemetry = RecordingTelemetry();
      final builder = _LazyBuilder(failRegister: true, failRollback: true);
      vc.runApp(
        plugins: recordingPlugins(telemetry),
        features: () => [
          feature('home', routes: [page('/')], extensionBuilders: [builder]),
        ],
        lazyFeatures: () => [
          lazy(
            () => feature(
              'lazy',
              extensions: [TestDescriptor()],
              dispose: () async => throw StateError('dispose failed'),
            ),
          ),
        ],
      );
      await vc.vyuh.getReady(tester);

      await expectLater(
        vc.vyuh.loadFeature('lazy'),
        throwsA(
          isA<StateError>().having((e) => e.message, 'm', 'register failed'),
        ),
      );

      expect(builder.calls, ['capture', 'register', 'rollback']);
      expect(
        telemetry.errors.whereType<StateError>().map((e) => e.message),
        containsAll(['rollback failed', 'dispose failed']),
      );
      expect(vc.vyuh.isFeatureLoaded('lazy'), isFalse);
    });

    testWidgets('routes are restored when replacing them fails, and a failed '
        'restore is reported', (tester) async {
      final telemetry = RecordingTelemetry();
      final navigation = _FlakyNavigation();
      vc.runApp(
        plugins: recordingPlugins(telemetry, navigation: navigation),
        features: () => [home()],
        lazyFeatures: () => [lazy(() => feature('lazy'))],
      );
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();

      navigation.failReplace = true;
      await expectLater(
        vc.vyuh.loadFeature('lazy'),
        throwsA(
          isA<StateError>().having((e) => e.message, 'm', 'replace failed'),
        ),
      );
      expect(
        telemetry.errors.whereType<StateError>().map((e) => e.message),
        contains('replace failed'),
      );
      expect(vc.vyuh.isFeatureLoaded('lazy'), isFalse);

      // The failed attempt left nothing behind, so a retry succeeds.
      navigation.failReplace = false;
      await tester.runAsync(() => vc.vyuh.loadFeature('lazy'));
      expect(vc.vyuh.isFeatureLoaded('lazy'), isTrue);
    });
  });

  group('disposing features', () {
    testWidgets('a feature whose dispose throws is reported and the rest '
        'still stop', (tester) async {
      final telemetry = RecordingTelemetry();
      final stopped = <String>[];
      vc.runApp(
        plugins: recordingPlugins(telemetry),
        features: () => [
          home(),
          feature('first', dispose: () async => stopped.add('first')),
          feature(
            'broken',
            dispose: () async => throw StateError('dispose failed'),
          ),
        ],
      );
      await vc.vyuh.getReady(tester);
      await vc.vyuh.dispose();

      expect(stopped, ['first']);
      expect(
        telemetry.errors.whereType<StateError>().map((e) => e.message),
        contains('dispose failed'),
      );
    });
  });
}
