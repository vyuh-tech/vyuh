// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portable_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortableTextContent _$PortableTextContentFromJson(Map<String, dynamic> json) =>
    PortableTextContent(
      blocks: json['blocks'] == null
          ? []
          : PortableTextContent.blockItemsFromJson(json['blocks']),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

DefaultPortableTextContentLayout _$DefaultPortableTextContentLayoutFromJson(
        Map<String, dynamic> json) =>
    DefaultPortableTextContentLayout();
