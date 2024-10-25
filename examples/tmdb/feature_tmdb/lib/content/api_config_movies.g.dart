// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_config_movies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiMovieConfigsSection _$ApiMovieConfigsSectionFromJson(
        Map<String, dynamic> json) =>
    ApiMovieConfigsSection(
      resourceType: $enumDecode(_$MovieListTypeEnumMap, json['resourceType']),
      type: $enumDecodeNullable(_$ConfigsSectionTypeEnumMap, json['type']) ??
          ConfigsSectionType.carousel,
      itemCount: (json['itemCount'] as num).toInt(),
      showIndicator: json['showIndicator'] as bool,
      representation: $enumDecodeNullable(
              _$ListRepresentationEnumMap, json['representation']) ??
          ListRepresentation.short,
    );

const _$MovieListTypeEnumMap = {
  MovieListType.popular: 'popular',
  MovieListType.upcoming: 'upcoming',
  MovieListType.topRated: 'topRated',
  MovieListType.nowPlaying: 'nowPlaying',
  MovieListType.trendingToday: 'trending.day',
  MovieListType.trendingThisWeek: 'trending.week',
  MovieListType.bySelectedGenre: 'bySelectedGenre',
  MovieListType.bySelectedList: 'bySelectedList',
};

const _$ConfigsSectionTypeEnumMap = {
  ConfigsSectionType.carousel: 'carousel',
  ConfigsSectionType.listType: 'listType',
};

const _$ListRepresentationEnumMap = {
  ListRepresentation.short: 'short',
  ListRepresentation.long: 'long',
};
