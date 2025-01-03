// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conference _$ConferenceFromJson(Map<String, dynamic> json) => Conference(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] == null
          ? null
          : PortableTextContent.fromJson(
              json['description'] as Map<String, dynamic>),
      slug: json['slug'] as String,
      logo: json['logo'] == null
          ? null
          : ImageReference.fromJson(json['logo'] as Map<String, dynamic>),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
