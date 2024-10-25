import 'package:design_system/design_system.dart';
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/collection_view.dart';
import 'package:feature_tmdb/ui/formatters.dart';
import 'package:feature_tmdb/ui/sections/series_card.dart';
import 'package:feature_tmdb/ui/widget/carousel_widget.dart';
import 'package:feature_tmdb/ui/widget/circular_carousel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'api_config_series.g.dart';

@JsonSerializable()
final class ApiSeriesConfigsSection
    extends ApiConfiguration<List<SeriesShortInfo>> {
  static const schemaName = 'tmdb.series.configsSection';

  final SeriesListType resourceType;
  final ConfigsSectionType type;
  final ListRepresentation representation;
  final int itemCount;
  final bool showIndicator;

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'API Configuration (Series)',
    fromJson: ApiSeriesConfigsSection.fromJson,
  );

  ApiSeriesConfigsSection({
    required this.resourceType,
    this.type = ConfigsSectionType.carousel,
    required this.itemCount,
    required this.showIndicator,
    this.representation = ListRepresentation.short,
  }) : super(schemaType: schemaName);

  factory ApiSeriesConfigsSection.fromJson(Map<String, dynamic> json) =>
      _$ApiSeriesConfigsSectionFromJson(json);

  @override
  Widget build(
    BuildContext context,
    List<SeriesShortInfo>? data,
  ) {
    SeriesListType? resourceType = _getResourceType(context);
    final theme = Theme.of(context);

    switch (type) {
      case ConfigsSectionType.carousel:
        return CircularCarousel(
          itemCount: data?.limited(itemCount).length ?? 0,
          itemBuilder: (context, index) {
            final series = data![index];
            return CarouselWidget(
              id: series.id,
              posterImage: series.posterImage ?? '',
              title: series.title,
              voteAverage: series.voteAverage,
            );
          },
          indicatorType: showIndicator
              ? CarouselIndicatorType.stacked
              : CarouselIndicatorType.none,
          aspectRatio: theme.aspectRatio.sixteenToNine,
        );
      case ConfigsSectionType.listType:
        if (resourceType == null) {
          return empty;
        }

        return CollectionView<SeriesShortInfo>(
          items: data ?? [],
          itemBuilder: (context, item) =>
              representation == ListRepresentation.short
                  ? SeriesCard(
                      series: item,
                    )
                  : SeriesCard.large(
                      series: item,
                    ),
          title: resourceType.title,
          variant: representation,
          onViewAllTap: () {
            vyuh.router.push(TmdbPath.seriesList(resourceType));
          },
        );
    }
  }

  @override
  Future<List<SeriesShortInfo>?> invoke(
    BuildContext context,
  ) async {
    switch (type) {
      case ConfigsSectionType.carousel:
        final data =
            await vyuh.di.get<TMDBStore>().fetchSeriesList(resourceType);
        return data.results;
      case ConfigsSectionType.listType:
        SeriesListType? resType = _getResourceType(context);

        if (resType == null) {
          return null;
        }

        final genreId = GoRouterState.of(context).genreId();

        final data = await vyuh.di
            .get<TMDBStore>()
            .fetchSeriesList(resType, genreId: genreId);
        return data.results;
    }
  }

  _getResourceType(BuildContext context) {
    SeriesListType? type = resourceType;
    if (resourceType == SeriesListType.bySelectedList) {
      type = GoRouterState.of(context).seriesListType();
    }

    return type;
  }
}
