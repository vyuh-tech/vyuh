import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

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

    expect(
        findTextSpan((span) =>
            span.text == 'test' && span.style?.fontStyle == FontStyle.italic),
        isNotNull);
  });

  testWidgets('PortableTextConfig applies configuration correctly',
      (widgetTester) async {
    PortableTextConfig.shared.apply(
      listIndent: 20,
      itemPadding: const EdgeInsets.only(bottom: 10),
      styles: {
        'normal': (context, base) {
          return base.copyWith(
            color: Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          );
        },
      },
    );

    await widgetTester.pumpWidget(MaterialApp(
      home: PortableText(blocks: [
        TextBlockItem(children: [
          Span(text: 'Hello'),
        ]),
      ]),
    ));

    expect(PortableTextConfig.shared.listIndent, 20);
    expect(PortableTextConfig.shared.itemPadding,
        const EdgeInsets.only(bottom: 10));
    expect(findTextSpan((span) => span.style?.fontSize == 18), isNotNull);
  });

  testWidgets(
      'PortableText uses the default-baseStyle when a baseStyle is missing',
      (WidgetTester tester) async {
    PortableTextConfig.shared.baseStyle = (_) => null;

    final blocks = [
      TextBlockItem(
        children: [
          Span(text: 'Hello, World'),
        ],
      ),
    ];

    final navKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navKey,
      home: PortableText(blocks: blocks),
    ));

    expect(
        findTextSpan((span) =>
            span.style?.fontSize != null &&
            span.style?.fontSize ==
                PortableTextConfig.defaultBaseStyle(navKey.currentContext!)
                    ?.fontSize),
        isNotNull);
  });

  testWidgets('PortableTextBlock applies itemPadding correctly',
      (WidgetTester tester) async {
    PortableTextConfig.shared.itemPadding = const EdgeInsets.only(bottom: 10);

    final block = TextBlockItem(children: [
      Span(text: 'Hello, World'),
    ]);

    await tester.pumpWidget(MaterialApp(
      home: PortableTextBlock(model: block),
    ));

    final padding = tester.widget<Padding>(find.byType(Padding));
    expect(padding.padding, PortableTextConfig.shared.itemPadding);
  });

  testWidgets('PortableTextBlock applies left padding for list items',
      (WidgetTester tester) async {
    PortableTextConfig.shared.listIndent = 20;

    final block = TextBlockItem(
      children: [
        Span(text: 'Hello, World'),
      ],
      listItem: ListItemType.number,
      level: 1,
    );

    await tester.pumpWidget(MaterialApp(
      home: PortableTextBlock(model: block),
    ));

    final padding = tester.widget<Padding>(find.byType(Padding));
    expect((padding.padding as EdgeInsets).left, 20);
  });
}
