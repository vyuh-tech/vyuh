import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

import 'helpers.dart';

GoRoute _build(String path, WidgetBuilder builder) =>
    GoRoute(path: path, builder: (context, _) => builder(context));

/// Lets restart work that runs on the real event loop finish.
Future<void> _settleRestart(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }
}

void main() {
  tearDown(disposePlatform);

  testWidgets('the default inline failure offers retry, restart and debug '
      'details', (tester) async {
    var inits = 0;
    var retries = 0;
    vc.runApp(
      features: () => [
        feature(
          'app',
          init: () async => inits++,
          routes: [
            _build(
              '/',
              (context) => Scaffold(
                body: vc.vyuh.widgetBuilder.errorView(
                  context,
                  title: 'Part failed',
                  subtitle: 'Some detail',
                  error: StateError('kaboom'),
                  stackTrace: StackTrace.current,
                  onRetry: () => retries++,
                  showRestart: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    expect(find.text('Part failed'), findsOneWidget);
    expect(find.text('Some detail'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    expect(retries, 1);

    expect(find.text('Bad state: kaboom'), findsNothing);
    await tester.tap(find.text('Details (debug only)'));
    await tester.pumpAndSettle();
    expect(find.text('Bad state: kaboom'), findsOneWidget);

    await tester.tap(find.text('Restart app'));
    await _settleRestart(tester);
    expect(inits, 2);
    expect(vc.vyuh.tracker.currentState.value, vc.InitState.ready);
  });

  testWidgets('a plain inline failure shows only its title', (tester) async {
    vc.runApp(
      features: () => [
        feature(
          'app',
          routes: [
            _build(
              '/',
              (context) => Scaffold(
                body: vc.vyuh.widgetBuilder.errorView(context, title: 'Plain'),
              ),
            ),
          ],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    expect(find.text('Plain'), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
    expect(find.text('Details (debug only)'), findsNothing);
  });

  testWidgets('a failure page reached by push offers Back', (tester) async {
    vc.runApp(features: () => [home()]);
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.push('/missing');
    await tester.pumpAndSettle();
    expect(find.text('Page not found'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('page /'), findsOneWidget);
  });

  testWidgets('the image placeholder and the content loader use theme '
      'tokens', (tester) async {
    vc.runApp(
      features: () => [
        feature(
          'app',
          routes: [
            page('/'),
            _build(
              '/image',
              (context) => vc.vyuh.widgetBuilder.imagePlaceholder(
                context,
                width: 40,
                height: 30,
              ),
            ),
            _build(
              '/content',
              (context) =>
                  Scaffold(body: vc.vyuh.widgetBuilder.contentLoader(context)),
            ),
          ],
        ),
      ],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();

    vc.vyuh.router.go('/image');
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.image_not_supported_rounded), findsOneWidget);

    vc.vyuh.router.go('/content');
    for (var i = 0; i < 20 && find.byType(Scaffold).evaluate().isEmpty; i++) {
      await tester.pump();
    }
    expect(find.byType(Scaffold), findsOneWidget);
    expect(
      find.byType(CircularProgressIndicator),
      findsNothing,
      reason: 'the loader waits for loaderDelay before appearing',
    );
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);

    vc.vyuh.router.go('/');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  group('a startup failure', () {
    vc.FeatureDescriptor flaky(List<int> attempts) => feature(
      'app',
      routes: [page('/')],
      init: () async {
        attempts.add(attempts.length);
        if (attempts.length == 1) throw StateError('first start fails');
      },
    );

    testWidgets('restarts from its primary button', (tester) async {
      final attempts = <int>[];
      vc.runApp(features: () => [flaky(attempts)]);
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();

      expect(find.text('The app could not start'), findsOneWidget);
      expect(find.text('Go home'), findsNothing);

      await tester.tap(find.widgetWithText(FilledButton, 'Restart app'));
      await _settleRestart(tester);

      expect(attempts, hasLength(2));
      expect(find.text('page /'), findsOneWidget);
    });

    testWidgets('restarts from its fallback action', (tester) async {
      final attempts = <int>[];
      vc.runApp(features: () => [flaky(attempts)]);
      await vc.vyuh.getReady(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Restart app'));
      await _settleRestart(tester);

      expect(attempts, hasLength(2));
      expect(find.text('page /'), findsOneWidget);
    });
  });
}
