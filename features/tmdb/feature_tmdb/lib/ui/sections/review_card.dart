import 'dart:math';

import 'package:chakra_shared/chakra_shared.dart';
import 'package:chakra_shared/extension/string_extension.dart';
import 'package:collection/collection.dart';
import 'package:design_system/core/gap.dart';
import 'package:design_system/design_system.dart' as ds;
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:feature_tmdb/ui/section_title.dart';
import 'package:feature_tmdb/utils/constants.dart';
import 'package:flutter/material.dart' as f;
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/runtime/platform/vyuh_platform.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class ReviewSection extends StatelessWidget {
  final BrowseMode mode;
  final ListRepresentation representation;
  final String title;

  const ReviewSection({
    super.key,
    required this.mode,
    this.title = 'Reviews',
    this.representation = ListRepresentation.short,
  });

  factory ReviewSection.large({
    required BrowseMode mode,
  }) =>
      ReviewSection(
        mode: mode,
        representation: ListRepresentation.long,
        title: 'Reviews',
      );

  @override
  Widget build(BuildContext context) {
    final cacheSuffix = mode == BrowseMode.series ? 'series' : 'movie';
    final store = vyuh.di.get<TMDBStore>();
    final id = mode.selectedId(context);

    if (id == null) {
      return empty;
    }

    int? idx = mode.selectedId(context);

    return DetailBuilder<ListResponse<Review>>(
      futureBuilder: () {
        if (mode == BrowseMode.series) {
          store.selectSeries(id);
        } else {
          store.selectMovie(id);
        }

        return store.getFuture('$id.$cacheSuffix.reviews');
      },
      builder: (context, data) {
        final items =
            data.results.sortedBy((x) => x.updatedAt).reversed.toList();
        final theme = Theme.of(context);

        if (items.isEmpty) {
          return empty;
        }
        if (representation == ListRepresentation.short) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: theme.spacing.s32,
                  right: theme.spacing.s20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SectionTitle(title: title),
                    if (items.shouldShowViewAll)
                      TextButton(
                        onPressed: () => mode == BrowseMode.movies
                            ? vyuh.router
                                .push(TmdbPath.movieReviewsList(idx ?? 0))
                            : vyuh.router
                                .push(TmdbPath.seriesReviewsList(idx ?? 0)),
                        child: Row(
                          children: [
                            Text(
                              'See All',
                              style: theme.tmdbTheme.labelMedium?.apply(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 24,
                              color: theme.colorScheme.secondary,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              items.isEmpty
                  ? empty
                  : SizedBox(
                      height: theme.sizing
                          .width31(MediaQuery.of(context).size.height),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: theme.spacing.s32,
                          right: theme.spacing.s32,
                        ),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) => SizedBox(
                            width: theme.spacing.s8,
                          ),
                          itemCount: min(maxCountForViewAll, items.length),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  8 * theme.spacing.s8,
                              child: ReviewCard(
                                item: items[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          );
        } else {
          return LimitedBox(
            maxHeight: theme.sizing.width80(MediaQuery.of(context).size.height),
            child: f.Padding(
              padding: EdgeInsets.only(bottom: theme.spacing.s48),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: theme.spacing.s32,
                      right: theme.spacing.s32,
                      top: theme.spacing.s24,
                    ),
                    child: ReviewCard(item: items[index]),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.item,
  });

  final Review item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ScrollController scrollController = ScrollController();

    return SizedBox(
      height: theme.sizing.width36(MediaQuery.sizeOf(context).height),
      child: f.Card(
        clipBehavior: Clip.none,
        shape: const BeveledRectangleBorder(),
        color: theme.colorScheme.onPrimary,
        child: Padding(
          padding: EdgeInsets.only(
            left: theme.spacing.s12,
            right: theme.spacing.s12,
            top: theme.spacing.s20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  height: theme.sizing
                      .width23(MediaQuery.sizeOf(context).height * 0.9),
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: ReadMoreText(
                        item.content.parseHtml(item.content),
                        trimLines: 4,
                        trimExpandedText: '  Read Less',
                        trimCollapsedText: '  Read More',
                        moreStyle: theme.tmdbTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.shadow,
                        ),
                        lessStyle: theme.tmdbTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.shadow,
                        ),
                        delimiter: " ...",
                        preDataTextStyle: theme.tmdbTheme.bodyMedium,
                        postDataTextStyle: theme.tmdbTheme.bodyMedium,
                        style: theme.tmdbTheme.bodyMedium,
                        textAlign: TextAlign.start,
                        delimiterStyle: theme.tmdbTheme.bodyMedium!.copyWith(),
                      ),
                    ),
                  ),
                ),
              ),
              Gap.h24,
              // const Spacer(),
              ...[
                Text(
                  item.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.tmdbTheme.bodyMedium,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: theme.spacing.s8),
                  child: Text(
                    item.updatedAt.formattedNumericDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.tmdbTheme.bodySmall?.apply(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
