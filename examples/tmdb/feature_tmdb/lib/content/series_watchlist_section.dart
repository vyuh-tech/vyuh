import 'package:design_system/design_system.dart';
import 'package:feature_tmdb/content/watchlist_view.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/collection_view.dart';
import 'package:feature_tmdb/ui/sections/series_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'series_watchlist_section.g.dart';

@JsonSerializable()
final class SeriesWatchlistSection extends ContentItem {
  static const schemaName = 'tmdb.series.watchlistSection';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Series Watchlist Section',
    fromJson: SeriesWatchlistSection.fromJson,
  );

  SeriesWatchlistSection({
    super.layout,
  }) : super(schemaType: schemaName);

  factory SeriesWatchlistSection.fromJson(Map<String, dynamic> json) =>
      _$SeriesWatchlistSectionFromJson(json);
}

final class SeriesWatchlistSectionBuilder extends ContentBuilder {
  SeriesWatchlistSectionBuilder()
      : super(
          content: SeriesWatchlistSection.typeDescriptor,
          defaultLayout: SeriesWatchlistSectionLayout(),
          defaultLayoutDescriptor: SeriesWatchlistSectionLayout.typeDescriptor,
        );
}

@JsonSerializable()
final class SeriesWatchlistSectionLayout
    extends LayoutConfiguration<SeriesWatchlistSection> {
  static const schemaName =
      '${SeriesWatchlistSection.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Series Watchlist Section Layout',
    fromJson: SeriesWatchlistSectionLayout.fromJson,
  );

  SeriesWatchlistSectionLayout() : super(schemaType: schemaName);

  factory SeriesWatchlistSectionLayout.fromJson(Map<String, dynamic> json) =>
      _$SeriesWatchlistSectionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, SeriesWatchlistSection content) {
    return const SeriesWatchlistView();
  }
}

final class SeriesWatchlistView extends StatelessWidget {
  const SeriesWatchlistView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = vyuh.di.get<TMDBStore>();

    return Observer(
      builder: (context) {
        final list = store.watchlist;

        final seriesList = list.whereType<SeriesShortInfo>().toList();

        if (seriesList.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(theme.spacing.s16),
            child: const Text('No series in your watchlist'),
          );
        } else {
          return WatchlistWidget(
            itemCount: seriesList.length,
            itemBuilder: (context, index) {
              final item = seriesList[index];
              return GestureDetector(
                onTap: () {
                  store.selectSeries(item.id);
                  vyuh.router.push(TmdbPath.seriesDetails(item.id));
                },
                child: DismissibleWidget(context: context, item: item),
              );
            },
          );
        }
      },
    );
  }
}

class DismissibleWidget extends StatelessWidget {
  const DismissibleWidget({
    super.key,
    required this.context,
    required this.item,
  });

  final BuildContext context;
  final ShortInfo item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = vyuh.di.get<TMDBStore>();
    final size = MediaQuery.of(context).size;

    return Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        store.watchlist.remove(item);
      },
      background: Container(
        color: theme.colorScheme.error,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.s32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              color: theme.colorScheme.onPrimary,
            ),
            Text(
              'Delete',
              style: theme.tmdbTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      child: SeriesCard(
        series: item as SeriesShortInfo,
        mediaCardType: MediaCardType.watchlist,
        width: theme.sizing.widthFull(size.width),
      ),
    );
  }
}
