// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      title: json['title'] as String?,
      description: json['description'] as String?,
      items: Document.itemsList(json['items']),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

DocumentDefaultLayout _$DocumentDefaultLayoutFromJson(
        Map<String, dynamic> json) =>
    DocumentDefaultLayout(
      mode: $enumDecodeNullable(_$DocumentRenderModeEnumMap, json['mode']) ??
          DocumentRenderMode.single,
    );

const _$DocumentRenderModeEnumMap = {
  DocumentRenderMode.single: 'single',
  DocumentRenderMode.list: 'list',
};
