import 'package:chakra_shared/chakra_shared.dart';
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/content/movie_detail_section.dart';
import 'package:feature_tmdb/content/series_detail_section.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/collection_view.dart';
import 'package:feature_tmdb/ui/sections/movie_card.dart';
import 'package:feature_tmdb/ui/sections/series_card.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/runtime/platform/vyuh_platform.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class FeaturedPreviewListSection extends StatelessWidget {
  final BrowseMode mode;

  final int? id;

  final String Function(int) cacheKey;

  final String? title;
  final MovieDetailSectionType? movieType;
  final MediaCardType mediaCardType;
  final SeriesDetailSectionType? seriesType;
  final ListRepresentation representation;
  final ObservableFuture? Function() futureBuilder;

  const FeaturedPreviewListSection({
    super.key,
    required this.mode,
    this.id,
    this.title,
    this.movieType,
    this.seriesType,
    required this.cacheKey,
    required this.futureBuilder,
    this.representation = ListRepresentation.short,
    this.mediaCardType = MediaCardType.home,
  }) : assert(
          movieType != null ||
              seriesType != null ||
              movieType == null && seriesType == null,
        );

  @override
  Widget build(BuildContext context) {
    final id = this.id ?? mode.selectedId(context);
    if (id == null) {
      return empty;
    }
    return DetailBuilder<ListResponse<ShortInfo>>(
      futureBuilder: futureBuilder,
      builder: (context, data) {
        if (data is ListResponse<MovieShortInfo> ||
            data is ListResponse<SeriesShortInfo>) {
          return CollectionView(
            items: data.results,
            itemBuilder: (context, item) {
              return mode == BrowseMode.movies
                  ? representation == ListRepresentation.short
                      ? MovieCard(
                          movie: item as MovieShortInfo,
                          mediaCardType: mediaCardType,
                        )
                      : MovieCard.large(
                          movie: item as MovieShortInfo,
                        )
                  : representation == ListRepresentation.short
                      ? SeriesCard(
                          series: item as SeriesShortInfo,
                          mediaCardType: mediaCardType,
                        )
                      : SeriesCard.large(series: item as SeriesShortInfo);
            },
            onViewAllTap: mediaCardType == MediaCardType.recommendation
                ? () => mode == BrowseMode.movies
                    ? vyuh.router.push(TmdbPath.movieRecommendationList(id))
                    : vyuh.router.push(TmdbPath.seriesRecommendationList(id))
                : null,
            title: title ?? 'More Like This',
            mediaCardType: mediaCardType,
            variant: representation,
          );
        }
        return empty;
      },
    );
  }
}
