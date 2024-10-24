import 'package:chakra_shared/chakra_shared.dart';
import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class FooterSection extends StatelessWidget {
  final BrowseMode mode;

  const FooterSection({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final cacheSuffix = mode == BrowseMode.series ? 'series' : 'movie';
    final store = vyuh.di.get<TMDBStore>();
    final id = mode.selectedId(context);

    if (id == null) {
      return empty;
    }

    return DetailBuilder<FeaturedShow>(
      builder: (context, data) => FooterCard(backdropImage: data.backdropImage),
      futureBuilder: () {
        if (mode == BrowseMode.series) {
          store.selectSeries(id);
        } else {
          store.selectMovie(id);
        }

        return store.getFuture('$id.$cacheSuffix');
      },
    );
  }
}

class FooterCard extends StatelessWidget {
  final String? backdropImage;

  const FooterCard({
    super.key,
    this.backdropImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;

    if (backdropImage == null) {
      return empty;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ContentImage(
          url: backdropImage,
          width: width,
          height: theme.sizing.s64,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          bottom: -theme.sizing.s8,
          child: Container(
            height: theme.sizing.s64,
            decoration: BoxDecoration(
              gradient: theme.linearGradient.inversePrimaryGradient,
            ),
          ),
        ),
      ],
    );
  }
}
