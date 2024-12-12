import 'dart:ui';

import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/common_widgets/vote_percentage.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class CarouselWidget extends StatelessWidget {
  final String posterImage;
  final String title;
  final double? voteAverage;
  final int id;
  const CarouselWidget({
    super.key,
    required this.posterImage,
    required this.title,
    this.voteAverage,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = vyuh.di.get<TMDBStore>();

    return GestureDetector(
      onTap: () {
        if (store.isMoviesMode) {
          vyuh.di.get<TMDBStore>().selectMovie(id);
          vyuh.router.push(TmdbPath.movieDetails(id));
        } else {
          vyuh.di.get<TMDBStore>().selectSeries(id);
          vyuh.router.push(TmdbPath.seriesDetails(id));
        }
      },
      child: Stack(
        children: [
          ContentImage(
            url: posterImage,
            height: theme.sizing.s64,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: theme.sizing.s10,
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.s8,
                    vertical: theme.spacing.s4,
                  ),
                  child: Text(
                    title,
                    style: theme.tmdbTheme.displaySmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: theme.spacing.s32,
            top: theme.spacing.s16,
            child: VotePercentage(
              voteAverage: voteAverage,
            ),
          ),
          Positioned.fill(
            bottom: -theme.spacing.s32,
            child: Container(
              decoration: BoxDecoration(
                gradient: theme.linearGradient.secondaryGradient,
              ),
            ),
          ),
          Positioned.fill(
            bottom: -theme.spacing.s32,
            child: Container(
              decoration: BoxDecoration(
                gradient: theme.linearGradient.tertiaryGradient,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
