import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

/// A browser reload on a deep link: the platform's route name is that path
/// before the app has loaded its features, so the loading screen sees it first.
void main() {
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });

  void reloadAt(WidgetTester tester, String path) {
    tester.platformDispatcher.defaultRouteNameTestValue = path;
    addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);
  }

  vc.FeatureDescriptor items({List<String> dependencies = const []}) =>
      vc.FeatureDescriptor(
        name: 'items',
        title: 'items',
        dependencies: dependencies,
        routes: () => [
          GoRoute(path: '/home', builder: (_, _) => const Text('Home')),
          GoRoute(
            path: '/items/:id',
            builder: (_, state) => Text('Item ${state.pathParameters['id']}'),
          ),
        ],
      );

  testWidgets('a deep link opens once the app loads, and loading reports no '
      'route it cannot build', (tester) async {
    reloadAt(tester, '/items/42');

    vc.runApp(features: () => [items()], initialLocation: '/home');
    await tester.pump();
    expect(tester.takeException(), isNull);

    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      vc.vyuh.router.instance.routeInformationProvider.value.uri.path,
      '/items/42',
    );
    expect(find.text('Item 42'), findsOneWidget);
  });

  testWidgets('a startup failure on a deep link shows the failure, not the '
      'loader', (tester) async {
    reloadAt(tester, '/items/42');

    vc.runApp(
      features: () => [
        items(dependencies: ['missing']),
      ],
    );
    await tester.pump();
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(vc.vyuh.tracker.error, isStateError);
    expect(find.text('Failed to load app'), findsOneWidget);
  });
}
