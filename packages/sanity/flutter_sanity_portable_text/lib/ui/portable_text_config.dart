import 'package:flutter/material.dart';

import '../flutter_sanity_portable_text.dart';

typedef TextStyleBuilder = TextStyle Function(
  TextStyle base,
  BuildContext context,
);

typedef BlockContainerBuilder = Widget Function(Widget, BuildContext);
typedef BlockWidgetBuilder = Widget Function(
  BuildContext context,
  PortableBlockItem item,
);

class PortableTextConfig {
  final Map<String, TextStyleBuilder> styles = {...defaultStyles};
  final Map<String, BlockWidgetBuilder> blocks = {...defaultBlocks};
  final Map<String, BlockContainerBuilder> blockContainers = {
    ...defaultBlockContainers
  };
  final Map<String, MarkDefDescriptor> markDefs = {};

  double listIndent = 16;
  EdgeInsets itemPadding = const EdgeInsets.only(bottom: 8);
  TextStyle? Function(BuildContext) baseStyle =
      (context) => Theme.of(context).textTheme.bodyMedium;

  static final PortableTextConfig shared = PortableTextConfig._();

  PortableTextConfig._();

  apply({
    final double listIndent = 16,
    final EdgeInsets itemPadding = const EdgeInsets.only(bottom: 8),
    final Map<String, TextStyleBuilder>? styles,
    final Map<String, BlockContainerBuilder>? blockContainers,
    final Map<String, BlockWidgetBuilder>? blocks,
    final Map<String, MarkDefDescriptor>? markDefs,
  }) {
    this.listIndent = listIndent;
    this.itemPadding = itemPadding;
    this.styles.addAll(styles ?? {});
    this.blockContainers.addAll(blockContainers ?? {});
    this.markDefs.addAll(markDefs ?? {});
    this.blocks.addAll(blocks ?? {});
  }

  static final Map<String, TextStyleBuilder> defaultStyles = {
    'h1': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        Theme.of(context).textTheme.headlineLarge!,
    'h2': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        Theme.of(context).textTheme.headlineMedium!,
    'h3': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        Theme.of(context).textTheme.headlineSmall!,
    'h4': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        Theme.of(context).textTheme.titleLarge!,
    'h5': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        Theme.of(context).textTheme.titleMedium!,
    'h6': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        Theme.of(context).textTheme.titleSmall!,
    'normal': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        Theme.of(context).textTheme.bodyMedium!,
    'em': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        base.copyWith(fontStyle: FontStyle.italic),
    'strong': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        base.copyWith(fontWeight: FontWeight.bold),
    'blockquote': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        base.copyWith(color: Theme.of(context).colorScheme.primary),
    'strike-through': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        base.copyWith(
          decoration: TextDecoration.combine([
            if (base.decoration != null) base.decoration!,
            TextDecoration.lineThrough
          ]),
        ),
    'underline': (
      final TextStyle base,
      final BuildContext context, [
      final MarkDef? mark,
    ]) =>
        base.copyWith(
          decoration: TextDecoration.combine([
            if (base.decoration != null) base.decoration!,
            TextDecoration.underline
          ]),
        ),
  };

  static final Map<String, BlockContainerBuilder> defaultBlockContainers = {
    'default': (final Widget child, final BuildContext context) => child,
    'blockquote': (final Widget child, final BuildContext context) {
      final theme = Theme.of(context);

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.colorScheme.secondary,
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: child,
        ),
      );
    },
  };

  static final Map<String, BlockWidgetBuilder> defaultBlocks = {
    'block': (final context, final item) => PortableTextBlock(
          model: item as TextBlockItem,
        ),
  };
}
