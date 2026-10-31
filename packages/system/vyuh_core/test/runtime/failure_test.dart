import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_test/vyuh_test.dart';

final class _Ping extends VyuhEvent<void> {
  _Ping() : super(name: 'test.ping');
}

class _State extends Mock implements GoRouterState {}

void main() {
  group('VyuhFailure', () {
    test('toString names the kind, title, location and error', () {
      expect(
        const VyuhFailure(kind: FailureKind.route, title: 'Broken').toString(),
        'VyuhFailure(route: Broken)',
      );
      expect(
        VyuhFailure(
          kind: FailureKind.notFound,
          title: 'Missing',
          location: Uri.parse('/a'),
          error: 'boom',
        ).toString(),
        'VyuhFailure(notFound: Missing @ /a, boom)',
      );
    });
  });

  group('VyuhStrings', () {
    test('default builders include their argument', () {
      const strings = VyuhStrings();
      expect(
        strings.featureDisabledTitle('Reports'),
        'Reports is not available',
      );
      expect(
        strings.featureLoadFailedTitle('Reports'),
        'Could not load Reports',
      );
      expect(
        strings.noRouteMessage(Uri.parse('/x')),
        'Nothing is available at /x.',
      );
    });
  });

  group('LazyFeatureDescriptor', () {
    test('needs at least one route prefix', () {
      expect(
        () => LazyFeatureDescriptor(
          name: 'reports',
          title: 'Reports',
          routePrefixes: const [],
          loader: () => throw UnimplementedError(),
        ),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            contains('"reports"'),
          ),
        ),
      );
    });
  });

  group('EventHandler', () {
    test('exposes its event type', () {
      expect(EventHandler<_Ping>((_) {}).eventType, _Ping);
    });
  });

  group('RedirectRegistry', () {
    late _State state;
    late TestBuildContext context;

    setUp(() {
      state = _State();
      when(() => state.uri).thenReturn(Uri.parse('/here'));
      context = TestBuildContext();
      when(() => context.mounted).thenReturn(true);
    });

    test('clear removes every redirect and notifies once', () {
      final registry = RedirectRegistry();
      var notified = 0;
      registry.addListener(() => notified++);

      registry.clear();
      expect(notified, 0, reason: 'clearing an empty registry is a no-op');

      registry.add('a', [FeatureRedirect(name: 'r', redirect: (_, _) => null)]);
      registry.clear();
      expect(registry.redirects, isEmpty);
      expect(notified, 2);
    });

    test('the base redirect wins over feature redirects', () async {
      final registry = RedirectRegistry()
        ..add('a', [FeatureRedirect(name: 'r', redirect: (_, _) => '/a')]);
      expect(
        await registry.evaluate(context, state, base: (_, _) => '/base'),
        '/base',
      );
      expect(
        await registry.evaluate(context, state, base: (_, _) => null),
        '/a',
      );
    });

    test('a redirect to the current location continues the chain', () async {
      final registry = RedirectRegistry()
        ..add('a', [
          FeatureRedirect(name: 'self', redirect: (_, _) => '/here'),
          FeatureRedirect(name: 'next', redirect: (_, _) => '/next'),
        ]);
      expect(await registry.evaluate(context, state), '/next');
    });

    test('a throwing redirect is skipped, even without telemetry', () async {
      final registry = RedirectRegistry()
        ..add('a', [
          FeatureRedirect(
            name: 'broken',
            redirect: (_, _) => throw StateError('broken'),
          ),
          FeatureRedirect(name: 'next', redirect: (_, _) => '/next'),
        ]);
      expect(await registry.evaluate(context, state), '/next');
    });

    test('an unmounted context stops the chain and returns null', () async {
      var called = false;
      when(() => context.mounted).thenReturn(false);
      final registry = RedirectRegistry()
        ..add('a', [
          FeatureRedirect(
            name: 'r',
            redirect: (_, _) {
              called = true;
              return '/a';
            },
          ),
        ]);
      expect(await registry.evaluate(context, state), isNull);
      expect(called, isFalse);
    });

    test('a context unmounted by an async redirect stops the chain', () async {
      var mounted = true;
      when(() => context.mounted).thenAnswer((_) => mounted);
      var secondCalled = false;
      final registry = RedirectRegistry()
        ..add('a', [
          FeatureRedirect(
            name: 'slow',
            redirect: (_, _) async {
              mounted = false;
              return null;
            },
          ),
          FeatureRedirect(
            name: 'second',
            redirect: (_, _) {
              secondCalled = true;
              return '/b';
            },
          ),
        ]);
      expect(await registry.evaluate(context, state), isNull);
      expect(secondCalled, isFalse);
    });
  });

  group('VyuhFailureScope', () {
    testWidgets('dependents rebuild when the failure changes', (tester) async {
      Widget scope(String title) => MaterialApp(
        home: VyuhFailureScope(
          failure: VyuhFailure(kind: FailureKind.route, title: title),
          child: Builder(
            builder: (context) =>
                Text(VyuhFailureScope.maybeOf(context)!.title),
          ),
        ),
      );

      await tester.pumpWidget(scope('first'));
      expect(find.text('first'), findsOneWidget);

      await tester.pumpWidget(scope('second'));
      expect(find.text('second'), findsOneWidget);
    });

    testWidgets('maybeOf is null outside a scope', (tester) async {
      VyuhFailure? found = const VyuhFailure(
        kind: FailureKind.route,
        title: 'x',
      );
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            found = VyuhFailureScope.maybeOf(context);
            return const SizedBox();
          },
        ),
      );
      expect(found, isNull);
    });
  });

  group('BuildFailureView', () {
    testWidgets('stays small inside an unbounded layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              BuildFailureView(
                details: FlutterErrorDetails(exception: StateError('broken')),
              ),
            ],
          ),
        ),
      );
      expect(tester.getSize(find.byType(ColoredBox).last).height, 96);
      expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    });
  });
}
