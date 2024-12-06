import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/collection_view.dart';
import 'package:feature_tmdb/ui/sections/footer.dart';
import 'package:feature_tmdb/ui/sections/gallery.dart';
import 'package:feature_tmdb/ui/sections/hero.dart';
import 'package:feature_tmdb/ui/sections/people_card.dart';
import 'package:feature_tmdb/ui/sections/preview_list.dart';
import 'package:feature_tmdb/ui/sections/review_card.dart';
import 'package:feature_tmdb/ui/sections/statistics.dart';
import 'package:feature_tmdb/ui/sections/trailer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'series_detail_section.g.dart';

final class SeriesDetailSectionBuilder extends ContentBuilder {
  SeriesDetailSectionBuilder()
      : super(
          content: SeriesDetailSection.typeDescriptor,
          defaultLayout: SeriesDetailSectionLayout(),
          defaultLayoutDescriptor: SeriesDetailSectionLayout.typeDescriptor,
        );
}

@JsonSerializable()
final class SeriesDetailSectionLayout
    extends LayoutConfiguration<SeriesDetailSection> {
  static const schemaName = '${SeriesDetailSection.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Series Detail Section Layout',
    fromJson: SeriesDetailSectionLayout.fromJson,
  );

  SeriesDetailSectionLayout() : super(schemaType: schemaName);

  factory SeriesDetailSectionLayout.fromJson(Map<String, dynamic> json) =>
      _$SeriesDetailSectionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, SeriesDetailSection content) {
    switch (content.type) {
      case SeriesDetailSectionType.hero:
        return const HeroSection(mode: BrowseMode.series);
      case SeriesDetailSectionType.statistics:
        return const StatisticsSection(mode: BrowseMode.series);
      case SeriesDetailSectionType.cast:
        return PeopleSectionView(
          mode: BrowseMode.series,
          representation: content.representation,
          isCast: true,
        );
      case SeriesDetailSectionType.crew:
        return PeopleSectionView.crew(
          mode: BrowseMode.series,
          representation: content.representation,
          isCast: false,
        );
      case SeriesDetailSectionType.gallery:
        return const GallerySection(mode: BrowseMode.series);
      case SeriesDetailSectionType.recommendations:
        final store = vyuh.di.get<TMDBStore>();
        final seriesId = GoRouterState.of(context).seriesId();

        if (seriesId == null) {
          return empty;
        }

        return FeaturedPreviewListSection(
          mode: BrowseMode.series,
          cacheKey: (id) => '$id.series.recommendations',
          representation: content.representation,
          mediaCardType: MediaCardType.recommendation,
          seriesType: SeriesDetailSectionType.recommendations,
          futureBuilder: () {
            store.selectSeries(seriesId);
            return store.getFuture('$seriesId.series.recommendations');
          },
        );
      case SeriesDetailSectionType.reviews:
        return ReviewSection(
          mode: BrowseMode.series,
          representation: content.representation,
        );
      case SeriesDetailSectionType.footer:
        return const FooterSection(mode: BrowseMode.series);
      case SeriesDetailSectionType.trailer:
        return const TrailersSection(mode: BrowseMode.series);
    }
  }
}

@JsonSerializable()
final class SeriesDetailSection extends ContentItem {
  static const schemaName = 'tmdb.series.detailSection';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Series Detail Section',
    fromJson: SeriesDetailSection.fromJson,
  );

  final SeriesDetailSectionType type;
  final ListRepresentation representation;

  SeriesDetailSection({
    this.type = SeriesDetailSectionType.hero,
    this.representation = ListRepresentation.short,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory SeriesDetailSection.fromJson(Map<String, dynamic> json) =>
      _$SeriesDetailSectionFromJson(json);
}

enum SeriesDetailSectionType {
  hero,
  cast,
  crew,
  statistics,
  gallery,
  recommendations,
  reviews,
  footer,
  trailer
}
