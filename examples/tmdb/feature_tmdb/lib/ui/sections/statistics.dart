import 'package:chakra_shared/chakra_shared.dart';
import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:feature_tmdb/ui/section_title.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

extension on FeaturedShow {
  Widget statisticsCard() => isMovie
      ? StatisticsCard(
          statistics: {
            'Release Date': (this as Movie).releaseDate.formattedNumericDate,
            'Duration': (this as Movie).runtime != null
                ? '${(this as Movie).runtime} minutes'
                : '-',
          },
        )
      : StatisticsCard(
          statistics: {
            'Release Date': (this as Series).firstAirDate.formattedNumericDate,
          },
        );
}

class StatisticsSection extends StatelessWidget {
  final BrowseMode mode;

  const StatisticsSection({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final cacheSuffix = mode == BrowseMode.series ? 'series' : 'movie';
    final store = vyuh.di.get<TMDBStore>();
    final id = mode.selectedId(context);

    if (id == null) {
      return empty;
    }

    return DetailBuilder<FeaturedShow>(
      futureBuilder: () {
        if (mode == BrowseMode.series) {
          store.selectSeries(id);
        } else {
          store.selectMovie(id);
        }

        return store.getFuture('$id.$cacheSuffix');
      },
      builder: (context, data) => data.statisticsCard(),
    );
  }
}

class StatisticsCard extends StatelessWidget {
  final Map<String, String> statistics;

  const StatisticsCard({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: theme.spacing.s32,
        right: theme.spacing.s32,
        top: theme.spacing.s16,
        bottom: theme.spacing.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Quick Stats'),
          SizedBox(height: theme.sizing.s2),
          Container(
            padding: EdgeInsets.all(theme.spacing.s16),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Wrap(
              spacing: theme.spacing.s64,
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.start,
              runSpacing: 10,
              children: [
                for (final entry in statistics.entries)
                  Statistic(
                    title: entry.key,
                    value: entry.value,
                    textColor: theme.colorScheme.onPrimary,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Statistic extends StatelessWidget {
  final String title;
  final String value;
  final Color textColor;

  const Statistic({
    super.key,
    required this.title,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.tmdbTheme.caption?.copyWith(color: textColor),
        ),
        Text(
          value,
          style: theme.tmdbTheme.bodyMedium?.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
