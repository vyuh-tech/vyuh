import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'portable_text.g.dart';

/// A content item that renders rich text content using the Portable Text format.
///
/// Portable Text supports:
/// * Basic text formatting (bold, italic, underline)
/// * Code blocks with syntax highlighting
/// * Lists (ordered and unordered)
/// * Custom blocks (cards, groups, dividers)
/// * Custom marks with interactive behavior
///
/// Example:
/// ```dart
/// final content = PortableTextContent(
///   blocks: [
///     TextBlockItem(children: [
///       Span(text: 'Italic Text, ', marks: ['em']),
///       Span(text: 'Bold Text, ', marks: ['strong']),
///     ]),
///     Card(title: 'Embedded Card'),
///     TextBlockItem(children: [
///       Span(text: 'Code: ', marks: ['code']),
///     ]),
///   ],
/// );
/// ```
@JsonSerializable()
class PortableTextContent extends ContentItem {
  static const schemaName = 'vyuh.portableText';
  static final typeDescriptor = TypeDescriptor(
      schemaType: schemaName,
      title: 'Portable Text',
      fromJson: PortableTextContent.fromJson,
      preview: () => PortableTextContent(
            blocks: [
              TextBlockItem(children: [
                Span(text: 'Italic Text, ', marks: ['em']),
                Span(text: 'Bold Text, ', marks: ['strong']),
                Span(
                    text: 'Bold, Italic, Underline Text',
                    marks: ['em', 'strong', 'underline']),
              ]),
              TextBlockItem(children: [
                Span(text: 'class SomeDartClass {}', marks: ['code']),
              ]),
            ],
          ));
  static final contentBuilder = _PortableTextContentBuilder();

  @JsonKey(defaultValue: [], fromJson: blockItemsFromJson)
  final List<PortableBlockItem>? blocks;

  PortableTextContent({
    this.blocks,
    super.layout,
    super.modifiers,
  }) : super(schemaType: PortableTextContent.schemaName) {
    final items = (blocks ?? <ContentItem>[]).whereType<ContentItem>();
    setParent(items);
    _setListItemIndexes(blocks ?? <PortableBlockItem>[]);
  }

  factory PortableTextContent.fromJson(Map<String, dynamic> json) =>
      _$PortableTextContentFromJson(json);

  static List<PortableBlockItem>? blockItemsFromJson(dynamic value) {
    if (value is! List) {
      return null;
    }

    return value
        .map((e) {
          final type = VyuhBinding.instance.content.provider.schemaType(e);
          final itemDescriptor = _PortableTextContentBuilder.blockMap[type];

          if (itemDescriptor == null) {
            return kDebugMode
                ? UnknownContentItem(
                    missingSchemaType: type,
                    jsonPayload: e,
                  )
                : null;
          }

          return itemDescriptor.type.fromJson(e);
        })
        .where((element) => element != null)
        .cast<PortableBlockItem>()
        .toList(growable: false);
  }

  static void _setListItemIndexes(final List<PortableBlockItem> items) {
    List<int> indexStack = [];
    int previousLevel = 0;

    for (var index = 0; index < items.length; index++) {
      final item = items[index];

      switch (item) {
        case TextBlockItem():
          if (item.listItem == null || item.listItem != ListItemType.number) {
            item.listItemIndex = null;
            continue;
          }

          // Initialize the list numbering when starting out fresh or
          // when there is a jump in level. When going back to previous level,
          // pop out the last index to restore previous numbering.
          if (item.level != null && item.level! > previousLevel) {
            indexStack.add(-1);
          } else if (item.level != null && item.level! < previousLevel) {
            indexStack.removeLast();
          }

          // Increment index for the current level
          indexStack[indexStack.length - 1]++;

          item.listItemIndex = indexStack.last;
          previousLevel = item.level!;
          break;

        default:
          continue;
      }
    }
  }
}

/// Descriptor for configuring block types that can be used within portable text.
///
/// Each block type needs:
/// * A type descriptor for serialization
/// * A builder function to render the block
///
/// Example:
/// ```dart
/// final cardBlock = BlockItemDescriptor(
///   type: Card.typeDescriptor,
///   builder: (context, content) =>
///     vyuh.content.buildContent(context, content as Card),
/// );
/// ```
final class BlockItemDescriptor {
  final TypeDescriptor<PortableBlockItem> type;
  final BlockWidgetBuilder builder;

  BlockItemDescriptor({
    required this.type,
    required this.builder,
  });
}

/// Descriptor for configuring portable text content type in the system.
///
/// Allows configuring:
/// * Custom block types (cards, groups, etc.)
/// * Custom mark definitions for interactive text
/// * Text style builders for different text styles
///
/// Example:
/// ```dart
/// final descriptor = PortableTextDescriptor(
///   blocks: [
///     BlockItemDescriptor(
///       type: Card.typeDescriptor,
///       builder: (context, content) =>
///         vyuh.content.buildContent(context, content as Card),
///     ),
///   ],
///   markDefs: [
///     MarkDefDescriptor(
///       schemaType: 'link',
///       fromJson: LinkMarkDef.fromJson,
///       styleBuilder: (context, def, style) =>
///         style.copyWith(color: Colors.blue),
///     ),
///   ],
///   textStyleBuilders: {
///     'h1': (context, style) =>
///       style.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
///   },
/// );
/// ```
class PortableTextDescriptor extends ContentDescriptor {
  final List<BlockItemDescriptor>? blocks;
  final List<MarkDefDescriptor>? markDefs;
  final Map<String, TextStyleBuilder>? textStyleBuilders;

  PortableTextDescriptor({
    this.blocks,
    this.markDefs,
    this.textStyleBuilders,
    super.layouts,
  }) : super(
            schemaType: PortableTextContent.schemaName, title: 'Portable Text');
}

final class _PortableTextContentBuilder
    extends ContentBuilder<PortableTextContent> {
  static Map<String, BlockItemDescriptor> blockMap = {};

  _PortableTextContentBuilder()
      : super(
          content: PortableTextContent.typeDescriptor,
          defaultLayout: DefaultPortableTextContentLayout(),
          defaultLayoutDescriptor:
              DefaultPortableTextContentLayout.typeDescriptor,
        );

  @override
  void init(List<ContentDescriptor> descriptors) {
    super.init(descriptors);

    final pDescriptors = descriptors.cast<PortableTextDescriptor>();

    // Blocks
    pDescriptors
        .expand((element) => element.blocks ?? <BlockItemDescriptor>[])
        .fold(blockMap, (previous, descriptor) {
      previous[descriptor.type.schemaType] = descriptor;
      return previous;
    });

    for (final entry in blockMap.entries) {
      PortableTextConfig.shared.blocks[entry.key] = entry.value.builder;
    }

    // MarkDefs
    final markDefs = pDescriptors
        .expand((element) => element.markDefs ?? <MarkDefDescriptor>[])
        .map((e) => MapEntry(e.schemaType, e));

    PortableTextConfig.shared.markDefs.addEntries(markDefs);

    // Styles
    pDescriptors.fold(PortableTextConfig.shared.styles, (previous, element) {
      previous.addAll(element.textStyleBuilders ?? {});
      return previous;
    });
  }
}

/// Default layout for portable text content.
///
/// Features:
/// * Renders blocks in a vertical flow
/// * Adds padding when used directly in a route
/// * Supports all portable text block types
///
/// Example:
/// ```dart
/// final layout = DefaultPortableTextContentLayout();
/// ```
@JsonSerializable()
class DefaultPortableTextContentLayout
    extends LayoutConfiguration<PortableTextContent> {
  static const schemaName = '${PortableTextContent.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Portable Text Layout',
    fromJson: DefaultPortableTextContentLayout.fromJson,
    preview: () => DefaultPortableTextContentLayout(),
  );

  DefaultPortableTextContentLayout() : super(schemaType: schemaName);

  factory DefaultPortableTextContentLayout.fromJson(
          Map<String, dynamic> json) =>
      _$DefaultPortableTextContentLayoutFromJson(json);

  @override
  Widget build(BuildContext context, PortableTextContent content) {
    final child = PortableText(blocks: content.blocks ?? <PortableBlockItem>[]);

    if (content.parent is vc.RouteBase) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      );
    }

    return child;
  }
}
