import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'utils.dart';

void main() {
  group('VyuhContentWidget Builders', () {
    late MockContentPlugin mockContentPlugin;
    late MockContentProvider mockContentProvider;

    setUp(() async {
      final mock = setupMock();
      mockContentPlugin = mock.$1;
      mockContentProvider = mock.$2;

      // Set up default mock behavior
      when(() => mockContentProvider.fetchSingle<Document>(
            any(),
            fromJson: any(named: 'fromJson'),
            queryParams: any(named: 'queryParams'),
          )).thenAnswer((_) async => Document(title: 'Mock Document'));

      VyuhContentBinding.init(
        plugins: PluginDescriptor(content: mockContentPlugin),
        descriptors: [],
      );

      await VyuhBinding.instance.widgetReady;
    });

    tearDown(() async {
      await VyuhBinding.instance.dispose();
    });

    testWidgets('fromDocument uses default builder when none provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VyuhContentWidget.fromDocument(
            identifier: 'test',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify mock was called with correct parameters
      verify(() => mockContentProvider.fetchSingle<Document>(
            any(that: contains('vyuh.document')),
            fromJson: Document.fromJson,
            queryParams: any(that: containsPair('identifier', 'test')),
          )).called(1);

      // Verify that content is built using VyuhContentBinding
      expect(find.widgetWithText(Text, 'Mock Document'), findsOneWidget);
    });

    testWidgets('fromDocument uses custom builder when provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VyuhContentWidget.fromDocument(
            identifier: 'test',
            builder: (context, doc) => Text(doc.title ?? ''),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify mock was called with correct parameters
      verify(() => mockContentProvider.fetchSingle<Document>(
            any(that: contains('vyuh.document')),
            fromJson: Document.fromJson,
            queryParams: any(that: containsPair('identifier', 'test')),
          )).called(1);

      expect(find.text('Mock Document'), findsOneWidget);
    });

    testWidgets('fromDocument uses correct query parameters', (tester) async {
      const testId = 'test-doc';

      await tester.pumpWidget(
        MaterialApp(
          home: VyuhContentWidget.fromDocument(
            identifier: testId,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify mock was called with correct parameters
      verify(() => mockContentProvider.fetchSingle<Document>(
            any(that: contains('vyuh.document')),
            fromJson: Document.fromJson,
            queryParams: any(that: containsPair('identifier', testId)),
          )).called(1);
    });
  });
}
