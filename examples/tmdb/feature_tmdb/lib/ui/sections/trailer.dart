import 'package:chakra_shared/ui/detail_builder.dart';
import 'package:chakra_shared/ui/youtube_video_player.dart';
import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/section_title.dart';
import 'package:feature_tmdb/ui/widget/circular_carousel.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class TrailersSection extends StatelessWidget {
  final BrowseMode mode;

  const TrailersSection({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final cacheSuffix = mode == BrowseMode.series ? 'series' : 'movie';
    final store = vyuh.di.get<TMDBStore>();
    final id = mode.selectedId(context);

    if (id == null) {
      return empty;
    }

    return DetailBuilder<ListResponse<Trailer>>(
      futureBuilder: () {
        if (mode == BrowseMode.series) {
          store.selectSeries(id);
        } else {
          store.selectMovie(id);
        }

        return store.getFuture('$id.$cacheSuffix.trailer');
      },
      builder: (context, data) {
        final videoIdList = data.results.map((trailer) => trailer.key).toList();

        if (videoIdList.isEmpty) {
          return empty;
        }

        final theme = Theme.of(context);

        return Padding(
          padding: EdgeInsets.only(
            right: theme.spacing.s32,
            left: theme.spacing.s32,
            top: theme.spacing.s16,
            bottom: theme.spacing.s16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Trailers'),
              SizedBox(height: theme.spacing.s8),
              CircularCarousel(
                aspectRatio: theme.aspectRatio.sixteenToNine,
                indicatorType: CarouselIndicatorType.none,
                itemCount: videoIdList.length,
                itemBuilder: (context, index) {
                  final videoId = videoIdList[index];
                  return Padding(
                    padding: EdgeInsets.only(right: theme.spacing.s8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        theme.borderRadius.normal,
                      ),
                      child: YoutubeVideoPlayer(
                        videoId: videoId,
                        aspectRatio: theme.aspectRatio.sixteenToNine,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
