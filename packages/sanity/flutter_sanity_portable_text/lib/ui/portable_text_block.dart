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
          if (model.listItem != null) config.bulletRenderer(context, model),
          ...spans,
        ],
      ),
    );

    final builder = config.blockContainers[model.style] ??
        PortableTextConfig.defaultBlockContainerBuilder;

    final child = builder(context, content);

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

    // Step 1: Start with the base style
    final baseStyle = config.baseStyle(context) ??
        PortableTextConfig.defaultBaseStyle(context)!;

    final styleBuilder = config.styles[model.style];
    if (styleBuilder == null) {
      return _errorSpan('Missing style for ${model.style}');
    }

    var style =
        config.styles[model.style]?.call(context, baseStyle) ?? baseStyle;

    final pendingMarkDefs = <MarkDef>[];

    // Step 2: Accumulate the styles across all marks
    for (final mark in span.marks) {
      /// Standard marks (aka annotations)
      final builder = config.styles[mark];
      if (builder != null) {
        style = builder(context, style);
        continue;
      }

      /// Custom marks (aka annotations)
      final markDef = model.markDefs
          .firstWhereOrNull((final element) => element.key == mark);

      // A custom mark exists on this span but no corresponding markDef was found
      if (markDef == null) {
        return _errorSpan('Missing markDef for "$mark"');
      }

      pendingMarkDefs.add(markDef);
    }

    // Step 3: Continue building styles for custom markDefs
    for (final markDef in pendingMarkDefs) {
      final descriptor = config.markDefs[markDef.type];
      if (descriptor == null) {
        return _errorSpan('Missing markDef descriptor for "${markDef.type}"');
      }

      style = descriptor.styleBuilder.call(context, markDef, style);
    }

    // Step 4: Now build the final InlineSpan, if any
    InlineSpan? inlineSpan;
    int totalSpans = 0;

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
        return _errorSpan('''
We currently support a single custom markDef generating the InlineSpan. 
We found $totalSpans. The chain of markDefs was: $markDefChain.
 
Suggestion: Try to refactor your custom markDef chain to only generate a single InlineSpan. 
You can rely on TextStyles instead for custom styling.''');
      }
    }

    return inlineSpan ?? TextSpan(text: span.text, style: style);
  }

  WidgetSpan _errorSpan(final String message, {final bool asBlock = true}) {
    return WidgetSpan(
      child: ErrorView(
        message: message,
        asBlock: asBlock,
      ),
    );
  }
}
