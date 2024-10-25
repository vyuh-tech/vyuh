import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';

enum ListRepresentation {
  short,
  long,
}

enum ConfigsSectionType {
  carousel,
  listType,
}

enum MovieListType {
  popular,

  upcoming,

  topRated,

  nowPlaying,

  @JsonValue('trending.day')
  trendingToday,

  @JsonValue('trending.week')
  trendingThisWeek,

  bySelectedGenre,

  bySelectedList;

  String get cacheKey => switch (this) {
        MovieListType.popular ||
        MovieListType.upcoming ||
        MovieListType.nowPlaying ||
        MovieListType.topRated ||
        MovieListType.trendingToday ||
        MovieListType.trendingThisWeek =>
          'movies.$name',

        // This should not be used directly.
        // It is purely to detect the user-selected list, which should be resolved outside
        MovieListType.bySelectedGenre => MovieListType.popular.cacheKey,
        MovieListType.bySelectedList => MovieListType.popular.cacheKey,
      };

  Future<ListResponse<MovieShortInfo>> listApi(TMDBClient client) =>
      switch (this) {
        MovieListType.popular => client.movies.list.popular(),
        MovieListType.upcoming => client.movies.list.upcoming(),
        MovieListType.topRated => client.movies.list.topRated(),
        MovieListType.nowPlaying => client.movies.list.nowPlaying(),
        MovieListType.trendingToday => client.movies.list.trendingToday(),
        MovieListType.trendingThisWeek => client.movies.list.trendingThisWeek(),

        // Do not use directly. This should be resolved outside.
        MovieListType.bySelectedGenre => MovieListType.popular.listApi(client),
        MovieListType.bySelectedList => MovieListType.popular.listApi(client),
      };

  String get title => switch (this) {
        MovieListType.popular => 'Popular Movies',
        MovieListType.upcoming => 'Upcoming Movies',
        MovieListType.topRated => 'Top Rated Movies',
        MovieListType.nowPlaying => 'Now Playing Movies',
        MovieListType.trendingToday => 'Trending Movies Today',
        MovieListType.trendingThisWeek => 'Trending Movies This Week',

        // This should not be used directly.
        MovieListType.bySelectedGenre => MovieListType.popular.title,
        MovieListType.bySelectedList => MovieListType.popular.title,
      };
}

enum SeriesListType {
  airingToday,

  popular,

  topRated,

  @JsonValue('trending.day')
  trendingToday,

  @JsonValue('trending.week')
  trendingThisWeek,

  bySelectedGenre,

  bySelectedList;

  String get cacheKey => switch (this) {
        SeriesListType.popular ||
        SeriesListType.airingToday ||
        SeriesListType.topRated ||
        SeriesListType.trendingToday ||
        SeriesListType.trendingThisWeek =>
          'series.$name',
        SeriesListType.bySelectedGenre => SeriesListType.popular.cacheKey,
        SeriesListType.bySelectedList => SeriesListType.popular.cacheKey,
      };

  Future<ListResponse<SeriesShortInfo>> listApi(TMDBClient client) =>
      switch (this) {
        SeriesListType.popular => client.series.list.popular(),
        SeriesListType.airingToday => client.series.list.airingToday(),
        SeriesListType.topRated => client.series.list.topRated(),
        SeriesListType.trendingToday => client.series.list.trendingToday(),
        SeriesListType.trendingThisWeek =>
          client.series.list.trendingThisWeek(),
        SeriesListType.bySelectedGenre =>
          SeriesListType.popular.listApi(client),
        SeriesListType.bySelectedList => SeriesListType.popular.listApi(client),
      };

  String get title => switch (this) {
        SeriesListType.airingToday => 'Airing Today Series',
        SeriesListType.popular => 'Popular Series',
        SeriesListType.topRated => 'Top Rated Series',
        SeriesListType.trendingToday => 'Trending Series Today',
        SeriesListType.trendingThisWeek => 'Trending Series This Week',
        SeriesListType.bySelectedGenre => SeriesListType.popular.title,
        SeriesListType.bySelectedList => SeriesListType.popular.title,
      };
}
