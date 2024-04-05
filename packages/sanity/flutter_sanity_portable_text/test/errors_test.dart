import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() {
  setUp(() {
    PortableTextConfig.shared.reset();
  });

  testWidgets(
      'PortableText shows an ErrorView when a builder for a block type is missing',
      (WidgetTester tester) async {
    final blocks = [const _MissingBlockItem()];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    expect(find.byType(ErrorView), findsOneWidget);
  });

  testWidgets(
      'PortableText shows an ErrorView when a MarkDef is missing for a mark type',
      (WidgetTester tester) async {
    final blocks = [
      TextBlockItem(
        children: [
          Span(text: 'Hello, ', marks: ['missing-mark']),
        ],
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    expect(find.byType(ErrorView), findsOneWidget);
  });

  testWidgets(
      'PortableText shows an ErrorView when a builder is missing for a mark type',
      (WidgetTester tester) async {
    final blocks = [
      TextBlockItem(
        children: [
          Span(text: 'Hello, ', marks: ['missing-key']),
        ],
        markDefs: [CustomMarkDef(key: 'missing-key', color: Colors.red)],
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    expect(find.byType(ErrorView), findsOneWidget);
  });

  testWidgets('PortableText shows an ErrorView when a block style is missing',
      (WidgetTester tester) async {
    final blocks = [
      TextBlockItem(
        style: 'missing-style',
        children: [Span(text: 'Hello, world!')],
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    expect(find.byType(ErrorView), findsOneWidget);
  });

  // shows error when multiple markDefs return an inlineSpan
  testWidgets(
      'PortableText shows an ErrorView when multiple markDefs return an InlineSpan',
      (WidgetTester tester) async {
    PortableTextConfig.shared.markDefs[CustomMarkDef.schemaName] =
        MarkDefDescriptor(
      schemaType: CustomMarkDef.schemaName,
      fromJson: (json) => CustomMarkDef.fromJson(json),
      styleBuilder: (context, markDef, style) => style,
      spanBuilder: (context, markDef, text, style) => TextSpan(
        text: text,
        style: style.copyWith(color: (markDef as CustomMarkDef).color),
      ),
    );

    final blocks = [
      TextBlockItem(
        children: [
          Span(text: 'Hello, ', marks: ['one', 'two']),
        ],
        markDefs: [
          CustomMarkDef(key: 'one', color: Colors.red),
          CustomMarkDef(key: 'two', color: Colors.blue),
        ],
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.textContaining('single custom markDef', findRichText: true),
        findsOneWidget);
  });
}

final class _MissingBlockItem implements PortableBlockItem {
  @override
  final String blockType = 'missing-block';

  const _MissingBlockItem();
}
