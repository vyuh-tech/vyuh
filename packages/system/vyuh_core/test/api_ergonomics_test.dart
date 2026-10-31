import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

final class _Service {}

GoRoute _page(String path) =>
    GoRoute(path: path, builder: (_, _) => Text('page $path'));

vc.FeatureDescriptor _home() => vc.FeatureDescriptor(
  name: 'home',
  title: 'Home',
  routes: () => [_page('/'), _page('/new')],
);

void main() {
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });

  testWidgets('a feature without routes needs no routes parameter', (
    tester,
  ) async {
    var initialized = false;
    vc.runApp(
      features: () => [
        _home(),
        vc.FeatureDescriptor(
          name: 'services',
          title: 'Services',
          init: () async => initialized = true,
        ),
      ],
    );
    await vc.vyuh.getReady(tester);

    expect(vc.vyuh.tracker.currentState.value, vc.InitState.ready);
    expect(initialized, isTrue);
  });

  testWidgets('a restart disposes features while their services still exist', (
    tester,
  ) async {
    final seenAtDispose = <bool>[];
    vc.runApp(
      features: () => [
        _home(),
        vc.FeatureDescriptor(
          name: 'services',
          title: 'Services',
          init: () async => vc.vyuh.di.register(_Service()),
          dispose: () async => seenAtDispose.add(vc.vyuh.di.has<_Service>()),
        ),
      ],
    );
    await vc.vyuh.getReady(tester);

    await tester.runAsync(() => vc.vyuh.restart());
    await tester.pumpAndSettle();

    expect(seenAtDispose, [true]);
  });

  testWidgets('the router redirect is a constructor parameter', (tester) async {
    vc.runApp(
      initialLocation: '/',
      plugins: vc.PluginDescriptor(
        navigation: vc.DefaultNavigationPlugin(
          redirect: (_, state) =>
              state.matchedLocation == '/old' ? '/new' : null,
        ),
      ),
      features: () => [_home()],
    );
    await vc.vyuh.getReady(tester);

    vc.vyuh.router.go('/old');
    await tester.pumpAndSettle();
    expect(find.text('page /new'), findsOneWidget);
  });

  testWidgets('framework strings come from VyuhStrings', (tester) async {
    vc.runApp(
      initialLocation: '/',
      platformWidgetBuilder: vc.PlatformWidgetBuilder.system.copyWith(
        strings: vc.VyuhStrings(
          tryAgain: 'Réessayer',
          goHome: 'Accueil',
          featureLoadFailedTitle: (title) => 'Échec : $title',
        ),
      ),
      features: () => [_home()],
      lazyFeatures: () => [
        vc.LazyFeatureDescriptor(
          name: 'reports',
          title: 'Rapports',
          routePrefixes: ['/reports'],
          loader: () async => throw StateError('offline'),
        ),
      ],
    );
    await vc.vyuh.getReady(tester);

    vc.vyuh.router.go('/reports');
    await tester.pumpAndSettle();

    expect(find.text('Échec : Rapports'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
    expect(find.text('Accueil'), findsOneWidget);
  });

  testWidgets('VyuhBinding exposes the same plugins as vyuh', (tester) async {
    vc.runApp(features: () => [_home()]);
    await vc.vyuh.getReady(tester);

    final binding = vc.VyuhBinding.instance;
    expect(binding.router, same(vc.vyuh.router));
    expect(binding.auth, same(vc.vyuh.auth));
    expect(binding.storage, same(vc.vyuh.storage));
    expect(binding.secureStorage, same(vc.vyuh.secureStorage));
    expect(binding.locale, vc.vyuh.locale);
  });
}
