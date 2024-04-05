import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() {
  setUp(() {
    PortableTextConfig.shared.reset();
  });

  testWidgets('PortableText can apply a custom style to a mark type',
      (WidgetTester tester) async {
    PortableTextConfig.shared.markDefs[CustomMarkDef.schemaName] =
        MarkDefDescriptor(
      schemaType: CustomMarkDef.schemaName,
      fromJson: (json) => CustomMarkDef.fromJson(json),
      styleBuilder: (context, markDef, style) {
        return style.apply(color: (markDef as CustomMarkDef).color);
      },
    );

    final blocks = [
      TextBlockItem(
        children: [
          Span(text: 'Hello, World', marks: ['custom-key']),
        ],
        markDefs: [
          CustomMarkDef(
            color: Colors.red,
            key: 'custom-key',
          ),
        ],
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    TextSpan? textSpan = findTextSpan((span) => span.text == 'Hello, World');
    expect(textSpan?.style?.color, Colors.red);
  });

  // test if a custom block style can be applied
  testWidgets('PortableText can apply a custom block style',
      (WidgetTester tester) async {
    PortableTextConfig.shared.styles[_CustomBlockItem.schemaName] =
        (context, style) {
      return const TextStyle(color: Colors.red);
    };

    final blocks = [
      TextBlockItem(
        children: [
          Span(text: 'Hello, World'),
        ],
        style: _CustomBlockItem.schemaName,
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    TextSpan? textSpan = findTextSpan((span) => span.text == 'Hello, World');
    expect(textSpan?.style?.color, Colors.red);
  });

  testWidgets('PortableText can apply a custom block',
      (WidgetTester tester) async {
    PortableTextConfig.shared.blocks[_CustomBlockItem.schemaName] =
        (context, item) {
      return const Text('Hello, World');
    };

    final blocks = [
      _CustomBlockItem(),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    expect(find.text('Hello, World'), findsOneWidget);
  });

  testWidgets('PortableText can apply a custom blockContainer',
      (WidgetTester tester) async {
    PortableTextConfig.shared.styles['custom-block'] = (context, style) {
      return const TextStyle(color: Colors.red);
    };
    PortableTextConfig.shared.blockContainers['custom-block'] =
        (context, child) {
      return Container(
        color: Colors.red,
        child: child,
      );
    };

    final blocks = [
      TextBlockItem(
        children: [
          Span(text: 'Hello, World'),
        ],
        style: 'custom-block',
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    expect(find.byType(Container), findsOneWidget);
    expect((find.byType(Container).evaluate().first.widget as Container).color,
        Colors.red);
    expect(find.text('Hello, World'), findsOneWidget);
  });
}

final class _CustomBlockItem implements PortableBlockItem {
  static const schemaName = 'custom-block';

  @override
  String get blockType => schemaName;
}
