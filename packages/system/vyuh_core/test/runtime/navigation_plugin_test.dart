import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

import 'helpers.dart';

final class _Ping extends vc.VyuhEvent<void> {
  _Ping() : super(name: 'test.ping');
}

/// Exposes [vc.NavigationPlugin.watchRedirectTriggers]; nothing else is used.
final class _Watcher extends vc.NavigationPlugin {
  _Watcher() : super(name: 'test.watcher', title: 'Watcher');

  VoidCallback watch(VoidCallback refresh) => watchRedirectTriggers(refresh);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

GoRoute _item() => GoRoute(
  path: '/items/:id',
  name: 'item',
  builder: (_, state) => Text(
    'item ${state.pathParameters['id']}'
    '${state.uri.queryParameters['q'] ?? ''}',
  ),
);

void main() {
  tearDown(disposePlatform);

  group('constructor options', () {
    tearDown(() => GoRouter.optionURLReflectsImperativeAPIs = false);

    test('urlReflectsImperativeAPIs turns on GoRouter URL reflection', () {
      vc.DefaultNavigationPlugin(
        urlReflectsImperativeAPIs: true,
        urlStyle: vc.RouterUrlStyle.path,
      );
      expect(GoRouter.optionURLReflectsImperativeAPIs, isTrue);
    });

    test('the URL style can be hash or path, and defaults to neither', () {
      expect(
        () => vc.DefaultNavigationPlugin(urlStyle: vc.RouterUrlStyle.hash),
        returnsNormally,
      );
      expect(vc.DefaultNavigationPlugin.new, returnsNormally);
      expect(GoRouter.optionURLReflectsImperativeAPIs, isFalse);
    });
  });

  test('RoutingConfigNotifier without a redirect replaces routes', () {
    final notifier = vc.RoutingConfigNotifier([page('/')]);
    addTearDown(notifier.dispose);
    var notified = false;
    notifier.addListener(() => notified = true);

    notifier.setRoutes([page('/a'), page('/b')]);

    expect(notifier.value.routes, hasLength(2));
    expect(notified, isTrue);
  });

  testWidgets('the router can only be initialized once', (tester) async {
    vc.runApp(features: () => [home()]);
    await vc.vyuh.getReady(tester);

    expect(
      () => vc.vyuh.router.initRouter(
        routes: [],
        rootNavigatorKey: GlobalKey<NavigatorState>(),
      ),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          'Router already initialized',
        ),
      ),
    );
  });

  testWidgets('initial routes are added before the router starts, and '
      'refused after', (tester) async {
    vc.runApp(
      features: () => [
        home(),
        vc.FeatureDescriptor(
          name: 'extra',
          title: 'Extra',
          init: () async =>
              vc.vyuh.router.appendInitialRoutes([page('/extra')]),
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.go('/extra');
    await tester.pumpAndSettle();
    expect(find.text('page /extra'), findsOneWidget);

    expect(
      () => vc.vyuh.router.appendInitialRoutes([page('/late')]),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('after Router is initialized'),
        ),
      ),
    );
  });

  testWidgets('routes appended at runtime can be opened', (tester) async {
    vc.runApp(features: () => [home()]);
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.appendRoutes([page('/added')]);
    vc.vyuh.router.go('/added');
    await tester.pumpAndSettle();

    expect(find.text('page /added'), findsOneWidget);
  });

  testWidgets('a catch-all route sees only unmatched locations, and only the '
      'first one is used', (tester) async {
    final telemetry = RecordingTelemetry();
    GoRoute catchAll(String label) => GoRoute(
      path: vc.NavigationPlugin.catchAllPath,
      builder: (_, state) => Text('$label ${state.uri.path}'),
    );
    vc.runApp(
      plugins: recordingPlugins(telemetry),
      features: () => [
        feature('first', routes: [catchAll('first'), page('/')]),
        feature('second', routes: [catchAll('second'), page('/known')]),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.go('/known');
    await tester.pumpAndSettle();
    expect(find.text('page /known'), findsOneWidget);

    vc.vyuh.router.go('/anything');
    await tester.pumpAndSettle();
    expect(find.text('first /anything'), findsOneWidget);
    expect(telemetry.messages, contains(contains('Found 2 catch-all routes')));
  });

  testWidgets('named and imperative navigation reach their pages', (
    tester,
  ) async {
    vc.runApp(
      features: () => [
        feature(
          'app',
          routes: [
            page('/', name: 'home'),
            page('/other', name: 'other'),
            _item(),
          ],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();
    final router = vc.vyuh.router;

    Future<void> expectPage(String text) async {
      await tester.pumpAndSettle();
      expect(find.text(text), findsOneWidget);
    }

    router.goNamed(
      'item',
      pathParameters: {'id': '1'},
      queryParameters: {'q': '?'},
    );
    await expectPage('item 1?');

    router.push('/other');
    await expectPage('page /other');
    router.pop();
    await expectPage('item 1?');

    router.pushNamed('other');
    await expectPage('page /other');
    router.pop();
    await expectPage('item 1?');

    router.pushReplacement('/other');
    await expectPage('page /other');

    router.pushReplacementNamed('item', pathParameters: {'id': '2'});
    await expectPage('item 2');

    router.replace('/other');
    await expectPage('page /other');

    router.replaceNamed('item', pathParameters: {'id': '3'});
    await expectPage('item 3');

    router.goHome();
    await expectPage('page /');
  });

  testWidgets('the not-found page retries matching and redirects', (
    tester,
  ) async {
    var redirectHome = false;
    vc.runApp(
      features: () => [
        feature(
          'home',
          routes: [page('/')],
          redirects: [
            vc.FeatureRedirect(
              name: 'rescue',
              redirect: (_, state) =>
                  redirectHome && state.uri.path == '/nope' ? '/' : null,
            ),
          ],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.go('/nope');
    await tester.pumpAndSettle();
    expect(find.text('Page not found'), findsOneWidget);
    expect(find.text('Nothing is available at /nope.'), findsOneWidget);

    redirectHome = true;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('page /'), findsOneWidget);
  });

  testWidgets('a throwing feature redirect is reported and skipped', (
    tester,
  ) async {
    final telemetry = RecordingTelemetry();
    vc.runApp(
      plugins: recordingPlugins(telemetry),
      features: () => [
        feature(
          'app',
          routes: [page('/'), page('/old'), page('/new')],
          redirects: [
            vc.FeatureRedirect(
              name: 'broken',
              redirect: (_, _) => throw StateError('no session'),
            ),
            vc.FeatureRedirect(
              name: 'moved',
              redirect: (_, state) => state.uri.path == '/old' ? '/new' : null,
            ),
          ],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.go('/old');
    await tester.pumpAndSettle();

    expect(find.text('page /new'), findsOneWidget);
    expect(
      telemetry.errors.whereType<StateError>().map((e) => e.message),
      contains(
        'Redirect "broken" of feature "app" failed: Bad state: no session',
      ),
    );
  });

  testWidgets('watching redirect triggers follows listenables and events '
      'until stopped', (tester) async {
    vc.runApp(features: () => [home()]);
    await vc.vyuh.getReady(tester);

    final watcher = _Watcher();
    final notifier = ValueNotifier(0);
    addTearDown(notifier.dispose);
    var refreshes = 0;
    final stop = watcher.watch(() => refreshes++);

    watcher.featureRedirects.add('f', [
      vc.FeatureRedirect(
        name: 'r',
        redirect: (_, _) => null,
        listenable: notifier,
        refreshOn: [_Ping],
      ),
    ]);
    expect(refreshes, 1, reason: 'the set of redirects changed');

    notifier.value++;
    expect(refreshes, 2);

    vc.vyuh.event.emit(_Ping());
    await tester.pump();
    expect(refreshes, 3);

    stop();
    notifier.value++;
    vc.vyuh.event.emit(_Ping());
    await tester.pump();
    expect(refreshes, 3);
  });

  testWidgets('the deprecated global redirect still applies', (tester) async {
    // It stays set for this isolate; it only affects `/legacy`.
    // ignore: deprecated_member_use_from_same_package
    vc.DefaultNavigationPlugin.setRouterRedirect(
      (_, state) => state.uri.path == '/legacy' ? '/' : null,
    );
    vc.runApp(
      features: () => [
        feature('app', routes: [page('/'), page('/legacy')]),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.go('/legacy');
    await tester.pumpAndSettle();
    expect(find.text('page /'), findsOneWidget);
  });
}
