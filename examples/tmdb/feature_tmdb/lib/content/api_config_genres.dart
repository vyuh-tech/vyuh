import 'package:design_system/design_system.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:feature_tmdb/tmdb_store.dart';
import 'package:feature_tmdb/utils/assets.dart';
import 'package:flutter/material.dart' as f;
import 'package:flutter/material.dart' hide Action;
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content/action.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'api_config_genres.g.dart';

@JsonSerializable()
final class ApiConfigGenreSelection extends ApiConfiguration<List<Genre>> {
  static const schemaName = 'tmdb.apiConfig.genres';
  final bool allowModeToggle;
  final Action? action;
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'API Configuration (Genres)',
    fromJson: ApiConfigGenreSelection.fromJson,
  );

  ApiConfigGenreSelection({this.allowModeToggle = false, this.action})
      : super(schemaType: schemaName);

  factory ApiConfigGenreSelection.fromJson(Map<String, dynamic> json) =>
      _$ApiConfigGenreSelectionFromJson(json);

  @override
  Widget build(BuildContext context, List<Genre>? data) {
    if (data == null || data.isEmpty) {
      return const Center(child: Text('No Genres found'));
    }

    final theme = Theme.of(context);
    final store = vyuh.di.get<TMDBStore>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.s24,
        vertical: theme.spacing.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Search by Genres',
            style: theme.tmdbTheme.headlineSmall,
          ),
          SizedBox(height: theme.spacing.s8),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: theme.aspectRatio.threeToTwo,
              mainAxisSpacing: theme.spacing.s8,
              crossAxisSpacing: theme.spacing.s8,
              children: [
                for (final item in data)
                  GestureDetector(
                    onTap: () {
                      //added in order to close the dialog route for genre on movies list screen
                      if (vyuh.router.instance.canPop()) {
                        vyuh.router.pop();
                      }
                      if (store.isMoviesMode) {
                        vyuh.router.go(TmdbPath.movieGenres(item.id));
                      } else {
                        vyuh.router.go(TmdbPath.seriesGenres(item.id));
                      }
                      if (vyuh.router.instance.canPop()) {
                        vyuh.router.pop();
                      }
                    },
                    child: GenreTile(genre: item),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<List<Genre>> invoke(BuildContext context) async {
    final store = vyuh.di.get<TMDBStore>();
    final client = vyuh.di.get<TMDBClient>();

    final data = store.isMoviesMode
        ? await client.movies.genres()
        : await client.series.genres();

    return data.genres;
  }
}

class GenreTile extends StatelessWidget {
  final Genre genre;

  static final _icons = {
    28: Assets.action,
    12: Assets.adventure,
    16: Assets.animation,
    35: Assets.comedy,
    80: Assets.crime,
    99: Assets.documentary,
    18: Assets.drama,
    10751: Assets.family,
    14: Assets.fantasy,
    36: Assets.history,
    27: Assets.horror,
    10402: Assets.music,
    9648: Assets.mystery,
    10749: Assets.romance,
    878: Assets.scienceFiction,
    10770: Assets.tvMovie,
    53: Assets.thriller,
    10752: Assets.war,
    37: Assets.western,
  };

  static final _seriesIcons = {
    10759: Assets.action,
    16: Assets.animation,
    35: Assets.comedy,
    80: Assets.crime,
    99: Assets.documentary,
    18: Assets.drama,
    37: Assets.western,
    9648: Assets.mystery,
    10749: Assets.romance,
    10751: Assets.family,
    10752: Assets.war,
    10762: Assets.kids,
    10763: Assets.news,
    10764: Assets.reality,
    10765: Assets.scienceFiction,
    10766: Assets.soap,
    10767: Assets.talk,
    10768: Assets.war,
    10770: Assets.tvMovie,
  };

  const GenreTile({
    super.key,
    required this.genre,
  });

  @override
  f.Widget build(f.BuildContext context) {
    final store = vyuh.di.get<TMDBStore>();
    final theme = Theme.of(context);
    final assetPath =
        store.isMoviesMode ? _icons[genre.id] : _seriesIcons[genre.id];

    return Stack(
      children: [
        Positioned.fill(
          child: f.Card(
            clipBehavior: Clip.antiAlias,
            child: assetPath != null
                ? Opacity(
                    opacity: 0.70,
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      package: 'feature_tmdb',
                    ),
                  )
                : empty,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            genre.name,
            textAlign: TextAlign.center,
            style: theme.tmdbTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
