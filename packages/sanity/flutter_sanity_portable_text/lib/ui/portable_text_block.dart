import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../flutter_sanity_portable_text.dart';

/// Renders a single block of Portable Text. This widget is used internally by the
/// [PortableText] widget. It is not meant to be used directly for most common scenarios. If you
/// need to render a single block of Portable Text, consider using the [PortableText] widget.
///
/// This widget is responsible for rendering the text content of a block, including any marks
/// (annotations) that are applied to the text. It also handles rendering of list items. It relies
/// on the [PortableTextConfig] to determine the visual representation of the block.
class PortableTextBlock extends StatelessWidget {
  /// The model representing the block of Portable Text.
  final TextBlockItem model;

  const PortableTextBlock({super.key, required this.model});

  @override
  Widget build(final BuildContext context) {
    final config = PortableTextConfig.shared;

    final spans = model.children
        .map((final span) => _buildInlineSpan(span, Theme.of(context), context))
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

  InlineSpan _buildInlineSpan(
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

    String? errorText;

    // Build the style across all marks
    for (final markDef in pendingMarkDefs) {
      final descriptor = config.markDefs[markDef.type];
      if (descriptor == null) {
        errorText = 'Missing markDef descriptor for "${markDef.type}"';
        continue;
      }

      style = descriptor.styleBuilder?.call(context, markDef, style) ?? style;
    }

    // Now build the final InlineSpan, if any
    InlineSpan? inlineSpan;
    int totalSpans = 0;

    // Only go ahead if there are no errors from previous step
    if (errorText == null) {
      for (final markDef in pendingMarkDefs) {
        final descriptor = config.markDefs[markDef.type];
        inlineSpan =
            descriptor?.spanBuilder?.call(context, markDef, span.text, style);

        if (inlineSpan == null) {
          continue;
        }

        totalSpans++;
        if (totalSpans > 1) {
          final markDefChain = pendingMarkDefs.map((e) => e.type).join(' -> ');
          errorText = '''
We currently support a single custom markDef generating the InlineSpan. 
We found $totalSpans. The chain of markDefs was: $markDefChain.
 
Suggestion: Try to refactor your custom markDef chain to only generate a single InlineSpan. 
You can rely on TextStyles instead for custom styling.''';
          break;
        }
      }
    }

    if (errorText != null) {
      return WidgetSpan(
        child: GestureDetector(
          child: ErrorView(
            message: errorText,
            asBlock: false,
          ),
        ),
      );
    }

    return inlineSpan ?? TextSpan(text: span.text, style: style);
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
            child: Icon(Icons.check_box_outline_blank, size: 8),
          ),
          style: textStyle,
        );
    }
  }
}
