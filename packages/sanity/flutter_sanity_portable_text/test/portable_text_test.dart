import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    PortableTextConfig.shared.reset();
  });

  testWidgets('PortableText can be created with required parameters',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: PortableText(blocks: []),
    ));

    expect(find.byType(PortableText), findsOneWidget);
  });

  testWidgets(
      'PortableText uses primary scroller when usePrimaryScroller is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: PortableText(blocks: [], usePrimaryScroller: true),
    ));

    final listView = tester.widget<ListView>(find.byType(ListView));
    expect(listView.primary, isTrue);
  });

  testWidgets('PortableText shrink-wraps the list view when shrinkwrap is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: PortableText(blocks: [], shrinkwrap: true),
    ));

    final listView = tester.widget<ListView>(find.byType(ListView));
    expect(listView.shrinkWrap, isTrue);
  });

  testWidgets('PortableText correctly renders the blocks passed to it',
      (WidgetTester tester) async {
    final blocks = [
      TextBlockItem(children: [
        Span(text: 'Hello, '),
        Span(text: 'World', marks: ['strong']),
      ]),
      TextBlockItem(children: [
        Span(text: 'This is a '),
        Span(text: 'test', marks: ['em']),
      ]),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    expect(find.text('Hello, World', findRichText: true), findsOneWidget);
    expect(find.textContaining('test', findRichText: true), findsOneWidget);

    matchTextWithStyle(RichText widget, String text) {
      return widget.text.visitChildren((span) {
        if (span is TextSpan &&
            span.text == text &&
            span.style?.fontStyle == FontStyle.italic) return false;
        return true;
      });
    }

    expect(
        find.byWidgetPredicate((widget) =>
            widget is RichText && matchTextWithStyle(widget, 'test')),
        findsOne);
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
        markDefs: [_CustomMarkDef(key: 'missing-key', color: Colors.red)],
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    expect(find.byType(ErrorView), findsOneWidget);
  });

  // test for a custom style
  testWidgets('PortableText can apply a custom style to a mark type',
      (WidgetTester tester) async {
    PortableTextConfig.shared.markDefs['custom-mark'] = MarkDefDescriptor(
      schemaType: 'custom-mark',
      fromJson: (json) => _CustomMarkDef.fromJson(json),
      styleBuilder: (context, markDef, style) {
        return style.apply(color: (markDef as _CustomMarkDef).color);
      },
    );

    final blocks = [
      TextBlockItem(
        children: [
          Span(text: 'Hello, World', marks: ['custom-key']),
        ],
        markDefs: [
          _CustomMarkDef(
            color: Colors.red,
            key: 'custom-key',
          ),
        ],
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    final richText = find.byType(RichText).evaluate().first.widget as RichText;
    TextSpan? textSpan;
    richText.text.visitChildren((span) {
      if (span is TextSpan && span.toPlainText() == 'Hello, World') {
        textSpan = span;
        return false;
      }

      return true;
    });

    expect(textSpan?.style?.color, Colors.red);
  });
}

class _CustomMarkDef extends MarkDef {
  final Color color;

  _CustomMarkDef({required this.color, required super.key})
      : super(type: 'custom-mark');

  factory _CustomMarkDef.fromJson(final Map<String, dynamic> json) {
    return _CustomMarkDef(
      color: Color(json['color']),
      key: json['_key'],
    );
  }
}

final class _MissingBlockItem implements PortableBlockItem {
  @override
  final String blockType = 'missing-block';

  const _MissingBlockItem();
}
