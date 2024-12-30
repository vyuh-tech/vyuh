// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      duration: (json['duration'] as num).toInt(),
      edition: Edition.fromJson(json['edition'] as Map<String, dynamic>),
      speakers: (json['speakers'] as List<dynamic>)
          .map((e) => Speaker.fromJson(e as Map<String, dynamic>))
          .toList(),
      tracks: (json['tracks'] as List<dynamic>)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
