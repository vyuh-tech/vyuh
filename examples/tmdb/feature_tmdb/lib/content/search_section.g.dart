// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchSection _$SearchSectionFromJson(Map<String, dynamic> json) =>
    SearchSection(
      loaderMessage: json['loaderMessage'] as String? ?? 'Loading...',
      emptyMessage: json['emptyMessage'] as String? ?? 'No results found',
      searchTypes: (json['searchTypes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$SearchTypeEnumMap, e))
              .toList() ??
          const [SearchType.movies],
      emptyView: json['emptyView'] == null
          ? null
          : ContentItem.fromJson(json['emptyView'] as Map<String, dynamic>),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

const _$SearchTypeEnumMap = {
  SearchType.all: 'all',
  SearchType.movies: 'movies',
  SearchType.series: 'series',
  SearchType.people: 'people',
};

SearchSectionLayout _$SearchSectionLayoutFromJson(Map<String, dynamic> json) =>
    SearchSectionLayout();
