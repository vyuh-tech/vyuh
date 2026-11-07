import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

import 'helpers.dart';

void main() {
  tearDown(disposePlatform);

  test('the plugin owns and validates the retention policy', () {
    expect(vc.DefaultNavigationPlugin().maxRetainedBranches, 3);
    expect(
      vc.DefaultNavigationPlugin(maxRetainedBranches: 1).maxRetainedBranches,
      1,
    );
    expect(
      () => vc.DefaultNavigationPlugin(maxRetainedBranches: 0),
      throwsArgumentError,
    );
  });

  testWidgets('entry guards survive dynamic route replacement', (tester) async {
    var blocked = true;
    var attempts = 0;
    final plugin = vc.DefaultNavigationPlugin(
      onEnter: (_, _, next, _) async {
        if (next.uri.path == '/protected') {
          attempts++;
          if (blocked) return const Block.stop();
        }
        return const Allow();
      },
      redirectLimit: 9,
    );
    vc.runApp(
      plugins: vc.PluginDescriptor(navigation: plugin),
      features: () => [home()],
    );
    await vc.vyuh.getReady(tester);
    plugin.replaceRoutes([page('/'), page('/protected')]);
    await tester.pumpAndSettle();
    plugin.go('/protected');
    await tester.pumpAndSettle();
    expect(plugin.instance.state.uri.path, '/');
    expect(attempts, 1);
    blocked = false;
    plugin.go('/protected');
    await tester.pumpAndSettle();
    expect(plugin.instance.state.uri.path, '/protected');
    expect(attempts, 2);
    expect(plugin.instance.configuration.redirectLimit, 9);
  });

  testWidgets('refreshListenable reevaluates a configured redirect', (
    tester,
  ) async {
    final signedIn = ValueNotifier(true);
    addTearDown(signedIn.dispose);
    final plugin = vc.DefaultNavigationPlugin(
      refreshListenable: signedIn,
      requestFocus: false,
      restorationScopeId: 'navigation',
      redirect: (_, state) =>
          !signedIn.value && state.uri.path != '/login' ? '/login' : null,
    );
    vc.runApp(
      plugins: vc.PluginDescriptor(navigation: plugin),
      features: () => [
        vc.FeatureDescriptor(
          name: 'home',
          title: 'Home',
          routes: () => [page('/'), page('/login')],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    signedIn.value = false;
    await tester.pumpAndSettle();
    expect(plugin.instance.state.uri.path, '/login');
    expect(
      tester.widgetList<Navigator>(find.byType(Navigator)).first.requestFocus,
      isFalse,
    );
  });

  testWidgets('custom exception handling receives unknown destinations', (
    tester,
  ) async {
    final failures = <Uri>[];
    final plugin = vc.DefaultNavigationPlugin(
      onException: (_, state, router) {
        failures.add(state.uri);
        router.go('/');
      },
    );
    vc.runApp(
      plugins: vc.PluginDescriptor(navigation: plugin),
      features: () => [home()],
    );
    await vc.vyuh.getReady(tester);
    plugin.go('/missing');
    await tester.pumpAndSettle();
    expect(failures.map((uri) => uri.path), ['/missing']);
    expect(plugin.instance.state.uri.path, '/');
  });
}
