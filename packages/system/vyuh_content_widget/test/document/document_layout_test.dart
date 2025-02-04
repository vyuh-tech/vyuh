import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';

void main() {
  group('DocumentDefaultLayout', () {
    testWidgets('builds with title and description', (tester) async {
      final doc = Document(
        title: 'Test Title',
        description: 'Test Description',
      );
      final layout = DocumentDefaultLayout();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: layout.build(tester.element(find.byType(MaterialApp)), doc),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('builds without title and description', (tester) async {
      final doc = Document();
      final layout = DocumentDefaultLayout();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: layout.build(tester.element(find.byType(MaterialApp)), doc),
          ),
        ),
      );

      expect(find.byType(Text), findsNothing);
    });

    test('creates with correct schema name', () {
      expect(DocumentDefaultLayout.schemaName,
          equals('${Document.schemaName}.layout.default'));
    });

    test('type descriptor has correct values', () {
      expect(DocumentDefaultLayout.typeDescriptor.schemaType,
          equals(DocumentDefaultLayout.schemaName));
      expect(DocumentDefaultLayout.typeDescriptor.title,
          equals('Document Default Layout'));
      expect(DocumentDefaultLayout.typeDescriptor.fromJson,
          equals(DocumentDefaultLayout.fromJson));
    });
  });
}
