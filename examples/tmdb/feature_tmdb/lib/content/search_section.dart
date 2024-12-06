import 'package:feature_tmdb/ui/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content/content_builder.dart';

part 'search_section.g.dart';

enum SearchType {
  all,
  movies,
  series,
  people;

  String get title => switch (this) {
        SearchType.all => 'All',
        SearchType.movies => 'Movies',
        SearchType.series => 'Series',
        SearchType.people => 'People',
      };
}

@JsonSerializable()
final class SearchSection extends ContentItem {
  static const schemaName = 'tmdb.search';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Search Section',
    fromJson: SearchSection.fromJson,
  );

  final String loaderMessage;
  final String emptyMessage;
  final List<SearchType> searchTypes;
  final ContentItem? emptyView;

  SearchSection({
    this.loaderMessage = 'Loading...',
    this.emptyMessage = 'No results found',
    this.searchTypes = const [SearchType.movies],
    this.emptyView,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory SearchSection.fromJson(Map<String, dynamic> json) =>
      _$SearchSectionFromJson(json);
}

final class SearchSectionBuilder extends ContentBuilder {
  SearchSectionBuilder()
      : super(
          content: SearchSection.typeDescriptor,
          defaultLayout: SearchSectionLayout(),
          defaultLayoutDescriptor: SearchSectionLayout.typeDescriptor,
        );
}

@JsonSerializable()
final class SearchSectionLayout extends LayoutConfiguration<SearchSection> {
  static const schemaName = '${SearchSection.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Search Section Layout',
    fromJson: SearchSectionLayout.fromJson,
  );

  SearchSectionLayout() : super(schemaType: schemaName);

  factory SearchSectionLayout.fromJson(Map<String, dynamic> json) =>
      _$SearchSectionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, SearchSection content) {
    return SearchScreen(
      content: content,
    );
  }
}
