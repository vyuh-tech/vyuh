import 'package:design_system/core/gap.dart';
import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/collection_view.dart';
import 'package:feature_tmdb/ui/date_and_details_widget.dart';
import 'package:feature_tmdb/ui/popularity_widget.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/model/movie.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class MovieCard extends StatelessWidget {
  final ListRepresentation representation;
  final MovieShortInfo movie;
  final double? width;
  final MediaCardType mediaCardType;

  const MovieCard({
    super.key,
    this.representation = ListRepresentation.short,
    required this.movie,
    this.width,
    this.mediaCardType = MediaCardType.home,
  });

  factory MovieCard.large({
    required MovieShortInfo movie,
  }) =>
      MovieCard(
        representation: ListRepresentation.long,
        movie: movie,
        width: double.infinity,
      );

  bool get isRecommendation => mediaCardType == MediaCardType.recommendation;
  bool get isWatchlist => mediaCardType == MediaCardType.watchlist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        vyuh.di.get<TMDBStore>().selectMovie(movie.id);
        vyuh.router.push(TmdbPath.movieDetails(movie.id));
      },
      child: SizedBox(
        width: width ?? theme.sizing.s50,
        child: representation == ListRepresentation.short
            ? isWatchlist
                ? Row(
                    children: [
                      SizedBox(
                        width: theme.sizing.width43(size.width),
                        height: theme.sizing.s28,
                        child: ImageAndPopularityWidget(
                          info: movie,
                          isRecommendation: isRecommendation,
                        ),
                      ),
                      Gap.w8,
                      Expanded(
                        child: TitleAndDateWidget(
                          browseTypeData: movie,
                          isRecommendation: isRecommendation,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ImageAndPopularityWidget(
                          info: movie,
                          isRecommendation: isRecommendation,
                        ),
                      ),
                      Gap.h8,
                      TitleAndDateWidget(
                        browseTypeData: movie,
                        isRecommendation: isRecommendation,
                      ),
                    ],
                  )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: theme.spacing.s16,
                      right: theme.spacing.s16,
                    ),
                    child: ImageAndPopularityWidget(
                      info: movie,
                      isRecommendation: isRecommendation,
                      representation: representation,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: theme.spacing.s16,
                      right: theme.spacing.s16,
                      top: theme.spacing.s16,
                    ),
                    child: TitleAndDateWidget(
                      browseTypeData: movie,
                      isRecommendation: isRecommendation,
                      representation: representation,
                    ),
                  ),
                  if (movie.overview.isNotEmpty)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: theme.spacing.s20),
                      child: Text(
                        movie.overview,
                        style: theme.tmdbTheme.bodyMedium,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
