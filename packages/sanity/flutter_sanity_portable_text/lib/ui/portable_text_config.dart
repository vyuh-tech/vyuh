import 'package:flutter/material.dart';

import '../flutter_sanity_portable_text.dart';

/// A function that builds a text style for a Portable Text block or span.
typedef TextStyleBuilder = TextStyle Function(
  BuildContext context,
  TextStyle base,
);

/// A function that builds a widget for a Portable block container.
typedef BlockContainerBuilder = Widget Function(BuildContext, Widget);

/// A function that builds a widget for a Portable block item.
typedef BlockWidgetBuilder = Widget Function(
  BuildContext context,
  PortableBlockItem item,
);

/// A function that builds an InlineSpan for a single bullet mark. Using the
/// [TextBlockItem]'s listItem, listItemIndex and level, the bullet can be customized as needed.
typedef BulletRenderer = InlineSpan Function(BuildContext, TextBlockItem);

/// The configuration used for rendering Portable Text. This class is used to
/// define the visual representation of the Portable Text blocks, spans, and marks. It
/// is used by the [PortableText] widget to render the Portable Text content. The
/// configuration can be customized to match the visual design of the app. The default
/// configuration is based on the Material Design guidelines.
///
/// A single global default lives in [shared]; individual subtrees can override the rendering
/// configuration by wrapping them in a [PortableTextTheme] (resolved via [of]).
final class PortableTextConfig {
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
  double listIndent = defaultListIndent;

  /// The padding used for list items. The default value is 8.
  EdgeInsets itemPadding = defaultItemPadding;

  /// The base style used for rendering the Portable Text content. The default value is the bodyMedium style from the theme.
  TextStyle? Function(BuildContext) baseStyle = defaultBaseStyle;

  /// The default/root configuration, used by [PortableText] widgets when no [PortableTextTheme]
  /// ancestor provides one (see [of]). It is also the context-free registry consulted at
  /// JSON-parse time for custom mark deserializers (see `_markDefsFromJson`). You can customize
  /// it by calling the [apply] method.
  static final PortableTextConfig shared = PortableTextConfig();

  /// The bullet renderer used to render the bullet for list items. The default value is a simple bullet renderer
  /// that handles the default bullet types: number, square, and circle.
  BulletRenderer bulletRenderer = defaultBulletRenderer;

  PortableTextConfig();

  /// Returns the nearest [PortableTextConfig] supplied by a [PortableTextTheme] ancestor,
  /// falling back to [shared] when none is present. Mirrors `Theme.of`.
  static PortableTextConfig of(final BuildContext context) =>
      PortableTextTheme.maybeOf(context) ?? shared;

  /// Returns a copy of this config with the given fields overridden.
  ///
  /// The map fields ([styles], [blocks], [blockContainers], [markDefs]) are MERGED — provided
  /// keys win, the rest are kept — and scalar fields are replaced when provided. This
  /// intentionally differs from `ThemeData.copyWith` (which replaces whole fields) because
  /// these maps are additive registries, so the common case is overriding a single key while
  /// keeping the others.
  ///
  /// Note: overriding [markDefs] here affects mark *rendering/styling* only. It does not change
  /// which custom deserializer runs at JSON-parse time — that always reads the context-free
  /// [shared] registry (see `_markDefsFromJson`).
  PortableTextConfig copyWith({
    final Map<String, TextStyleBuilder>? styles,
    final Map<String, BlockWidgetBuilder>? blocks,
    final Map<String, BlockContainerBuilder>? blockContainers,
    final Map<String, MarkDefDescriptor>? markDefs,
    final double? listIndent,
    final EdgeInsets? itemPadding,
    final TextStyle? Function(BuildContext)? baseStyle,
    final BulletRenderer? bulletRenderer,
  }) {
    final config = PortableTextConfig();
    config.styles
      ..clear()
      ..addAll(this.styles);
    config.blocks
      ..clear()
      ..addAll(this.blocks);
    config.blockContainers
      ..clear()
      ..addAll(this.blockContainers);
    config.markDefs
      ..clear()
      ..addAll(this.markDefs);
    config.listIndent = this.listIndent;
    config.itemPadding = this.itemPadding;
    config.baseStyle = this.baseStyle;
    config.bulletRenderer = this.bulletRenderer;

    if (styles != null) config.styles.addAll(styles);
    if (blocks != null) config.blocks.addAll(blocks);
    if (blockContainers != null) config.blockContainers.addAll(blockContainers);
    if (markDefs != null) config.markDefs.addAll(markDefs);
    if (listIndent != null) config.listIndent = listIndent;
    if (itemPadding != null) config.itemPadding = itemPadding;
    if (baseStyle != null) config.baseStyle = baseStyle;
    if (bulletRenderer != null) config.bulletRenderer = bulletRenderer;
    return config;
  }

  /// Applies the custom configuration to the shared instance of the [PortableTextConfig].
  void apply({
    final double listIndent = defaultListIndent,
    final EdgeInsets itemPadding = defaultItemPadding,
    final BulletRenderer? bulletRenderer,
    final Map<String, TextStyleBuilder>? styles,
    final Map<String, BlockContainerBuilder>? blockContainers,
    final Map<String, BlockWidgetBuilder>? blocks,
    final Map<String, MarkDefDescriptor>? markDefs,
    final TextStyle? Function(BuildContext)? baseStyle,
  }) {
    this.listIndent = listIndent;
    this.bulletRenderer = bulletRenderer ?? defaultBulletRenderer;
    this.itemPadding = itemPadding;
    this.styles.addAll(styles ?? {});
    this.blockContainers.addAll(blockContainers ?? {});
    this.markDefs.addAll(markDefs ?? {});
    this.blocks.addAll(blocks ?? {});
    this.baseStyle = baseStyle ?? defaultBaseStyle;
  }

  /// Builds a block widget for the given Portable block item.
  /// The block widget is determined by the block type of the item. If the block type is not found in the
  /// block widgets, an error view is rendered with a message indicating the missing block type.
  Widget buildBlock(final BuildContext context, final PortableBlockItem item) {
    final type = item.blockType;

    final builder = blocks[type];
    if (builder == null) {
      return ErrorView(message: 'Missing builder for block "$type"');
    }

    return builder(context, item);
  }

  /// Resets the shared instance of the [PortableTextConfig] to the default configuration.
  void reset() {
    listIndent = defaultListIndent;
    bulletRenderer = defaultBulletRenderer;
    itemPadding = defaultItemPadding;
    baseStyle = defaultBaseStyle;

    styles
      ..clear()
      ..addAll(defaultStyles);
    blockContainers
      ..clear()
      ..addAll(defaultBlockContainers);
    markDefs.clear();
    blocks
      ..clear()
      ..addAll(defaultBlocks);
  }

  static const defaultListIndent = 16.0;
  static const defaultItemPadding = EdgeInsets.only(bottom: 8);
  static BulletRenderer defaultBulletRenderer =
      (final BuildContext context, final TextBlockItem model) {
    final textStyle = PortableTextConfig.of(context).baseStyle(context);

    switch (model.listItem) {
      case ListItemType.number:
        return TextSpan(
          text: '${(model.listItemIndex ?? 0) + 1}.  ',
          style: textStyle,
        );

      case ListItemType.square:
        return WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.check_box_outline_blank, size: 8),
          ),
          style: textStyle,
        );

      default:
        return WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.circle, size: 8),
          ),
          style: textStyle,
        );
    }
  };

  static TextStyle? defaultBaseStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static BlockContainerBuilder defaultBlockContainerBuilder =
      (final BuildContext context, final Widget child) {
    return child;
  };

  /// The default text styles used by the shared instance of [PortableTextConfig].
  static final Map<String, TextStyleBuilder> defaultStyles = {
    'h1': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.merge(Theme.of(context).textTheme.headlineLarge),
    'h2': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.merge(Theme.of(context).textTheme.headlineMedium),
    'h3': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.merge(Theme.of(context).textTheme.headlineSmall),
    'h4': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.merge(Theme.of(context).textTheme.titleLarge),
    'h5': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.merge(Theme.of(context).textTheme.titleMedium),
    'h6': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.merge(Theme.of(context).textTheme.titleSmall),
    'blockquote': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.copyWith(color: Theme.of(context).colorScheme.primary),
    'normal': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.merge(Theme.of(context).textTheme.bodyMedium),
    'em': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.copyWith(fontStyle: FontStyle.italic),
    'strong': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.copyWith(fontWeight: FontWeight.bold),
    'code': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.copyWith(
          fontFamily: 'monospace',
          fontFamilyFallback: ['Courier New'],
          fontWeight: FontWeight.bold,
        ),
    'strike-through': (
      final BuildContext context,
      final TextStyle base, [
      final MarkDef? mark,
    ]) =>
        base.copyWith(
          decoration: TextDecoration.combine([
            if (base.decoration != null) base.decoration!,
            TextDecoration.lineThrough
          ]),
        ),
    'underline': (
      final BuildContext context,
      final TextStyle base, [
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
    'blockquote': (final BuildContext context, final Widget child) {
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

/// Renders an error message when a block type is missing a builder or when a mark is misconfigured.
class ErrorView extends StatelessWidget {
  final String message;
  final bool asBlock;

  const ErrorView({
    super.key,
    required this.message,
    this.asBlock = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
        color: theme.colorScheme.onErrorContainer,
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: asBlock ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium
                    ?.apply(color: theme.colorScheme.errorContainer),
              ),
            ),
          ],
        ));
  }
}
