import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';

class MockContentPlugin extends Mock
    implements ContentPlugin, ContentProvider {}

void main() {
  group('VyuhContentWidget Builders', () {
    late MockContentPlugin mockContentPlugin;

    setUp(() {
      mockContentPlugin = MockContentPlugin();
      VyuhContentBinding.init(
        plugins: PluginDescriptor(content: mockContentPlugin),
        descriptors: [],
      );

      // Set up default mock behavior
      when(() => mockContentPlugin.fetchSingle<Document>(
            any(named: 'query'),
            fromJson: any(named: 'fromJson'),
            queryParams: any(named: 'queryParams'),
          )).thenAnswer((_) async => Document(title: 'Mock Document'));
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
      verify(() => mockContentPlugin.fetchSingle<Document>(
            any(that: contains('vyuh.document')),
            fromJson: Document.fromJson,
            queryParams: any(that: containsPair('identifier', 'test')),
          )).called(1);

      // Verify that content is built using VyuhContentBinding
      expect(find.byType(MockBuiltContent), findsOneWidget);
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
      verify(() => mockContentPlugin.fetchSingle<Document>(
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
      verify(() => mockContentPlugin.fetchSingle<Document>(
            any(that: contains('vyuh.document')),
            fromJson: Document.fromJson,
            queryParams: any(that: containsPair('identifier', testId)),
          )).called(1);
    });
  });
}

class MockBuiltContent extends StatelessWidget {
  const MockBuiltContent({super.key});

  @override
  Widget build(BuildContext context) => Container();
}
