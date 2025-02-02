// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(
      title: json['title'] as String?,
      description: json['description'] as String?,
      item: typeFromFirstOfListJson(json['item']),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

DocumentDefaultLayout _$DocumentDefaultLayoutFromJson(
        Map<String, dynamic> json) =>
    DocumentDefaultLayout();
