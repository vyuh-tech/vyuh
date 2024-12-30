// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditionSponsor _$EditionSponsorFromJson(Map<String, dynamic> json) =>
    EditionSponsor(
      sponsor: json['sponsor'] == null
          ? null
          : ObjectReference.fromJson(json['sponsor'] as Map<String, dynamic>),
      level: $enumDecodeNullable(_$SponsorLevelEnumMap, json['level']) ??
          SponsorLevel.bronze,
    );

const _$SponsorLevelEnumMap = {
  SponsorLevel.platinum: 'platinum',
  SponsorLevel.gold: 'gold',
  SponsorLevel.silver: 'silver',
  SponsorLevel.bronze: 'bronze',
};

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
      sponsors: (json['sponsors'] as List<dynamic>?)
          ?.map((e) => EditionSponsor.fromJson(e as Map<String, dynamic>))
          .toList(),
      url: json['url'] as String?,
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
