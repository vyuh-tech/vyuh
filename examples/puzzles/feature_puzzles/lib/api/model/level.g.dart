// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: json['_key'] as String?,
      title: json['title'] as String,
      canSail: json['canSail'] as bool? ?? true,
      image: json['image'] == null
          ? null
          : ImageReference.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      '_key': instance.id,
      'title': instance.title,
      'image': instance.image,
      'canSail': instance.canSail,
    };

KillCondition _$KillConditionFromJson(Map<String, dynamic> json) =>
    KillCondition(
      type: $enumDecode(_$KillTypeEnumMap, json['type']),
      witness: json['witness'] as String? ?? '',
      killer: json['killer'] as String,
      victim: json['victim'] as String,
    );

Map<String, dynamic> _$KillConditionToJson(KillCondition instance) =>
    <String, dynamic>{
      'type': _$KillTypeEnumMap[instance.type]!,
      'witness': instance.witness,
      'killer': instance.killer,
      'victim': instance.victim,
    };

const _$KillTypeEnumMap = {
  KillType.absent: 'absent',
  KillType.greater: 'greater',
  KillType.unknown: 'unknown',
};

Level _$LevelFromJson(Map<String, dynamic> json) => Level(
      title: json['title'] as String,
      duration: (json['duration'] as num?)?.toInt() ?? 99,
      image: json['image'] == null
          ? null
          : ImageReference.fromJson(json['image'] as Map<String, dynamic>),
      instructions: PortableTextContent.fromJson(
          json['instructions'] as Map<String, dynamic>),
      characters: (json['characters'] as List<dynamic>)
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
          .toList(),
      killConditions: (json['killConditions'] as List<dynamic>)
          .map((e) => KillCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      killWord: json['killWord'] as String,
    );

Map<String, dynamic> _$LevelToJson(Level instance) => <String, dynamic>{
      'title': instance.title,
      'duration': instance.duration,
      'image': instance.image,
      'instructions': instance.instructions,
      'characters': instance.characters,
      'killConditions': instance.killConditions,
      'killWord': instance.killWord,
    };
