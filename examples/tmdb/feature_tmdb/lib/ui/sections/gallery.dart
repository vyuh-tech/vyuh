import 'package:chakra_shared/ui/detail_builder.dart';
import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:feature_tmdb/ui/section_title.dart';
import 'package:feature_tmdb/ui/widget/circular_carousel.dart';
import 'package:feature_tmdb/ui/zoomable_image.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class GallerySection extends StatelessWidget {
  final BrowseMode mode;

  const GallerySection({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final cacheSuffix = mode == BrowseMode.series ? 'series' : 'movie';
    final store = vyuh.di.get<TMDBStore>();
    final id = mode.selectedId(context);

    if (id == null) {
      return empty;
    }

    return DetailBuilder<TMDBImageSet>(
      futureBuilder: () {
        if (mode == BrowseMode.series) {
          store.selectSeries(id);
        } else {
          store.selectMovie(id);
        }

        return store.getFuture('$id.$cacheSuffix.images');
      },
      builder: (context, data) {
        final theme = Theme.of(context);
        final size = MediaQuery.of(context).size;

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
              if (data.backdrops.isEmpty) ...[
                empty,
              ] else ...[
                const SectionTitle(title: 'Backdrops'),
                SizedBox(height: theme.sizing.s2),
                CircularCarousel(
                  aspectRatio: theme.aspectRatio.sixteenToNine,
                  indicatorType: CarouselIndicatorType.below,
                  itemCount: data.backdrops.limited().length,
                  itemBuilder: (context, index) {
                    final image = data.backdrops[index];
                    return Container(
                      margin: EdgeInsets.only(right: theme.spacing.s8),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(
                          theme.borderRadius.normal,
                        ),
                      ),
                      child: ZoomableImage(
                        title: 'Backdrops',
                        imageUrl: image.originalImage,
                        fit: BoxFit.cover,
                        child: ContentImage(
                          url: image.image,
                          width: theme.sizing.widthFull(size.width),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: theme.sizing.s5),
              ],
              if (data.posters.isEmpty) ...[
                empty,
              ] else ...[
                const SectionTitle(title: 'Posters'),
                SizedBox(height: theme.sizing.s2),
                CircularCarousel(
                  viewportFraction: 0.67,
                  aspectRatio: theme.aspectRatio.fourToThree,
                  indicatorType: CarouselIndicatorType.below,
                  itemCount: data.posters.limited().length,
                  itemBuilder: (context, index) {
                    final image = data.posters[index];
                    final theme = Theme.of(context);
                    return Container(
                      margin: EdgeInsets.only(right: theme.spacing.s16),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          theme.borderRadius.small,
                        ),
                      ),
                      child: ZoomableImage(
                        title: 'Posters',
                        imageUrl: image.originalImage,
                        fit: BoxFit.cover,
                        child: ContentImage(
                          url: image.image,
                          width: theme.sizing.widthFull(size.width),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                //
              ],
            ],
          ),
        );
      },
    );
  }
}
