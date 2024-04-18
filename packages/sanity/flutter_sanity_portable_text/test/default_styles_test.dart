import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() {
  setUp(() {
    PortableTextConfig.shared.reset();
  });

  testWidgets('PortableText renders the default span styles correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PortableText(blocks: [
        TextBlockItem(children: [
          Span(text: 'Normal', marks: ['normal']),
          Span(text: 'Strong', marks: ['strong']),
          Span(text: 'Emphasized', marks: ['em']),
          Span(text: 'Strike Through', marks: ['strike-through']),
          Span(text: 'Underline', marks: ['underline']),
          Span(text: 'Inline Code', marks: ['code']),
        ]),
      ]),
    ));

    final Map<String, bool Function(TextSpan)> predicates = {
      'Normal': (span) =>
          span.style?.debugLabel?.contains('bodyMedium') == true,
      'Strong': (span) => span.style?.fontWeight == FontWeight.bold,
      'Emphasized': (span) => span.style?.fontStyle == FontStyle.italic,
      'Strike Through': (span) =>
          span.style?.decoration?.contains(TextDecoration.lineThrough) == true,
      'Underline': (span) =>
          span.style?.decoration?.contains(TextDecoration.underline) == true,
      'Inline Code': (span) =>
          span.style?.fontFamily?.contains('monospace') == true,
    };

    for (final entry in predicates.entries) {
      expect(
          findTextSpan((span) => span.text == entry.key && entry.value(span)),
          isNotNull);
    }
  });

  testWidgets('PortableText renders the default block styles correctly',
      (WidgetTester tester) async {
    final navKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MaterialApp(
      navigatorKey: navKey,
      home: PortableText(blocks: [
        _textBlock('h1'),
        _textBlock('h2'),
        _textBlock('h3'),
        _textBlock('h4'),
        _textBlock('h5'),
        _textBlock('h6'),
        _textBlock('blockquote'),
      ]),
    ));

    final Map<String, bool Function(TextSpan)> predicates = {
      'h1': (span) =>
          span.style != null &&
          span.style ==
              Theme.of(navKey.currentContext!).textTheme.headlineLarge,
      'h2': (span) =>
          span.style != null &&
          span.style ==
              Theme.of(navKey.currentContext!).textTheme.headlineMedium,
      'h3': (span) =>
          span.style != null &&
          span.style ==
              Theme.of(navKey.currentContext!).textTheme.headlineSmall,
      'h4': (span) =>
          span.style != null &&
          span.style == Theme.of(navKey.currentContext!).textTheme.titleLarge,
      'h5': (span) =>
          span.style != null &&
          span.style == Theme.of(navKey.currentContext!).textTheme.titleMedium,
      'h6': (span) =>
          span.style != null &&
          span.style == Theme.of(navKey.currentContext!).textTheme.titleSmall,
      'blockquote': (span) =>
          span.style != null &&
          span.style?.color ==
              Theme.of(navKey.currentContext!).colorScheme.primary,
    };

    for (final entry in predicates.entries) {
      expect(
          findTextSpan((span) => span.text == entry.key && entry.value(span)),
          isNotNull);
    }
  });

  testWidgets('PortableText renders the default block containers correctly',
      (WidgetTester tester) async {
    final navKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MaterialApp(
      navigatorKey: navKey,
      home: PortableText(blocks: [
        _textBlock('blockquote'),
      ]),
    ));

    final container =
        find.byType(Container).evaluate().first.widget as Container;
    expect(container.decoration, isInstanceOf<BoxDecoration>());
  });

  // test that a bullet item is rendered correctly
  testWidgets('PortableText renders a bullet item correctly',
      (WidgetTester tester) async {
    final navKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MaterialApp(
      navigatorKey: navKey,
      home: PortableText(blocks: [
        TextBlockItem(
          children: [
            Span(text: 'Hello'),
          ],
          listItem: ListItemType.bullet,
        ),
        TextBlockItem(
          children: [
            Span(text: 'Hello'),
          ],
          listItem: ListItemType.square,
        ),
        TextBlockItem(
          children: [
            Span(text: 'Hello'),
          ],
          listItem: ListItemType.number,
        ),
      ]),
    ));

    expect(find.byIcon(Icons.circle), findsOne);
    expect(find.byIcon(Icons.check_box_outline_blank), findsOne);
    expect(find.textContaining('1. '), findsOne);
  });
}

TextBlockItem _textBlock(String style) {
  return TextBlockItem(children: [Span(text: style)], style: style);
}
