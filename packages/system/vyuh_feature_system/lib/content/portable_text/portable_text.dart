import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'portable_text.g.dart';

@JsonSerializable()
class PortableTextContent extends ContentItem {
  static const schemaName = 'vyuh.portableText';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Portable Text',
    fromJson: PortableTextContent.fromJson,
  );
  static final contentBuilder = _PortableTextContentBuilder();

  @JsonKey(defaultValue: [], fromJson: blockItemsFromJson)
  final List<PortableBlockItem>? blocks;

  PortableTextContent({
    this.blocks,
    super.layout,
    super.modifiers,
  }) : super(schemaType: PortableTextContent.schemaName) {
    final items = (blocks ?? []).whereType<ContentItem>();
    setParent(items);
    _setListItemIndexes(blocks ?? []);
  }

  factory PortableTextContent.fromJson(Map<String, dynamic> json) =>
      _$PortableTextContentFromJson(json);

  static List<PortableBlockItem>? blockItemsFromJson(dynamic value) {
    if (value is! List) {
      return null;
    }

    return value
        .map((e) {
          final type = vyuh.content.provider.schemaType(e);
          final itemDescriptor = _PortableTextContentBuilder.blockMap[type];

          if (itemDescriptor == null) {
            return kDebugMode
                ? Unknown(
                    missingSchemaType: type,
                    description:
                        'An $TypeDescriptor for this block-type has not been specified. Make sure to add that in your $PortableTextDescriptor.')
                : null;
          }

          return itemDescriptor.fromJson(e);
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

final class BlockItemDescriptor extends TypeDescriptor<PortableBlockItem> {
  final BlockWidgetBuilder builder;

  BlockItemDescriptor({
    required super.schemaType,
    required super.fromJson,
    required this.builder,
  }) : super(title: 'Block Item');
}

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
    pDescriptors.expand((element) => element.blocks ?? []).fold(blockMap,
        (previous, descriptor) {
      previous[descriptor.schemaType] = descriptor;
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

@JsonSerializable()
class DefaultPortableTextContentLayout
    extends LayoutConfiguration<PortableTextContent> {
  static const schemaName = '${PortableTextContent.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Portable Text Layout',
    fromJson: DefaultPortableTextContentLayout.fromJson,
  );

  DefaultPortableTextContentLayout() : super(schemaType: schemaName);

  factory DefaultPortableTextContentLayout.fromJson(
          Map<String, dynamic> json) =>
      _$DefaultPortableTextContentLayoutFromJson(json);

  @override
  Widget build(BuildContext context, PortableTextContent content) {
    final child = PortableText(blocks: content.blocks ?? []);

    if (content.parent is vc.RouteBase) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      );
    }

    return child;
  }
}
