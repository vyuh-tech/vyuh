import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_test/vyuh_test.dart';

void main() {
  Future<void> start(WidgetTester tester) async {
    vc.runApp(
      features: () => [
        vc.FeatureDescriptor(
          name: 'test',
          title: 'Test',
          routes: () => [
            GoRoute(path: '/', builder: (_, _) => const SizedBox()),
          ],
        ),
      ],
      platformWidgetBuilder: vc.PlatformWidgetBuilder.system.copyWith(
        contentLoader: (_) => const Text('loading'),
        errorView:
            (
              _, {
              required title,
              retryLabel,
              onRetry,
              subtitle,
              error,
              stackTrace,
              showRestart = true,
            }) => Column(
              children: [
                Text('error: $error'),
                if (onRetry != null)
                  TextButton(onPressed: onRetry, child: const Text('retry')),
              ],
            ),
      ),
    );
    await vc.vyuh.getReady(tester);
  }

  testWidgets(
    'live documents retain a single subscription across parent rebuilds',
    (tester) async {
      await start(tester);
      var subscriptions = 0;
      final stream = StreamController<String?>(
        onListen: () {
          subscriptions++;
        },
      );
      late StateSetter rebuild;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return DocumentBuilder<String>(
                fetchDocument: () async => null,
                liveDocument: stream.stream,
                isLive: true,
                allowRefresh: false,
                buildContent: (_, value) => Text(value),
              );
            },
          ),
        ),
      );
      stream.add('live');
      await tester.pumpAndSettle();
      expect(find.text('live'), findsOneWidget);
      rebuild(() {});
      await tester.pumpAndSettle();
      expect(subscriptions, 1);
      expect(find.text('live'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      unawaited(stream.close());
    },
  );
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });
  testWidgets('changing a future discards a late previous result', (
    tester,
  ) async {
    await start(tester);
    final old = Completer<String?>(), next = Completer<String?>();
    Widget view(Future<String?> Function() fetch) => MaterialApp(
      theme: ThemeData(splashFactory: NoSplash.splashFactory),
      home: DocumentFutureBuilder<String>(
        future: fetch,
        allowRefresh: false,
        buildContent: (_, value) => Text(value),
      ),
    );
    await tester.pumpWidget(view(() => old.future));
    await tester.pumpWidget(view(() => next.future));
    next.complete('new');
    await tester.pump();
    expect(find.text('new'), findsOneWidget);
    old.complete('old');
    await tester.pump();
    expect(find.text('new'), findsOneWidget);
    expect(find.text('old'), findsNothing);
  });
  testWidgets('synchronous future failures reach the error view', (
    tester,
  ) async {
    await start(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: DocumentFutureBuilder<String>(
          future: () => throw StateError('sync'),
          buildContent: (_, value) => Text(value),
        ),
      ),
    );
    await tester.pump();
    expect(find.textContaining('sync'), findsOneWidget);
  });
  testWidgets(
    'stream errors are rendered and supplied streams are not retried',
    (tester) async {
      await start(tester);
      final stream = StreamController<String?>();
      await tester.pumpWidget(
        MaterialApp(
          home: DocumentStreamBuilder<String>(
            stream: stream.stream,
            buildContent: (_, value) => Text(value),
          ),
        ),
      );
      stream.addError(StateError('offline'));
      await tester.pump();
      expect(find.textContaining('offline'), findsOneWidget);
      expect(find.text('retry'), findsNothing);
      stream.add('recovered');
      await tester.pump();
      await tester.pump();
      expect(find.text('recovered'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      unawaited(stream.close());
    },
  );
  testWidgets(
    'factory retries create a fresh stream and cancel the previous one',
    (tester) async {
      await start(tester);
      var calls = 0, cancellations = 0;
      final streams = <StreamController<String?>>[];
      await tester.pumpWidget(
        MaterialApp(
          home: DocumentStreamBuilder<String>.refreshable(
            streamFactory: () {
              calls++;
              final stream = StreamController<String?>(
                onCancel: () {
                  cancellations++;
                },
              );
              streams.add(stream);
              return stream.stream;
            },
            buildContent: (_, value) => Text(value),
          ),
        ),
      );
      streams.first.addError(StateError('offline'));
      await tester.pump();
      await tester.tap(find.text('retry'));
      await tester.pump();
      expect(calls, 2);
      expect(cancellations, 1);
      streams.last.add('fresh');
      await tester.pump();
      expect(find.text('fresh'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      for (final stream in streams) {
        unawaited(stream.close());
      }
    },
  );

  testWidgets(
    'a route that fails shows a full failure page and reports it once',
    (tester) async {
      await start(tester);
      final failures = <vc.VyuhFailure>[];
      final cancel = vc.vyuh.event.on<vc.RouteFailureEvent>(
        (event) => failures.add(event.failure),
      );
      late StateSetter rebuild;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return DocumentFutureBuilder<String>(
                isRoute: true,
                location: Uri.parse('/broken'),
                requestKey: '/broken',
                // A new closure on every build, as real parents pass.
                future: () => Future.error(StateError('offline')),
                buildContent: (_, document) => Text(document),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This page could not be loaded'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      // No router here, so restarting is the way out.
      expect(find.text('Restart app'), findsOneWidget);

      rebuild(() {});
      await tester.pumpAndSettle();
      expect(failures, hasLength(1));
      expect(failures.single.kind, vc.FailureKind.route);
      expect(failures.single.location, Uri.parse('/broken'));
      cancel();
    },
  );

  testWidgets('content that fails inside a page fails inline, without a '
      'route failure event', (tester) async {
    await start(tester);
    var routeFailures = 0;
    final cancel = vc.vyuh.event.on<vc.RouteFailureEvent>(
      (_) => routeFailures++,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DocumentFutureBuilder<String>(
            future: () => Future.error(StateError('offline')),
            buildContent: (_, document) => Text(document),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('error: Bad state: offline'), findsOneWidget);
    expect(routeFailures, 0);
    cancel();
  });

  testWidgets('a keyed document is not refetched when its parent rebuilds', (
    tester,
  ) async {
    await start(tester);
    var fetches = 0;
    var key = 'a';
    late StateSetter rebuild;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return DocumentFutureBuilder<String>(
              requestKey: key,
              future: () async {
                fetches++;
                return 'doc $key';
              },
              buildContent: (_, document) => Text(document),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(fetches, 1);

    rebuild(() {});
    await tester.pumpAndSettle();
    rebuild(() {});
    await tester.pumpAndSettle();
    expect(fetches, 1, reason: 'new closures alone must not refetch');

    rebuild(() => key = 'b');
    await tester.pumpAndSettle();
    expect(fetches, 2);
    expect(find.text('doc b'), findsOneWidget);
  });
}
