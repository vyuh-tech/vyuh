import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
    final blocks = [const MissingPortableBlockItem()];

    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: blocks),
    ));

    expect(find.byType(ErrorView), findsOneWidget);
  });
}

final class MissingPortableBlockItem implements PortableBlockItem {
  @override
  final String blockType = 'missingType';

  const MissingPortableBlockItem();
}
