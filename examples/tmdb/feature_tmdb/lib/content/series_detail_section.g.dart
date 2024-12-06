// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_detail_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesDetailSectionLayout _$SeriesDetailSectionLayoutFromJson(
        Map<String, dynamic> json) =>
    SeriesDetailSectionLayout();

SeriesDetailSection _$SeriesDetailSectionFromJson(Map<String, dynamic> json) =>
    SeriesDetailSection(
      type:
          $enumDecodeNullable(_$SeriesDetailSectionTypeEnumMap, json['type']) ??
              SeriesDetailSectionType.hero,
      representation: $enumDecodeNullable(
              _$ListRepresentationEnumMap, json['representation']) ??
          ListRepresentation.short,
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

const _$SeriesDetailSectionTypeEnumMap = {
  SeriesDetailSectionType.hero: 'hero',
  SeriesDetailSectionType.cast: 'cast',
  SeriesDetailSectionType.crew: 'crew',
  SeriesDetailSectionType.statistics: 'statistics',
  SeriesDetailSectionType.gallery: 'gallery',
  SeriesDetailSectionType.recommendations: 'recommendations',
  SeriesDetailSectionType.reviews: 'reviews',
  SeriesDetailSectionType.footer: 'footer',
  SeriesDetailSectionType.trailer: 'trailer',
};

const _$ListRepresentationEnumMap = {
  ListRepresentation.short: 'short',
  ListRepresentation.long: 'long',
};
