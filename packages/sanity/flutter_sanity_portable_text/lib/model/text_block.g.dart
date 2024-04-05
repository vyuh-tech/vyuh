// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextBlockItem _$TextBlockItemFromJson(Map<String, dynamic> json) =>
    TextBlockItem(
      key: json['_key'] as String?,
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => Span.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Span>[],
      style: json['style'] as String? ?? 'normal',
      markDefs: json['markDefs'] == null
          ? const <MarkDef>[]
          : _markDefsFromJson(json['markDefs'] as List),
      listItem: $enumDecodeNullable(_$ListItemTypeEnumMap, json['listItem']),
      level: json['level'] as int?,
      listItemIndex: json['listItemIndex'] as int?,
    );

const _$ListItemTypeEnumMap = {
  ListItemType.bullet: 'bullet',
  ListItemType.square: 'square',
  ListItemType.number: 'number',
};

Span _$SpanFromJson(Map<String, dynamic> json) => Span(
      type: json['_type'] as String? ?? Span.schemaName,
      text: json['text'] as String? ?? '',
      marks:
          (json['marks'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
    );
