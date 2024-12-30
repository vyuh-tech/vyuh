// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Edition _$EditionFromJson(Map<String, dynamic> json) => Edition(
      id: json['_id'] as String,
      identifier: json['identifier'] as String,
      title: json['title'] as String,
      tagline: json['tagline'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      location: json['location'] as String,
      conference:
          ObjectReference.fromJson(json['conference'] as Map<String, dynamic>),
      url: json['url'] as String?,
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
