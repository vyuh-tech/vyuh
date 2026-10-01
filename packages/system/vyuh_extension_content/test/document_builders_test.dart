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
}
