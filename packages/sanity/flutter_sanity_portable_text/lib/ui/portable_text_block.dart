import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../flutter_sanity_portable_text.dart';

class PortableTextBlock extends StatelessWidget {
  final TextBlockItem model;

  const PortableTextBlock({super.key, required this.model});

  @override
  Widget build(final BuildContext context) {
    final config = PortableTextConfig.shared;

    final spans = model.children
        .map((final span) => _convertSpan(span, Theme.of(context), context))
        .toList(growable: false);

    final content = Text.rich(
      TextSpan(
        children: [
          if (model.listItem != null) _bulletMark(context),
          ...spans,
        ],
      ),
    );

    final builder = config.blockContainers[model.style] ??
        config.blockContainers['default']!;
    final child = builder(content, context);

    final leftPadding =
        model.listItem == null ? 0.0 : config.listIndent * (model.level ?? 0);

    return Padding(
      padding: config.itemPadding.add(EdgeInsets.only(left: leftPadding)),
      child: child,
    );
  }

  InlineSpan _convertSpan(
    final Span span,
    final ThemeData theme,
    final BuildContext context,
  ) {
    final config = PortableTextConfig.shared;

    final baseStyle = config.baseStyle(context) ?? theme.textTheme.bodyLarge!;

    var style =
        config.styles[model.style]?.call(baseStyle, context) ?? baseStyle;

    final pendingMarkDefs = <MarkDef>[];
    for (final mark in span.marks) {
      /// Standard marks (aka annotations)
      final builder = config.styles[mark];
      if (builder != null) {
        style = builder(style, context);
        continue;
      }

      /// Custom marks (aka annotations)
      final markDef = model.markDefs
          .firstWhereOrNull((final element) => element.key == mark);

      if (markDef == null) {
        continue;
      }

      pendingMarkDefs.add(markDef);
    }

    GestureRecognizer? recognizer;

    for (final markDef in pendingMarkDefs) {
      final descriptor = config.markDefs[markDef.type];
      if (descriptor == null) {
        debugPrint('Missing descriptor for markDef: ${markDef.type}');
        continue;
      }

      style = descriptor.styleBuilder?.call(markDef, context, style) ?? style;

      final currentRecognizer =
          descriptor.recognizerBuilder?.call(markDef, context);
      assert(recognizer == null && currentRecognizer != null,
          'There can only be one recognizer for a set of MarkDefs. We found more than one.');

      recognizer = currentRecognizer;
    }

    return TextSpan(
      text: span.text,
      recognizer: recognizer,
      style: style,
    );
  }

  InlineSpan _bulletMark(final BuildContext context) {
    final textStyle = PortableTextConfig.shared.baseStyle(context);

    switch (model.listItem) {
      case ListItemType.bullet:
        return WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.circle, size: 8),
          ),
          style: textStyle,
        );
      case ListItemType.number:
        return TextSpan(
          text: '${(model.listItemIndex ?? 0) + 1}.  ',
          style: textStyle,
        );
      default:
        return WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.check_box_outline_blank, size: 6),
          ),
          style: textStyle,
        );
    }
  }
}
