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
      format: $enumDecodeNullable(_$SessionFormatEnumMap, json['format']) ??
          SessionFormat.talk,
      level: $enumDecodeNullable(_$SessionLevelEnumMap, json['level']) ??
          SessionLevel.all,
      edition: json['edition'] == null
          ? null
          : ObjectReference.fromJson(json['edition'] as Map<String, dynamic>),
      speakers: (json['speakers'] as List<dynamic>?)
          ?.map((e) => Speaker.fromJson(e as Map<String, dynamic>))
          .toList(),
      tracks: (json['tracks'] as List<dynamic>?)
          ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

const _$SessionFormatEnumMap = {
  SessionFormat.intro: 'intro',
  SessionFormat.keynote: 'keynote',
  SessionFormat.talk: 'talk',
  SessionFormat.workshop: 'workshop',
  SessionFormat.panel: 'panel',
  SessionFormat.lightning: 'lightning',
  SessionFormat.breakout: 'breakout',
  SessionFormat.networking: 'networking',
  SessionFormat.outro: 'outro',
};

const _$SessionLevelEnumMap = {
  SessionLevel.beginner: 'beginner',
  SessionLevel.intermediate: 'intermediate',
  SessionLevel.advanced: 'advanced',
  SessionLevel.all: 'all',
};
