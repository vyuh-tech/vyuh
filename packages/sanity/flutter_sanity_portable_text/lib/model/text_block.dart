import 'package:json_annotation/json_annotation.dart';

import '../flutter_sanity_portable_text.dart';

part 'text_block.g.dart';

abstract interface class PortableBlockItem {
  String get blockType;
}

enum ListItemType { bullet, square, number }

@JsonSerializable()
@MarkDefsConverter()
class TextBlockItem implements PortableBlockItem {
  static const schemaName = 'block';

  @override
  String get blockType => schemaName;

  @JsonKey(name: '_key')
  final String key;

  @JsonKey(defaultValue: [])
  final List<Span> children;

  @JsonKey(defaultValue: [])
  final List<MarkDef> markDefs;

  @JsonKey(defaultValue: 'normal')
  final String style;

  final ListItemType? listItem;
  final int? level;
  int? listItemIndex;

  TextBlockItem({
    required this.key,
    required this.children,
    required this.style,
    required this.markDefs,
    this.listItem,
    this.level,
  });

  factory TextBlockItem.fromJson(final Map<String, dynamic> json) =>
      _$TextBlockItemFromJson(json);
}

@JsonSerializable()
class Span {
  @JsonKey(name: '_type')
  final String type;

  @JsonKey(defaultValue: '')
  final String text;

  @JsonKey(defaultValue: [])
  final List<String> marks;

  Span({required this.type, required this.text, required this.marks});

  factory Span.fromJson(final Map<String, dynamic> json) =>
      _$SpanFromJson(json);
}
