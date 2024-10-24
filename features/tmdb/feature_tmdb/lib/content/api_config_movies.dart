import 'package:design_system/design_system.dart';
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/collection_view.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:feature_tmdb/ui/sections/movie_card.dart';
import 'package:feature_tmdb/ui/widget/carousel_widget.dart';
import 'package:feature_tmdb/ui/widget/circular_carousel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'api_config_movies.g.dart';

@JsonSerializable()
final class ApiMovieConfigsSection
    extends ApiConfiguration<List<MovieShortInfo>> {
  static const schemaName = 'tmdb.movie.configsSection';

  final MovieListType resourceType;
  final ConfigsSectionType type;
  final ListRepresentation representation;
  final int itemCount;
  final bool showIndicator;

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'API Configuration (Movies)',
    fromJson: ApiMovieConfigsSection.fromJson,
  );

  ApiMovieConfigsSection({
    required this.resourceType,
    this.type = ConfigsSectionType.carousel,
    required this.itemCount,
    required this.showIndicator,
    this.representation = ListRepresentation.short,
  }) : super(schemaType: schemaName);

  factory ApiMovieConfigsSection.fromJson(Map<String, dynamic> json) =>
      _$ApiMovieConfigsSectionFromJson(json);

  @override
  Widget build(
    BuildContext context,
    List<MovieShortInfo>? data,
  ) {
    MovieListType? resourceType = _getResourceType(context);
    final theme = Theme.of(context);

    switch (type) {
      case ConfigsSectionType.carousel:
        return CircularCarousel(
          itemCount: data?.limited(itemCount).length ?? 0,
          itemBuilder: (context, index) {
            final movie = data![index];
            return CarouselWidget(
              id: movie.id,
              posterImage: movie.posterImage ?? '',
              title: movie.title,
              voteAverage: movie.voteAverage,
            );
          },
          indicatorType: showIndicator
              ? CarouselIndicatorType.stacked
              : CarouselIndicatorType.none,
          aspectRatio: theme.aspectRatio.sixteenToNine,
        );
      case ConfigsSectionType.listType:
        if (resourceType == null) {
          return empty;
        }

        return CollectionView<MovieShortInfo>(
          items: data ?? [],
          itemBuilder: (context, item) =>
              representation == ListRepresentation.short
                  ? MovieCard(
                      movie: item,
                    )
                  : MovieCard.large(
                      movie: item,
                    ),
          title: resourceType.title,
          variant: representation,
          onViewAllTap: () {
            vyuh.router.push(TmdbPath.movieList(resourceType));
          },
        );
    }
  }

  @override
  Future<List<MovieShortInfo>?> invoke(
    BuildContext context,
  ) async {
    switch (type) {
      case ConfigsSectionType.carousel:
        final data =
            await vyuh.di.get<TMDBStore>().fetchMovieList(resourceType);
        return data.results;
      case ConfigsSectionType.listType:
        MovieListType? resType = _getResourceType(context);

        if (resType == null) {
          return null;
        }

        final genreId = GoRouterState.of(context).genreId();

        final data = await vyuh.di
            .get<TMDBStore>()
            .fetchMovieList(resType, genreId: genreId);
        return data.results;
    }
  }

  _getResourceType(BuildContext context) {
    MovieListType? type = resourceType;
    if (resourceType == MovieListType.bySelectedList) {
      type = GoRouterState.of(context).movieListType();
    }

    return type;
  }
}
