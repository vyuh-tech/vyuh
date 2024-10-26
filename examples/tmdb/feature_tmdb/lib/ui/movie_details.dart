import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/ui/common_widgets/vote_percentage.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:feature_tmdb/ui/widget/add_to_watchlist_button.dart';
import 'package:feature_tmdb/ui/widget/dot_widget.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

class MovieHeroCard extends StatelessWidget {
  final Movie movie;

  const MovieHeroCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movie.backdropImage != null) ...[
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: theme.sizing.width80(width) + statusBarHeight,
                width: theme.sizing.widthFull(width),
                child: Card(
                  clipBehavior: Clip.none,
                  margin: EdgeInsets.zero,
                  child: ContentImage(
                    url: movie.backdropImage!,
                    height: theme.sizing.widthFull(width),
                    width: theme.sizing.widthFull(width),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: theme.linearGradient.inverseSecondaryGradient,
                  ),
                ),
              ),
              Positioned.fill(
                bottom: -theme.spacing.s2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: theme.linearGradient.primaryGradient,
                  ),
                ),
              ),
              Positioned(
                bottom: -theme.spacing.s32,
                left: theme.spacing.s20,
                child: SizedBox(
                  width: theme.sizing.width43(width),
                  height: theme.sizing.width43(width),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: ContentImage(
                      url: movie.posterImage,
                      width: theme.sizing.widthFull(width),
                      height: theme.sizing.widthFull(width),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: theme.spacing.s16,
                top: theme.spacing.s4,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ] else ...[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.colorScheme.primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        Padding(
          padding: EdgeInsets.only(
            left: theme.spacing.s32,
            right: theme.spacing.s32,
            bottom: theme.spacing.s8,
            top: movie.backdropImage != null
                ? theme.spacing.s48
                : theme.spacing.s2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (movie.status != null)
                Row(
                  children: [
                    Chip(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.s8,
                      ),
                      backgroundColor: theme.colorScheme.secondary,
                      label: Text(
                        movie.status ?? '',
                        style: theme.tmdbTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.onSecondary),
                      ),
                    ),
                    if (movie.voteAverage != null)
                      VotePercentage(
                        voteAverage: movie.voteAverage,
                        hasBackground: false,
                      ),
                  ],
                ),
              movieDetailWidget(context),
              ds.Gap.h24,
              AddToWatchlistButton(
                item: movie,
              ),
              ds.Gap.h24,
              if (movie.genres != null)
                Wrap(
                  spacing: theme.spacing.s8,
                  children: movie.genres!
                      .map(
                        (genre) => _genreChip(context, genre),
                      )
                      .toList(),
                ),
              if (movie.overview.isNotEmpty) ...[
                ds.Gap.h24,
                Text(movie.overview, style: theme.tmdbTheme.bodyMedium),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget movieDetailWidget(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: theme.tmdbTheme.displayMedium,
        ),
        if (movie.tagline != null)
          Text(
            movie.tagline!,
            style: theme.tmdbTheme.bodyMedium,
          ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              movie.adult ? 'A' : 'U/A',
              style: theme.tmdbTheme.labelLarge,
            ),
            ds.Gap.w4,
            const DotWidget(),
            ds.Gap.w4,
            Text('Movie', style: theme.tmdbTheme.labelLarge),
            ds.Gap.w4,
            const DotWidget(),
            ds.Gap.w4,
            Text(
              movie.releaseDate.formattedNumericDate,
              style: theme.tmdbTheme.labelLarge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _genreChip(BuildContext context, Genre genre) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => vyuh.router.push(TmdbPath.movieGenres(genre.id)),
      child: Chip(
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.borderRadius.large),
        ),
        backgroundColor: theme.colorScheme.inverseSurface.withOpacity(0.8),
        labelStyle: theme.tmdbTheme.labelMedium?.apply(
          color: theme.colorScheme.onPrimary,
        ),
        label: Text(
          genre.name,
          style: theme.tmdbTheme.headlineSmall,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.s4,
        ),
      ),
    );
  }
}
