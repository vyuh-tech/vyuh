// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditionSponsor _$EditionSponsorFromJson(Map<String, dynamic> json) =>
    EditionSponsor(
      sponsor: json['sponsor'] == null
          ? null
          : Sponsor.fromJson(json['sponsor'] as Map<String, dynamic>),
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
      slug: json['slug'] as String,
      title: json['title'] as String,
      tagline: json['tagline'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      conference:
          ObjectReference.fromJson(json['conference'] as Map<String, dynamic>),
      venue: json['venue'] == null
          ? null
          : Venue.fromJson(json['venue'] as Map<String, dynamic>),
      sponsors: (json['sponsors'] as List<dynamic>?)
          ?.map((e) => EditionSponsor.fromJson(e as Map<String, dynamic>))
          .toList(),
      url: json['url'] as String?,
      logo: json['logo'] == null
          ? null
          : ImageReference.fromJson(json['logo'] as Map<String, dynamic>),
      schedule: (json['schedule'] as List<dynamic>?)
          ?.map((e) => ScheduleDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
