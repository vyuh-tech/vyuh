import 'package:collection/collection.dart';
import 'package:design_system/design_system.dart' hide BorderRadius;
import 'package:feature_settings/feature_settings.dart';
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// Returns a function that executes [fn] only once and returns its result.
/// Subsequent calls return the result of [empty].
///
T Function() once<T>(T Function() fn, T Function() empty) {
  bool done = false;
  late T value;

  return () {
    if (done) return empty();
    done = true;

    value = fn();
    done = true;
    return value;
  };
}

final personRoute = once<List<CMSRoute>>(
  () => [
    CMSRoute(
      path: '/tmdb/person/:path(.*)',
      cmsPathResolver: mediaPathResolver,
    ),
  ],
  () => [],
);

List<go.RouteBase> routes(Settings settings) {
  return [
    CMSRoute(path: '/tmdb'),
    if (settings.tabs.length >= 2)
      StatefulShellRoute.indexedStack(
        branches: settings.tabs
            .map(
              (tab) => StatefulShellBranch(
                navigatorKey: tab.key,
                routes: [
                  CMSRoute(
                    path: tab.path,
                    routes: [
                      CMSRoute(
                        path: ':path(.*)',
                        cmsPathResolver: mediaPathResolver,
                      ),
                    ],
                  ),
                  ...personRoute(),
                ],
              ),
            )
            .toList(growable: false),
        builder: (context, __, shell) {
          final theme = Theme.of(context);
          return Scaffold(
            body: shell,
            bottomNavigationBar: NavigationBar(
              backgroundColor: theme.colorScheme.onPrimary,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: settings.tabs
                  .map(
                    (tab) => NavigationDestination(
                      label: tab.title,
                      icon: tab.icon,
                      selectedIcon: tab.selectedIcon,
                    ),
                  )
                  .toList(growable: false),
              selectedIndex: shell.currentIndex,
              height: theme.sizing.s22,
              indicatorColor: theme.colorScheme.onPrimary,
              onDestinationSelected: (index) => shell.goBranch(
                index,
                initialLocation: index == shell.currentIndex,
              ),
            ),
          );
        },
      ),
  ];
}

final movieListTypes = MovieListType.values.map((e) => e.name).join('|');
final seriesListTypes = SeriesListType.values.map((e) => e.name).join('|');

String mediaPathResolver(String path) {
  final resolvedPath = switch (path) {
    // Movies
    (String x) when x.contains(RegExp('/home/movie/($movieListTypes)\$')) =>
      '/tmdb/movie/list',
    (String x) when x.contains(RegExp(r'/home/movie/\d+$')) =>
      '/tmdb/movie/details',
    (String x) when x.contains(RegExp(r'/home/movie/(\d+)/cast')) =>
      '/tmdb/movie/cast',
    (String x) when x.contains(RegExp(r'/home/movie/(\d+)/crew')) =>
      '/tmdb/movie/crew',
    (String x) when x.contains(RegExp(r'/home/movie/(\d+)/reviews')) =>
      '/tmdb/movie/reviews',
    (String x) when x.contains(RegExp(r'/home/movie/(\d+)/similar')) =>
      '/tmdb/movie/similar',
    (String x) when x.contains(RegExp(r'/search/movie/genres/\d+$')) =>
      '/tmdb/movie/genres',
    // Series
    (String x) when x.contains(RegExp('/home/series/($seriesListTypes)\$')) =>
      '/tmdb/series/list',
    (String x) when x.contains(RegExp(r'/home/series/\d+$')) =>
      '/tmdb/series/details',
    (String x) when x.contains(RegExp(r'/home/series/(\d+)/cast')) =>
      '/tmdb/series/cast',
    (String x) when x.contains(RegExp(r'/home/series/(\d+)/crew')) =>
      '/tmdb/series/crew',
    (String x) when x.contains(RegExp(r'/home/series/(\d+)/reviews')) =>
      '/tmdb/series/reviews',
    (String x) when x.contains(RegExp(r'/home/series/(\d+)/similar')) =>
      '/tmdb/series/similar',
    (String x) when x.contains(RegExp(r'/search/series/genres/\d+$')) =>
      '/tmdb/series/genres',

    // People
    (String x) when x.contains(RegExp(r'/person/\d+$')) =>
      '/tmdb/person/details',
    _ => path,
  };

  return resolvedPath;
}

extension IdExtraction on go.GoRouterState {
  int? movieId() {
    final id = RegExp(r'/movie/(\d+)').firstMatch(matchedLocation)?.group(1);

    return id == null ? null : int.tryParse(id);
  }

  MovieListType? movieListType() {
    final name = RegExp(r'/movie/(\w+)').firstMatch(matchedLocation)?.group(1);

    return name == null
        ? null
        : MovieListType.values.firstWhereOrNull((x) => x.name == name);
  }

  SeriesListType? seriesListType() {
    final name = RegExp(r'/series/(\w+)').firstMatch(matchedLocation)?.group(1);

    return name == null
        ? null
        : SeriesListType.values.firstWhereOrNull((x) => x.name == name);
  }

  int? seriesId() {
    final id = RegExp(r'/series/(\d+)').firstMatch(matchedLocation)?.group(1);

    return id == null ? null : int.tryParse(id);
  }

  int? personId() {
    final id = RegExp(r'/person/(\d+)').firstMatch(matchedLocation)?.group(1);

    return id == null ? null : int.tryParse(id);
  }

  int? genreId() {
    final id = RegExp(r'/genres/(\d+)').firstMatch(matchedLocation)?.group(1);

    return id == null ? null : int.tryParse(id);
  }
}

final class TmdbPath {
  static movieDetails(int id) => '/tmdb/home/movie/$id';
  static seriesDetails(int id) => '/tmdb/home/series/$id';

  static movieCastList(int id) => '/tmdb/home/movie/$id/cast';
  static seriesCastList(int id) => '/tmdb/home/series/$id/cast';

  static movieCrewList(int id) => '/tmdb/home/movie/$id/crew';
  static seriesCrewList(int id) => '/tmdb/home/series/$id/crew';

  static movieReviewsList(int id) => '/tmdb/home/movie/$id/reviews';
  static seriesReviewsList(int id) => '/tmdb/home/series/$id/reviews';

  static movieRecommendationList(int id) => '/tmdb/home/movie/$id/similar';
  static seriesRecommendationList(int id) => '/tmdb/home/series/$id/similar';

  static movieList(MovieListType type) => '/tmdb/home/movie/${type.name}';
  static seriesList(SeriesListType type) => '/tmdb/home/series/${type.name}';

  static seriesGenres(int id) => '/tmdb/search/series/genres/$id';
  static movieGenres(int id) => '/tmdb/search/movie/genres/$id';

  static watchlist() => '/tmdb/watchlist';
  static personDetails(int id) => '/tmdb/person/$id';
  static movie() => '/tmdb/movie';
  static series() => '/tmdb/series';
}
