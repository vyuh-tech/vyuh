import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

final class _Ping extends vc.VyuhEvent<void> {
  _Ping() : super(name: 'test.ping');
}

final class _SignedOut extends vc.VyuhEvent<void> {
  _SignedOut() : super(name: 'test.signedOut');
}

GoRoute _page(String path) =>
    GoRoute(path: path, builder: (_, _) => Text('page $path'));

vc.FeatureDescriptor _home() => vc.FeatureDescriptor(
  name: 'home',
  title: 'Home',
  routes: () => [_page('/'), _page('/login')],
);

void main() {
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });

  testWidgets('feature event handlers hear lifecycle events', (tester) async {
    final events = <String>[];
    vc.runApp(
      features: () => [
        _home(),
        vc.FeatureDescriptor(
          name: 'listener',
          title: 'Listener',
          routes: () => [],
          events: [
            vc.EventHandler<vc.FeatureLoadedEvent>(
              (e) => events.add('loaded ${e.featureName}'),
            ),
            vc.EventHandler<vc.SystemReadyEvent>((_) => events.add('ready')),
          ],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    expect(events, containsAll(['loaded home', 'loaded listener', 'ready']));
    expect(events.last, 'ready');
  });

  testWidgets('a restart does not duplicate feature event handlers', (
    tester,
  ) async {
    var pings = 0;
    vc.runApp(
      features: () => [
        _home(),
        vc.FeatureDescriptor(
          name: 'listener',
          title: 'Listener',
          routes: () => [],
          events: [vc.EventHandler<_Ping>((_) => pings++)],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);

    vc.vyuh.event.emit(_Ping());
    await tester.pumpAndSettle();
    expect(pings, 1);

    await tester.runAsync(() => vc.vyuh.restart());
    await tester.pumpAndSettle();

    vc.vyuh.event.emit(_Ping());
    await tester.pumpAndSettle();
    expect(pings, 2);
  });

  testWidgets('feature redirects re-run when their trigger event fires', (
    tester,
  ) async {
    var signedIn = true;
    vc.runApp(
      initialLocation: '/',
      features: () => [
        _home(),
        vc.FeatureDescriptor(
          name: 'account',
          title: 'Account',
          routes: () => [_page('/account')],
          redirects: [
            vc.FeatureRedirect(
              name: 'require-sign-in',
              refreshOn: [_SignedOut],
              redirect: (_, state) =>
                  !signedIn && state.matchedLocation == '/account'
                  ? '/login'
                  : null,
            ),
          ],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.go('/account');
    await tester.pumpAndSettle();
    expect(find.text('page /account'), findsOneWidget);

    signedIn = false;
    vc.vyuh.event.emit(_SignedOut());
    await tester.pumpAndSettle();
    expect(find.text('page /login'), findsOneWidget);
  });

  testWidgets('feature redirects re-run when their listenable notifies', (
    tester,
  ) async {
    final signedIn = ValueNotifier(true);
    vc.runApp(
      initialLocation: '/',
      features: () => [
        _home(),
        vc.FeatureDescriptor(
          name: 'account',
          title: 'Account',
          routes: () => [_page('/account')],
          redirects: [
            vc.FeatureRedirect(
              name: 'require-sign-in',
              listenable: signedIn,
              redirect: (_, state) =>
                  !signedIn.value && state.matchedLocation == '/account'
                  ? '/login'
                  : null,
            ),
          ],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    vc.vyuh.router.go('/account');
    await tester.pumpAndSettle();
    expect(find.text('page /account'), findsOneWidget);

    signedIn.value = false;
    await tester.pumpAndSettle();
    expect(find.text('page /login'), findsOneWidget);
  });

  testWidgets('a lazy feature brings its redirects when it activates', (
    tester,
  ) async {
    vc.runApp(
      initialLocation: '/',
      features: () => [_home()],
      lazyFeatures: () => [
        vc.LazyFeatureDescriptor(
          name: 'legacy',
          title: 'Legacy',
          routePrefixes: ['/legacy'],
          loader: () async => vc.FeatureDescriptor(
            name: 'legacy',
            title: 'Legacy',
            routes: () => [_page('/legacy')],
            redirects: [
              vc.FeatureRedirect(
                name: 'old-login',
                redirect: (_, state) =>
                    state.matchedLocation == '/sign-in' ? '/login' : null,
              ),
            ],
          ),
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    expect(vc.vyuh.router.featureRedirects.redirects, isEmpty);

    await tester.runAsync(() => vc.vyuh.loadFeature('legacy'));
    expect(vc.vyuh.router.featureRedirects.redirects.map((r) => r.name), [
      'old-login',
    ]);
  });

  testWidgets('a failed lazy feature reports once and offers a way home', (
    tester,
  ) async {
    final failures = <vc.VyuhFailure>[];
    vc.runApp(
      initialLocation: '/',
      features: () => [
        _home(),
        vc.FeatureDescriptor(
          name: 'monitor',
          title: 'Monitor',
          routes: () => [],
          events: [
            vc.EventHandler<vc.RouteFailureEvent>(
              (e) => failures.add(e.failure),
            ),
          ],
        ),
      ],
      lazyFeatures: () => [
        vc.LazyFeatureDescriptor(
          name: 'broken',
          title: 'Reports',
          routePrefixes: ['/reports'],
          loader: () async => throw StateError('download failed'),
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.go('/reports');
    await tester.pumpAndSettle();

    expect(find.text('Could not load Reports'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Go home'), findsOneWidget);
    expect(failures, hasLength(1));
    expect(failures.single.kind, vc.FailureKind.featureLoad);
    expect(failures.single.featureName, 'broken');

    await tester.tap(find.text('Go home'));
    await tester.pumpAndSettle();
    expect(find.text('page /'), findsOneWidget);
  });
}
