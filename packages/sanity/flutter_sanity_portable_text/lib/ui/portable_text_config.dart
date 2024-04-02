import 'package:flutter/material.dart';

import '../flutter_sanity_portable_text.dart';

/// A function that builds a text style for a Portable Text block or span.
typedef TextStyleBuilder = TextStyle Function(
  TextStyle base,
  BuildContext context,
);

/// A function that builds a widget for a Portable block container.
typedef BlockContainerBuilder = Widget Function(Widget, BuildContext);

/// A function that builds a widget for a Portable block item.
typedef BlockWidgetBuilder = Widget Function(
  BuildContext context,
  PortableBlockItem item,
);

/// The configuration used for rendering Portable Text. This class is used to
/// define the visual representation of the Portable Text blocks, spans, and marks. It
/// is used by the [PortableText] widget to render the Portable Text content. The
/// configuration can be customized to match the visual design of the app. The default
/// configuration is based on the Material Design guidelines.
///
/// Note that the configuration is shared across all instances of the [PortableText] widget.
class PortableTextConfig {
  /// The styles used to render the Portable Text content. The keys are the style names used
  /// in the Portable Text content, such as "h1", "h2", "blockquote", etc. The default styles
  /// are based on the Material Design typography guidelines. You can customize the styles by
  /// providing a custom style builder for each style.
  final Map<String, TextStyleBuilder> styles = {...defaultStyles};

  /// The block widgets used to render the Portable Text content. The keys are the block type names
  /// used in the Portable Text content. The default block is a single [PortableTextBlock], named as "block".
  /// You can customize the rendering of each block type by providing a custom block widget builder.
  final Map<String, BlockWidgetBuilder> blocks = {...defaultBlocks};

  /// The block containers used to wrap the block widgets. The keys are the block container type names
  /// used in the Portable Text content. The default block container is a simple container, named as "default".
  /// You can customize the rendering of each block container type by providing a custom block container builder.
  final Map<String, BlockContainerBuilder> blockContainers = {
    ...defaultBlockContainers
  };

  /// The mark definitions used to render the Portable Text content. The keys are the mark type names
  /// used in the Portable Text content. The default mark definitions are based on the Material Design typography guidelines.
  /// You can customize the rendering of each mark type by providing a custom mark definition descriptor. The mark definitions
  /// are used to apply styles and gestures to the text spans. Make sure to keep the mark names in sync with the ones used in the
  /// schema for the Portable Text.
  final Map<String, MarkDefDescriptor> markDefs = {};

  /// The indentation used for list items. The default value is 16.
  double listIndent = 16;

  /// The padding used for list items. The default value is 8.
  EdgeInsets itemPadding = const EdgeInsets.only(bottom: 8);

  /// The base style used for rendering the Portable Text content. The default value is the bodyMedium style from the theme.
  TextStyle? Function(BuildContext) baseStyle =
      (context) => Theme.of(context).textTheme.bodyMedium;

  /// The shared instance of the PortableTextConfig. This instance is used by all [PortableText] widgets
  /// in the application. You can customize the configuration by calling the [apply] method.
  static final PortableTextConfig shared = PortableTextConfig._();

  PortableTextConfig._();

  /// Applies the custom configuration to the shared instance of the [PortableTextConfig].
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

  /// The default text styles used by the shared instance of [PortableTextConfig].
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

  /// The default block containers used by the shared instance of [PortableTextConfig].
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

  /// The default block widgets used by the shared instance of [PortableTextConfig].
  /// The default block is a single [PortableTextBlock], named as "block".
  static final Map<String, BlockWidgetBuilder> defaultBlocks = {
    'block': (final context, final item) => PortableTextBlock(
          model: item as TextBlockItem,
        ),
  };
}
