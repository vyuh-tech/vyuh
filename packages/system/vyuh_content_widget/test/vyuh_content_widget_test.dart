import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'utils.dart';

void main() {
  group('VyuhContentWidget', () {
    late MockContentPlugin mockContentPlugin;
    late MockContentProvider mockContentProvider;

    setUp(() async {
      final mock = setupMock();
      mockContentPlugin = mock.$1;
      mockContentProvider = mock.$2;

      VyuhContentBinding.init(
        plugins: PluginDescriptor(content: mockContentPlugin),
        descriptors: [],
      );

      await VyuhBinding.instance.widgetReady;
    });

    tearDown(() async {
      await VyuhBinding.instance.dispose();
    });

    testWidgets('requires either builder or listBuilder', (tester) async {
      expect(
        () => VyuhContentWidget(
          query: '*',
          fromJson: Document.fromJson,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('cannot have both builder and listBuilder', (tester) async {
      expect(
        () => VyuhContentWidget(
          query: '*',
          fromJson: Document.fromJson,
          builder: (_, __) => Container(),
          listBuilder: (_, __) => Container(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('builds single document', (tester) async {
      when(() => mockContentProvider.fetchSingle<Document>(
            '*',
            fromJson: Document.fromJson,
          )).thenAnswer((_) async => Document(title: 'Mock Document'));

      await tester.pumpWidget(
        MaterialApp(
          home: VyuhContentWidget(
            query: '*',
            fromJson: Document.fromJson,
            builder: (context, doc) => Text(doc.title ?? ''),
          ),
        ),
      );

      // Initially shows loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 200));

      // Verify mock was called with correct parameters
      verify(() => mockContentProvider.fetchSingle<Document>(
            '*',
            fromJson: Document.fromJson,
          )).called(1);

      // After loading, shows content
      expect(find.text('Mock Document'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('builds document list', (tester) async {
      when(() => mockContentProvider.fetchMultiple<Document>(
            any(),
            fromJson: any(named: 'fromJson'),
            queryParams: any(named: 'queryParams'),
          )).thenAnswer((_) async => [
            Document(title: 'Mock Document 1'),
            Document(title: 'Mock Document 2'),
          ]);

      await tester.pumpWidget(
        MaterialApp(
          home: VyuhContentWidget(
            query: '*',
            fromJson: Document.fromJson,
            listBuilder: (context, docs) => Column(
              children: docs.map((d) => Text(d.title ?? '')).toList(),
            ),
          ),
        ),
      );

      // Initially shows loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the async operation to complete and widget to rebuild
      await tester.pump(); // Process current frame

      expect(find.text('Mock Document 1'), findsOneWidget);
      expect(find.text('Mock Document 2'), findsOneWidget);
    });

    testWidgets('handles fetch error gracefully', (tester) async {
      // Override the default mock behavior for this test
      final mockProvider = mockContentPlugin.provider as MockContentProvider;
      when(() => mockProvider.fetchSingle<Document>(
            any(),
            fromJson: any(named: 'fromJson'),
            queryParams: any(named: 'queryParams'),
          )).thenThrow(Exception('Failed to fetch'));

      await tester.pumpWidget(
        MaterialApp(
          home: VyuhContentWidget(
            query: '*',
            fromJson: Document.fromJson,
            builder: (context, doc) => Text(doc.title ?? ''),
          ),
        ),
      );

      // Initially shows loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the async operation to complete and widget to rebuild
      await tester.pump(); // Process current frame
      await tester
          .pump(const Duration(milliseconds: 100)); // Wait for async work
      await tester.pump(); // Process frame after async work

      // Should show error state
      expect(find.text('Error: Failed to fetch'), findsOneWidget);
    });
  });
}
