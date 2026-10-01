import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

class SchemaProvider extends Fake implements ContentProvider {
  @override
  String get title => 'Schema provider';
  @override
  Future<void> init() async {}
  @override
  Future<void> dispose() async {}
  @override
  String schemaType(Map<String, dynamic> json) => json['type'] as String;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'unknown embedded blocks preserve their Portable Text interface',
    () async {
      VyuhBinding.instance.widgetInit(
        plugins: PluginDescriptor(
          content: DefaultContentPlugin(provider: SchemaProvider()),
        ),
        extensionBuilder: ContentExtensionBuilder(),
        extensionDescriptors: [],
      );
      await VyuhBinding.instance.widgetReady;
      try {
        final blocks = system.PortableTextContent.blockItemsFromJson([
          {'type': 'unregistered', 'title': 'Missing'},
        ]);
        expect(blocks, hasLength(1));
        expect(blocks!.single, isA<system.UnknownPortableBlock>());
        expect(
          (blocks.single as system.UnknownPortableBlock).missingSchemaType,
          'unregistered',
        );
        expect(blocks.single.blockType, 'vyuh.unknown.portable');
      } finally {
        await VyuhBinding.instance.dispose();
      }
    },
  );
}
