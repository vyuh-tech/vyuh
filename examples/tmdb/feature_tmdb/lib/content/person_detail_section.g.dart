// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_detail_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonDetailSectionLayout _$PersonDetailSectionLayoutFromJson(
        Map<String, dynamic> json) =>
    PersonDetailSectionLayout();

PersonDetailSection _$PersonDetailSectionFromJson(Map<String, dynamic> json) =>
    PersonDetailSection(
      type: $enumDecode(_$PersonDetailSectionTypeEnumMap, json['type']),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

const _$PersonDetailSectionTypeEnumMap = {
  PersonDetailSectionType.hero: 'hero',
  PersonDetailSectionType.personalInfo: 'personalInfo',
  PersonDetailSectionType.biography: 'biography',
  PersonDetailSectionType.movieCredits: 'movieCredits',
  PersonDetailSectionType.tvCredits: 'tvCredits',
};
