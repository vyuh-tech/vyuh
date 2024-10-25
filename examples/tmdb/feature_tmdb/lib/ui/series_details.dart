import 'package:design_system/core/index.dart';
import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/ui/common_widgets/vote_percentage.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:feature_tmdb/ui/sections/provider.dart';
import 'package:feature_tmdb/ui/widget/add_to_watchlist_button.dart';
import 'package:feature_tmdb/ui/widget/dot_widget.dart';
import 'package:flutter/material.dart' as f;
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class SeriesHeroCard extends StatelessWidget {
  final Series series;

  const SeriesHeroCard({
    super.key,
    required this.series,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (series.backdropImage != null) ...[
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: theme.sizing.width80(width) + statusBarHeight,
                width: theme.sizing.widthFull(width),
                child: f.Card(
                  clipBehavior: Clip.none,
                  margin: EdgeInsets.zero,
                  child: ContentImage(
                    url: series.backdropImage!,
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
                  child: f.Card(
                    clipBehavior: Clip.antiAlias,
                    child: ContentImage(
                      url: series.posterImage,
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
            top: series.backdropImage != null
                ? theme.spacing.s48
                : theme.spacing.s2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (series.status != null)
                f.Row(
                  children: [
                    Chip(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.s8,
                      ),
                      backgroundColor: theme.colorScheme.primary,
                      label: Text(
                        series.status ?? '',
                        style: theme.tmdbTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.onPrimary),
                      ),
                    ),
                    if (series.voteAverage != null)
                      VotePercentage(
                        voteAverage: series.voteAverage,
                        hasBackground: false,
                      ),
                  ],
                ),
              seriesDetailWidget(context),
              Gap.h24,
              AddToWatchlistButton(
                item: series,
              ),
              Gap.h24,
              if (series.genres != null)
                Wrap(
                  spacing: theme.spacing.s8,
                  children: series.genres!
                      .map(
                        (genre) => _genreChip(context, genre),
                      )
                      .toList(),
                ),
              Gap.h24,
              Text(
                'Providers',
                style: theme.textTheme.titleMedium?.apply(fontWeightDelta: 1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: theme.spacing.s16),
                child: Wrap(
                  spacing: theme.spacing.s16,
                  runSpacing: theme.spacing.s16,
                  children: [
                    for (final nw in series.networks)
                      ProviderView(provider: nw),
                  ],
                ),
              ),
              Text(series.overview, style: theme.tmdbTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget seriesDetailWidget(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          series.name,
          style: theme.tmdbTheme.displayMedium,
        ),
        if (series.tagline != null)
          Text(
            series.tagline!,
            style: theme.tmdbTheme.bodyMedium,
          ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              series.adult ? 'A' : 'U/A',
              style: theme.tmdbTheme.labelLarge,
            ),
            Gap.w4,
            const DotWidget(),
            Gap.w4,
            Text('Series', style: theme.tmdbTheme.labelLarge),
            Gap.w4,
            const DotWidget(),
            Gap.w4,
            Text(
              '${series.numberOfEpisodes} Episodes',
              style: theme.tmdbTheme.labelLarge,
            ),
            Gap.w4,
            const DotWidget(),
            Gap.w4,
            Text(
              series.firstAirDate.formattedNumericDate,
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
      onTap: () => vyuh.router.push(TmdbPath.seriesGenres(genre.id)),
      child: Chip(
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: f.BorderRadius.circular(theme.borderRadius.large),
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
