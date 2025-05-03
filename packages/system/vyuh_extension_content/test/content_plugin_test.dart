import 'package:flutter/widgets.dart' hide runApp;
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_test/vyuh_test.dart';

import 'utils.dart';

void main() {
  group('ContentPlugin', () {
    late DefaultContentPlugin plugin;
    late ContentExtensionBuilder extBuilder;

    setUp(() {
      plugin = DefaultContentPlugin(provider: MockContentProvider());
      extBuilder = ContentExtensionBuilder();

      // Initialize the Vyuh platform with feature descriptor
      runApp(
        features: () => [
          FeatureDescriptor(
            name: 'test_feature',
            title: 'Test Feature',
            routes: () => [],
            extensions: [
              ContentExtensionDescriptor(
                contentBuilders: [TestContentItem.contentBuilder],
                contents: [TestContentDescriptor()],
                contentModifiers: [TestModifier.typeDescriptor],
              ),
            ],
            extensionBuilders: [extBuilder],
          ),
        ],
        plugins: PluginDescriptor(
          content: plugin,
        ),
      );
    });

    testWidgets('initializes correctly', (tester) async {
      await vyuh.getReady(tester);

      expect(vyuh.content, isNotNull);
      expect(vyuh.content.provider, isNotNull);
    });

    testWidgets('registers type descriptors', (tester) async {
      await vyuh.getReady(tester);

      expect(
          vyuh.content.isRegistered(TestContentItem.typeDescriptor.schemaType),
          isTrue);
      expect(vyuh.content.isRegistered(TestModifier.typeDescriptor.schemaType),
          isTrue);
    });

    testWidgets('creates content item from json', (tester) async {
      await vyuh.getReady(tester);

      final json = {
        'id': 'test123',
        'title': 'Test Title',
        'type': TestContentItem.schemaName,
      };

      final content = plugin.fromJson<TestContentItem>(json);
      expect(content, isNotNull);
      expect(content?.id, equals('test123'));
      expect(content?.title, equals('Test Title'));
    });

    testWidgets('returns null for unregistered type', (tester) async {
      await vyuh.getReady(tester);

      final json = {
        'id': 'test123',
        'title': 'Test Title',
        'type': 'unknown_type',
      };

      final content = plugin.fromJson<TestContentItem>(json);
      expect(content, isNull);
    });

    testWidgets('builds content widget', (tester) async {
      await vyuh.getReady(tester);

      final content = TestContentItem(
        id: 'test123',
        title: 'Test Title',
      );

      final widget = plugin.buildContent(TestBuildContext(), content);
      expect(widget, isA<Padding>());
      expect((widget as Padding).padding, equals(EdgeInsets.zero));
    });

    testWidgets('builds route widget', (tester) async {
      await vyuh.getReady(tester);

      final widget = plugin.buildRoute(
        TestBuildContext(),
        url: Uri.parse('https://example.com'),
      );
      expect(widget, isA<DocumentFutureBuilder>());
    });

    testWidgets('handles content with layout configuration', (tester) async {
      await vyuh.getReady(tester);

      final json = {
        'id': 'test123',
        'title': 'Test Title',
        'type': TestContentItem.schemaName,
        'layout': [
          {
            'type': TestLayoutConfiguration.schemaName,
            'padding': 16,
          }
        ],
      };

      final content = plugin.fromJson<TestContentItem>(json);
      expect(content, isNotNull);
      expect(content?.layout, isNotNull);
      expect(content?.layout, isA<TestLayoutConfiguration>());
      expect(
          (content?.layout as TestLayoutConfiguration).padding, equals(16.0));
    });

    testWidgets('handles content with modifiers', (tester) async {
      await vyuh.getReady(tester);

      final json = {
        'id': 'test123',
        'title': 'Test Title',
        'type': TestContentItem.schemaName,
        'modifiers': [
          {
            'type': TestModifier.schemaName,
            'enabled': true,
          }
        ],
      };

      final content = plugin.fromJson<TestContentItem>(json);
      expect(content, isNotNull);
      expect(content?.modifiers, isNotNull);
      expect(content?.modifiers?.length, equals(1));
      expect(content?.modifiers?.first, isA<TestModifier>());
      expect((content?.modifiers?.first as TestModifier).enabled, isTrue);
    });
  });
}
