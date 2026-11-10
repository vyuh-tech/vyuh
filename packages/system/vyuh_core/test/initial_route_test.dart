import 'dart:async';

import 'package:flutter/services.dart';
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

  testWidgets('slow startup leaves browser history to the loaded router', (
    tester,
  ) async {
    reloadAt(tester, '/items/42');
    final ready = Completer<void>();
    final navigation = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.navigation,
      (call) async => navigation.add(call),
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.navigation,
        null,
      );
    });

    vc.runApp(
      features: () => [
        vc.FeatureDescriptor(
          name: 'slow-start',
          title: 'Slow start',
          init: () => ready.future,
        ),
        items(),
      ],
      initialLocation: '/home',
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Navigator), findsNothing);
    expect(
      navigation.where((call) => call.method == 'selectSingleEntryHistory'),
      isEmpty,
    );
    expect(tester.takeException(), isNull);

    ready.complete();
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();
    expect(find.text('Item 42'), findsOneWidget);

    vc.vyuh.router.instance.go('/home');
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.byType(Navigator), findsOneWidget);
    expect(
      navigation.where((call) => call.method == 'selectSingleEntryHistory'),
      isEmpty,
    );
    expect(
      navigation
          .where((call) => call.method == 'routeInformationUpdated')
          .last
          .arguments['uri'],
      '/home',
    );
    expect(tester.takeException(), isNull);
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
    expect(find.text('The app could not start'), findsOneWidget);
  });
}
