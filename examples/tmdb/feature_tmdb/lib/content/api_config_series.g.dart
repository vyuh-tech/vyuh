// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_config_series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiSeriesConfigsSection _$ApiSeriesConfigsSectionFromJson(
        Map<String, dynamic> json) =>
    ApiSeriesConfigsSection(
      resourceType: $enumDecode(_$SeriesListTypeEnumMap, json['resourceType']),
      type: $enumDecodeNullable(_$ConfigsSectionTypeEnumMap, json['type']) ??
          ConfigsSectionType.carousel,
      itemCount: (json['itemCount'] as num).toInt(),
      showIndicator: json['showIndicator'] as bool,
      representation: $enumDecodeNullable(
              _$ListRepresentationEnumMap, json['representation']) ??
          ListRepresentation.short,
    );

const _$SeriesListTypeEnumMap = {
  SeriesListType.airingToday: 'airingToday',
  SeriesListType.popular: 'popular',
  SeriesListType.topRated: 'topRated',
  SeriesListType.trendingToday: 'trending.day',
  SeriesListType.trendingThisWeek: 'trending.week',
  SeriesListType.bySelectedGenre: 'bySelectedGenre',
  SeriesListType.bySelectedList: 'bySelectedList',
};

const _$ConfigsSectionTypeEnumMap = {
  ConfigsSectionType.carousel: 'carousel',
  ConfigsSectionType.listType: 'listType',
};

const _$ListRepresentationEnumMap = {
  ListRepresentation.short: 'short',
  ListRepresentation.long: 'long',
};
