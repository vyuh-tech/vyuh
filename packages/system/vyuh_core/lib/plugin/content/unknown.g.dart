// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unknown.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Unknown _$UnknownFromJson(Map<String, dynamic> json) => Unknown(
      missingSchemaType: json['missingSchemaType'] as String,
      description: json['description'] as String,
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
