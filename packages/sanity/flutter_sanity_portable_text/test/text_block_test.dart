import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() {
  setUp(() {
    PortableTextConfig.shared.reset();
  });

  testWidgets('TextBlockItem can be loaded from json',
      (WidgetTester tester) async {
    final block = TextBlockItem.fromJson({
      '_key': 'key',
      'style': 'normal',
      'children': [
        {'_key': 'key', 'text': 'Hello, '},
        {
          '_key': 'key',
          'text': 'World',
          'marks': ['strong']
        },
      ],
    });

    expect(block.key, 'key');
    expect(block.style, 'normal');
    expect(block.children.length, 2);
    expect(block.children[0].text, 'Hello, ');
    expect(block.children[1].text, 'World');
    expect(block.children[1].marks, ['strong']);
  });

  testWidgets('TextBlockItem loaded from json has correct list-item properties',
      (WidgetTester tester) async {
    final block = TextBlockItem.fromJson({
      'listItem': 'square',
      'children': [
        {'text': 'Hello, '},
      ],
    });

    expect(block.listItem, ListItemType.square);

    final block2 = TextBlockItem.fromJson({
      'listItem': 'bullet',
      'children': [
        {'text': 'Hello, '},
      ],
    });

    expect(block2.listItem, ListItemType.bullet);

    final block3 = TextBlockItem.fromJson({
      'listItem': 'number',
      'children': [
        {'text': 'Hello, '},
      ],
    });

    expect(block3.listItem, ListItemType.number);
  });

  testWidgets('MarkDef can be loaded from json', (WidgetTester tester) async {
    PortableTextConfig.shared.markDefs[CustomMarkDef.schemaName] =
        MarkDefDescriptor(
      schemaType: 'schemaType',
      fromJson: (json) => CustomMarkDef.fromJson(json),
      styleBuilder: (context, markDef, style) => style,
    );

    expect(() => MarkDef.fromJson({}), throwsUnsupportedError);
  });
}
