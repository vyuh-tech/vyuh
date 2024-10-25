import 'package:chakra_shared/ui/detail_builder.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/movie_details.dart';
import 'package:feature_tmdb/ui/series_details.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class HeroSection extends StatelessWidget {
  final BrowseMode mode;

  const HeroSection({super.key, required this.mode});

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
      builder: (context, data) {
        return data.isMovie
            ? MovieHeroCard(movie: data as Movie)
            : SeriesHeroCard(series: data as Series);
      },
    );
  }
}
