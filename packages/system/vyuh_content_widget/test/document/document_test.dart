import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';

void main() {
  group('Document', () {
    test('creates with correct schema name', () {
      expect(Document.schemaName, equals('vyuh.document'));
    });

    test('creates with title and description', () {
      final doc = Document(
        title: 'Test Title',
        description: 'Test Description',
      );

      expect(doc.title, equals('Test Title'));
      expect(doc.description, equals('Test Description'));
      expect(doc.schemaType, equals(Document.schemaName));
    });

    test('creates from json', () {
      final json = {
        'title': 'Test Title',
        'description': 'Test Description',
        'schemaType': Document.schemaName,
      };

      final doc = Document.fromJson(json);
      expect(doc.title, equals('Test Title'));
      expect(doc.description, equals('Test Description'));
    });

    test('type descriptor has correct values', () {
      expect(Document.typeDescriptor.schemaType, equals(Document.schemaName));
      expect(Document.typeDescriptor.title, equals('Document'));
      expect(Document.typeDescriptor.fromJson, equals(Document.fromJson));
    });

    test('content builder has correct configuration', () {
      expect(Document.contentBuilder.content, equals(Document.typeDescriptor));
      expect(Document.contentBuilder.defaultLayout, isA<DocumentDefaultLayout>());
      expect(Document.contentBuilder.defaultLayoutDescriptor, 
             equals(DocumentDefaultLayout.typeDescriptor));
    });
  });
}
