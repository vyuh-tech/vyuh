import 'package:design_system/design_system.dart';
import 'package:feature_tmdb/content/watchlist_view.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/ui/collection_view.dart';
import 'package:feature_tmdb/ui/sections/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'movie_watchlist_section.g.dart';

@JsonSerializable()
final class MovieWatchlistSection extends ContentItem {
  static const schemaName = 'tmdb.movie.watchlistSection';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Movie Watchlist Section',
    fromJson: MovieWatchlistSection.fromJson,
  );

  MovieWatchlistSection({
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory MovieWatchlistSection.fromJson(Map<String, dynamic> json) =>
      _$MovieWatchlistSectionFromJson(json);
}

final class MovieWatchlistSectionBuilder extends ContentBuilder {
  MovieWatchlistSectionBuilder()
      : super(
          content: MovieWatchlistSection.typeDescriptor,
          defaultLayout: MovieWatchlistSectionLayout(),
          defaultLayoutDescriptor: MovieWatchlistSectionLayout.typeDescriptor,
        );
}

@JsonSerializable()
final class MovieWatchlistSectionLayout
    extends LayoutConfiguration<MovieWatchlistSection> {
  static const schemaName =
      '${MovieWatchlistSection.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Movie Watchlist Section Layout',
    fromJson: MovieWatchlistSectionLayout.fromJson,
  );

  MovieWatchlistSectionLayout() : super(schemaType: schemaName);

  factory MovieWatchlistSectionLayout.fromJson(Map<String, dynamic> json) =>
      _$MovieWatchlistSectionLayoutFromJson(json);

  @override
  Widget build(BuildContext context, MovieWatchlistSection content) {
    return const MovieWatchlistView();
  }
}

final class MovieWatchlistView extends StatelessWidget {
  const MovieWatchlistView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = vyuh.di.get<TMDBStore>();

    return Observer(
      builder: (context) {
        final list = store.watchlist;

        final movieList = list.whereType<MovieShortInfo>().toList();

        if (movieList.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(theme.spacing.s16),
            child: const Text('No movies in your watchlist'),
          );
        } else {
          return WatchlistWidget(
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              final item = movieList[index];
              return GestureDetector(
                onTap: () {
                  store.selectMovie(item.id);
                  vyuh.router.push(TmdbPath.movieDetails(item.id));
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
      child: MovieCard(
        movie: item as MovieShortInfo,
        mediaCardType: MediaCardType.watchlist,
        width: theme.sizing.widthFull(size.width),
      ),
    );
  }
}
