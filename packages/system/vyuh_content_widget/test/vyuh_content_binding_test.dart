import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'utils.dart';

void main() {
  group('VyuhContentBinding', () {
    late MockContentPlugin mockContentPlugin;
    late MockWidgetBuilder mockWidgetBuilder;

    setUp(() {
      final mock = setupMock();
      mockContentPlugin = mock.$1;
      mockWidgetBuilder = MockWidgetBuilder();
    });

    tearDown(() async {
      await VyuhBinding.instance.dispose();
    });

    test('init sets up binding layer correctly', () async {
      var readyCallbackInvoked = false;

      VyuhContentBinding.init(
        plugins: PluginDescriptor(content: mockContentPlugin),
        widgetBuilder: mockWidgetBuilder,
        onReady: (_) async {
          readyCallbackInvoked = true;
        },
      );

      await VyuhBinding.instance.widgetReady;
      expect(readyCallbackInvoked, isTrue);

      expect(VyuhBinding.instance.initInvoked, isTrue);
      expect(VyuhBinding.instance.content, equals(mockContentPlugin));
      expect(VyuhBinding.instance.widgetBuilder, equals(mockWidgetBuilder));
    });

    test('standardDescriptors includes required descriptors', () {
      final descriptors = VyuhContentBinding.standardDescriptors;

      // Should have system descriptor and content descriptor
      expect(descriptors.length, equals(2));

      // Content descriptor should include Document
      final contentDescriptor = descriptors[1];
      expect(contentDescriptor.contents?.length, equals(1));
      expect(contentDescriptor.contentBuilders?.length, equals(1));

      // Verify Document descriptor and builder
      expect(contentDescriptor.contents?[0].schemaType,
          equals(Document.schemaName));
      expect(contentDescriptor.contentBuilders?[0],
          equals(Document.contentBuilder));
    });

    test('content getter returns VyuhBinding content plugin', () async {
      VyuhContentBinding.init(
        plugins: PluginDescriptor(content: mockContentPlugin),
        descriptors: [],
      );

      await VyuhBinding.instance.widgetReady;

      expect(VyuhContentBinding.content, equals(mockContentPlugin));
    });

    test('widgetBuilder getter returns VyuhBinding widget builder', () async {
      VyuhContentBinding.init(
        plugins: PluginDescriptor(content: mockContentPlugin),
        widgetBuilder: mockWidgetBuilder,
        descriptors: [],
      );

      await VyuhBinding.instance.widgetReady;

      expect(VyuhContentBinding.widgetBuilder, equals(mockWidgetBuilder));
    });
  });
}
