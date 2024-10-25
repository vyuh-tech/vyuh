// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WonderSectionConfiguration _$WonderSectionConfigurationFromJson(
        Map<String, dynamic> json) =>
    WonderSectionConfiguration(
      title: json['title'] as String?,
      type: $enumDecodeNullable(_$WonderSectionTypeEnumMap, json['type']) ??
          WonderSectionType.hero,
    );

const _$WonderSectionTypeEnumMap = {
  WonderSectionType.hero: 'hero',
  WonderSectionType.history: 'history',
  WonderSectionType.construction: 'construction',
  WonderSectionType.locationInfo: 'locationInfo',
  WonderSectionType.events: 'events',
  WonderSectionType.photos: 'photos',
};
