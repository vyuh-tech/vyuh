import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';

class MockContentPlugin extends Mock
    implements ContentPlugin, ContentProvider {}

void main() {
  group('VyuhContentWidget', () {
    late MockContentPlugin mockContentPlugin;

    setUp(() {
      mockContentPlugin = MockContentPlugin();

      when(() => mockContentPlugin.init()).thenAnswer((_) async {});
      when(() => mockContentPlugin.attach(any())).thenReturn(null);
      when(() => mockContentPlugin.dispose()).thenAnswer((_) async {});

      // Set up default mock behavior
      when(() => mockContentPlugin.fetchSingle<Document>(
            any(),
            fromJson: any(named: 'fromJson'),
            queryParams: any(named: 'queryParams'),
          )).thenAnswer((_) async => Document(title: 'Mock Document'));

      when(() => mockContentPlugin.fetchMultiple<Document>(
            any(),
            fromJson: any(named: 'fromJson'),
            queryParams: any(named: 'queryParams'),
          )).thenAnswer((_) async => [
            Document(title: 'Mock Document 1'),
            Document(title: 'Mock Document 2'),
          ]);

      VyuhContentBinding.init(
        plugins: PluginDescriptor(content: mockContentPlugin),
        descriptors: [],
      );
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

      await tester.pumpAndSettle();

      // Verify mock was called with correct parameters
      verify(() => mockContentPlugin.fetchSingle<Document>(
            '*',
            fromJson: Document.fromJson,
            queryParams: null,
          )).called(1);

      // After loading, shows content
      expect(find.text('Mock Document'), findsOneWidget);
    });

    testWidgets('builds document list', (tester) async {
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

      await tester.pumpAndSettle();

      // Verify mock was called with correct parameters
      verify(() => mockContentPlugin.fetchMultiple<Document>(
            '*',
            fromJson: Document.fromJson,
            queryParams: null,
          )).called(1);

      expect(find.text('Mock Document 1'), findsOneWidget);
      expect(find.text('Mock Document 2'), findsOneWidget);
    });

    testWidgets('handles fetch error gracefully', (tester) async {
      when(() => mockContentPlugin.fetchSingle<Document>(
            any(named: 'query'),
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

      await tester.pumpAndSettle();

      // Should show error state
      expect(find.text('Error: Failed to fetch'), findsOneWidget);
    });
  });
}
