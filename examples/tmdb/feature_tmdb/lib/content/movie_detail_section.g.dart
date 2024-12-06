// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailSection _$MovieDetailSectionFromJson(Map<String, dynamic> json) =>
    MovieDetailSection(
      type:
          $enumDecodeNullable(_$MovieDetailSectionTypeEnumMap, json['type']) ??
              MovieDetailSectionType.hero,
      representation: $enumDecodeNullable(
              _$ListRepresentationEnumMap, json['representation']) ??
          ListRepresentation.short,
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

const _$MovieDetailSectionTypeEnumMap = {
  MovieDetailSectionType.hero: 'hero',
  MovieDetailSectionType.cast: 'cast',
  MovieDetailSectionType.crew: 'crew',
  MovieDetailSectionType.statistics: 'statistics',
  MovieDetailSectionType.gallery: 'gallery',
  MovieDetailSectionType.recommendations: 'recommendations',
  MovieDetailSectionType.reviews: 'reviews',
  MovieDetailSectionType.footer: 'footer',
  MovieDetailSectionType.trailer: 'trailer',
};

const _$ListRepresentationEnumMap = {
  ListRepresentation.short: 'short',
  ListRepresentation.long: 'long',
};

MovieDetailSectionLayout _$MovieDetailSectionLayoutFromJson(
        Map<String, dynamic> json) =>
    MovieDetailSectionLayout();
