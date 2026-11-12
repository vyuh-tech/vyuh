// End-to-end scenarios for what must stay solid as apps grow: booting,
// loading features, navigating between them, lazy features, the routing
// table, and navigation tracking. Each test runs a real platform.
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

GoRoute _page(String path, {List<RouteBase> routes = const []}) => GoRoute(
  path: path,
  builder: (_, state) => Text('page ${state.uri}'),
  routes: routes,
);

vc.FeatureDescriptor _feature(
  String name, {
  List<String> dependencies = const [],
  List<RouteBase> Function()? routes,
  vc.VoidFutureFunction? init,
}) => vc.FeatureDescriptor(
  name: name,
  title: name,
  dependencies: dependencies,
  init: init,
  routes: routes ?? () => [_page('/$name')],
);

/// Records every route the navigator shows.
final class _RecordingObserver extends NavigatorObserver {
  final pushed = <String>[];
  final popped = <String>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route.settings.name ?? '?');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    popped.add(route.settings.name ?? '?');
  }
}

/// A plugin that contributes a navigator observer, like analytics does.
final class _TrackingPlugin extends vc.Plugin with vc.RouteObservers {
  final observer = _RecordingObserver();

  _TrackingPlugin() : super(name: 'test.tracking', title: 'Tracking');

  @override
  List<NavigatorObserver> get observers => [observer];

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}
}

String _currentLocation() =>
    vc.vyuh.router.instance.routerDelegate.currentConfiguration.uri.toString();

void main() {
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });

  group('boot', () {
    testWidgets('boots 40 features in dependency order, all reachable', (
      tester,
    ) async {
      final initOrder = <String>[];
      final loaded = <String>[];
      // A chain f0 <- f1 <- ... plus independent features.
      final features = [
        for (var i = 0; i < 40; i++)
          _feature(
            'f$i',
            dependencies: i > 0 && i.isEven ? ['f${i - 2}'] : const [],
            init: () async => initOrder.add('f$i'),
          ),
        vc.FeatureDescriptor(
          name: 'tracker',
          title: 'Tracker',
          events: [
            vc.EventHandler<vc.FeatureLoadedEvent>(
              (e) => loaded.add(e.featureName),
            ),
          ],
        ),
      ];

      vc.runApp(initialLocation: '/f0', features: () => features);
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();

      expect(vc.vyuh.tracker.currentState.value, vc.InitState.ready);
      expect(initOrder, hasLength(40));
      for (var i = 2; i < 40; i += 2) {
        expect(
          initOrder.indexOf('f$i'),
          greaterThan(initOrder.indexOf('f${i - 2}')),
          reason: 'f$i depends on f${i - 2}',
        );
      }
      expect(loaded.toSet(), {for (var i = 0; i < 40; i++) 'f$i', 'tracker'});

      for (final i in [0, 17, 39]) {
        vc.vyuh.router.go('/f$i');
        await tester.pumpAndSettle();
        expect(find.text('page /f$i'), findsOneWidget);
      }
    });

    testWidgets('a failing feature init fails startup, then restart recovers', (
      tester,
    ) async {
      var attempts = 0;
      vc.runApp(
        initialLocation: '/a',
        features: () => [
          _feature(
            'a',
            init: () async {
              if (attempts++ == 0) throw StateError('first boot fails');
            },
          ),
        ],
      );
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();
      expect(vc.vyuh.tracker.currentState.value, vc.InitState.error);

      await tester.runAsync(() => vc.vyuh.restart());
      await tester.pumpAndSettle();
      expect(vc.vyuh.tracker.currentState.value, vc.InitState.ready);
      expect(find.text('page /a'), findsOneWidget);
    });
  });

  group('deep links during boot', () {
    // A deep link can only be judged once every plugin and feature has
    // booted and the whole route table (lazy placeholders included) exists.
    // Until then nothing is reported or shown as a failure.

    Future<({List<vc.VyuhFailure> failures, Completer<void> gate})> bootWith(
      WidgetTester tester,
      String deepLink, {
      bool customRoot = false,
    }) async {
      final failures = <vc.VyuhFailure>[];
      final gate = Completer<void>();
      vc.runApp(
        initialLocation: deepLink,
        // A custom root, like the demo app's, makes the switch from the
        // loading screen to the app a cross-fade instead of an in-place
        // update.
        platformWidgetBuilder: customRoot
            ? vc.PlatformWidgetBuilder.system.copyWith(
                appBuilder: (_, platform) => Builder(
                  builder: (_) => WidgetsApp.router(
                    color: const Color(0xFF000000),
                    routerConfig: platform.router.instance,
                  ),
                ),
              )
            : null,
        features: () => [
          vc.FeatureDescriptor(
            name: 'monitor',
            title: 'Monitor',
            events: [
              vc.EventHandler<vc.RouteFailureEvent>(
                (e) => failures.add(e.failure),
              ),
            ],
          ),
          // Holds boot open until the test releases it.
          _feature('slow', init: () => gate.future),
        ],
        lazyFeatures: () => [
          vc.LazyFeatureDescriptor(
            name: 'reports',
            title: 'Reports',
            routePrefixes: ['/reports'],
            loader: () async => _feature('reports'),
          ),
        ],
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      return (failures: failures, gate: gate);
    }

    for (final link in ['/slow', '/reports', '/nowhere']) {
      testWidgets('a deep link to $link shows no failure while booting', (
        tester,
      ) async {
        final boot = await bootWith(tester, link);

        expect(vc.vyuh.tracker.currentState.value, isNot(vc.InitState.ready));
        expect(find.text('Page not found'), findsNothing);
        expect(boot.failures, isEmpty);

        boot.gate.complete();
        await vc.vyuh.getReady(tester);
      });
    }

    for (final link in ['/slow', '/reports']) {
      testWidgets(
        'booting on $link never flashes the startup failure, even mid-fade',
        (tester) async {
          final boot = await bootWith(tester, link, customRoot: true);
          boot.gate.complete();
          await tester.runAsync(() => Future<void>.delayed(Duration.zero));

          // Step through every frame of the switch to the loaded app.
          for (var frame = 0; frame < 40; frame++) {
            await tester.pump(const Duration(milliseconds: 20));
            expect(
              find.text('The app could not start'),
              findsNothing,
              reason: 'frame $frame',
            );
          }
          expect(vc.vyuh.tracker.currentState.value, vc.InitState.ready);
        },
      );
    }

    testWidgets('an unknown deep link fails once, only after boot', (
      tester,
    ) async {
      final boot = await bootWith(tester, '/nowhere');
      expect(boot.failures, isEmpty);

      boot.gate.complete();
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();

      expect(find.text('Page not found'), findsOneWidget);
      expect(boot.failures, hasLength(1));
      expect(boot.failures.single.kind, vc.FailureKind.notFound);
      expect(boot.failures.single.location, Uri.parse('/nowhere'));
    });

    testWidgets('a deep link to a lazy feature loads it after boot', (
      tester,
    ) async {
      final boot = await bootWith(tester, '/reports');
      boot.gate.complete();
      await vc.vyuh.getReady(tester);
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(find.text('page /reports'), findsOneWidget);
      expect(boot.failures, isEmpty);
    });
  });

  group('navigation between features', () {
    testWidgets('go, push and back move between features', (tester) async {
      vc.runApp(
        initialLocation: '/catalog',
        features: () => [
          _feature('catalog', routes: () => [_page('/catalog')]),
          _feature('cart', routes: () => [_page('/cart')]),
          _feature('account', routes: () => [_page('/account')]),
        ],
      );
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();
      expect(find.text('page /catalog'), findsOneWidget);

      vc.vyuh.router.push('/cart');
      await tester.pumpAndSettle();
      expect(find.text('page /cart'), findsOneWidget);

      vc.vyuh.router.push('/account');
      await tester.pumpAndSettle();
      expect(find.text('page /account'), findsOneWidget);

      vc.vyuh.router.pop();
      await tester.pumpAndSettle();
      expect(find.text('page /cart'), findsOneWidget);

      vc.vyuh.router.pop();
      await tester.pumpAndSettle();
      expect(find.text('page /catalog'), findsOneWidget);
      expect(vc.vyuh.router.instance.canPop(), isFalse);
    });

    testWidgets('route observers from plugins see every navigation', (
      tester,
    ) async {
      final tracking = _TrackingPlugin();
      vc.runApp(
        initialLocation: '/a',
        plugins: vc.PluginDescriptor(others: [tracking]),
        features: () => [_feature('a'), _feature('b')],
      );
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();

      vc.vyuh.router.push('/b');
      await tester.pumpAndSettle();
      vc.vyuh.router.pop();
      await tester.pumpAndSettle();

      expect(tracking.observer.pushed.length, greaterThanOrEqualTo(2));
      expect(tracking.observer.popped, isNotEmpty);
    });
  });

  group('lazy features', () {
    vc.LazyFeatureDescriptor lazy(
      String name, {
      List<RouteBase> Function()? routes,
    }) => vc.LazyFeatureDescriptor(
      name: name,
      title: name,
      routePrefixes: ['/$name'],
      loader: () async => _feature(
        name,
        routes:
            routes ??
            () => [
              _page('/$name', routes: [_page('detail')]),
            ],
      ),
    );

    testWidgets('pushing into a lazy feature keeps the back stack', (
      tester,
    ) async {
      vc.runApp(
        initialLocation: '/home',
        features: () => [_feature('home')],
        lazyFeatures: () => [lazy('reports')],
      );
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();

      vc.vyuh.router.push('/reports/detail');
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();
      expect(find.text('page /reports/detail'), findsOneWidget);

      expect(
        vc.vyuh.router.instance.canPop(),
        isTrue,
        reason: 'Back should return to /home after the lazy feature loads',
      );
      vc.vyuh.router.pop();
      await tester.pumpAndSettle();
      expect(find.text('page /home'), findsOneWidget);
    });

    testWidgets('a deep link into a lazy sub-route keeps its query', (
      tester,
    ) async {
      vc.runApp(
        initialLocation: '/reports/detail?range=7d',
        features: () => [_feature('home')],
        lazyFeatures: () => [lazy('reports')],
      );
      await vc.vyuh.getReady(tester);
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(find.text('page /reports/detail?range=7d'), findsOneWidget);
    });

    testWidgets('a lazy feature can use a shell route', (tester) async {
      vc.runApp(
        initialLocation: '/home',
        features: () => [_feature('home')],
        lazyFeatures: () => [
          lazy(
            'shop',
            routes: () => [
              ShellRoute(
                builder: (_, _, child) =>
                    Column(children: [const Text('shop shell'), child]),
                routes: [
                  _page('/shop', routes: [_page('item')]),
                ],
              ),
            ],
          ),
        ],
      );
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();

      vc.vyuh.router.go('/shop/item');
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(find.text('shop shell'), findsOneWidget);
      expect(find.text('page /shop/item'), findsOneWidget);
    });

    testWidgets('loading many lazy features keeps the routing table sound', (
      tester,
    ) async {
      final names = [for (var i = 0; i < 12; i++) 'lazy$i'];
      vc.runApp(
        initialLocation: '/home',
        features: () => [_feature('home')],
        lazyFeatures: () => [for (final n in names) lazy(n)],
      );
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();

      for (final n in names) {
        vc.vyuh.router.go('/$n/detail');
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pumpAndSettle();
        expect(find.text('page /$n/detail'), findsOneWidget, reason: n);
        expect(_currentLocation(), '/$n/detail');
      }

      final topLevel = vc.vyuh.router.instance.configuration.routes
          .whereType<GoRoute>()
          .map((r) => r.path)
          .toList();
      // One route per feature, with no leftover placeholders.
      for (final n in names) {
        expect(topLevel.where((p) => p == '/$n'), hasLength(1), reason: n);
      }

      // Earlier features still route correctly after later swaps.
      vc.vyuh.router.go('/lazy0');
      await tester.pumpAndSettle();
      expect(find.text('page /lazy0'), findsOneWidget);
    });

    testWidgets('a restart resets lazy features to load again', (tester) async {
      var loads = 0;
      vc.runApp(
        initialLocation: '/home',
        features: () => [_feature('home')],
        lazyFeatures: () => [
          vc.LazyFeatureDescriptor(
            name: 'reports',
            title: 'Reports',
            routePrefixes: ['/reports'],
            loader: () async {
              loads++;
              return _feature('reports');
            },
          ),
        ],
      );
      await vc.vyuh.getReady(tester);
      await tester.runAsync(() => vc.vyuh.loadFeature('reports'));
      expect(vc.vyuh.isFeatureLoaded('reports'), isTrue);

      await tester.runAsync(() => vc.vyuh.restart());
      await tester.pumpAndSettle();
      expect(vc.vyuh.isFeatureLoaded('reports'), isFalse);

      await tester.runAsync(() => vc.vyuh.loadFeature('reports'));
      expect(loads, 2);
      expect(vc.vyuh.isFeatureLoaded('reports'), isTrue);
    });
  });
}
