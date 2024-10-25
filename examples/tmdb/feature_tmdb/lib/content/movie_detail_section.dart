import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/collection_view.dart';
import 'package:feature_tmdb/ui/sections/footer.dart';
import 'package:feature_tmdb/ui/sections/gallery.dart';
import 'package:feature_tmdb/ui/sections/hero.dart';
import 'package:feature_tmdb/ui/sections/people_card.dart';
import 'package:feature_tmdb/ui/sections/preview_list.dart';
import 'package:feature_tmdb/ui/sections/review_card.dart';
import 'package:feature_tmdb/ui/sections/statistics.dart';
import 'package:feature_tmdb/ui/sections/trailer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'movie_detail_section.g.dart';

final class MovieDetailSectionBuilder extends ContentBuilder {
  MovieDetailSectionBuilder()
      : super(
          content: MovieDetailSection.typeDescriptor,
          defaultLayout: MovieDetailSectionLayout(),
          defaultLayoutDescriptor: MovieDetailSectionLayout.typeDescriptor,
        );
}

@JsonSerializable()
final class MovieDetailSectionLayout
    extends LayoutConfiguration<MovieDetailSection> {
  static const schemaName = '${MovieDetailSection.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Movie Detail Section Layout',
    fromJson: MovieDetailSectionLayout.fromJson,
  );

  MovieDetailSectionLayout() : super(schemaType: schemaName);

  factory MovieDetailSectionLayout.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailSectionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, MovieDetailSection content) {
    switch (content.type) {
      case MovieDetailSectionType.hero:
        return const HeroSection(mode: BrowseMode.movies);
      case MovieDetailSectionType.statistics:
        return const StatisticsSection(mode: BrowseMode.movies);
      case MovieDetailSectionType.cast:
        return PeopleSectionView(
          mode: BrowseMode.movies,
          representation: content.representation,
          isCast: true,
        );
      case MovieDetailSectionType.crew:
        return PeopleSectionView.crew(
          mode: BrowseMode.movies,
          representation: content.representation,
          isCast: false,
        );
      case MovieDetailSectionType.gallery:
        return const GallerySection(mode: BrowseMode.movies);
      case MovieDetailSectionType.recommendations:
        final store = vyuh.di.get<TMDBStore>();
        final movieId = GoRouterState.of(context).movieId();

        if (movieId == null) {
          return empty;
        }

        return FeaturedPreviewListSection(
          mode: BrowseMode.movies,
          movieType: MovieDetailSectionType.recommendations,
          mediaCardType: MediaCardType.recommendation,
          representation: content.representation,
          cacheKey: (id) => '$id.movie.recommendations',
          futureBuilder: () {
            store.selectMovie(movieId);
            return store.getFuture('$movieId.movie.recommendations');
          },
        );
      case MovieDetailSectionType.reviews:
        return ReviewSection(
          mode: BrowseMode.movies,
          representation: content.representation,
        );
      case MovieDetailSectionType.footer:
        return const FooterSection(mode: BrowseMode.movies);
      case MovieDetailSectionType.trailer:
        return const TrailersSection(mode: BrowseMode.movies);
    }
  }
}

@JsonSerializable()
final class MovieDetailSection extends ContentItem {
  static const schemaName = 'tmdb.movie.detailSection';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Movie Detail Section',
    fromJson: MovieDetailSection.fromJson,
  );

  final MovieDetailSectionType type;
  final ListRepresentation representation;

  MovieDetailSection({
    this.type = MovieDetailSectionType.hero,
    this.representation = ListRepresentation.short,
    super.layout,
  }) : super(schemaType: schemaName);

  factory MovieDetailSection.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailSectionFromJson(json);
}

enum MovieDetailSectionType {
  hero,
  cast,
  crew,
  statistics,
  gallery,
  recommendations,
  reviews,
  footer,
  trailer,
}
