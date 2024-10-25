import 'package:collection/collection.dart';
import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';

enum BrowseMode { movies, series }

extension BrowseModeExt on BrowseMode {
  get isMovieMode => this == BrowseMode.movies;

  int? selectedId(BuildContext context) => isMovieMode
      ? GoRouterState.of(context).movieId()
      : GoRouterState.of(context).seriesId();
}

final class TMDBStore {
  final watchlist = ObservableList<ShortInfo>();
  final mode = Observable<BrowseMode>(BrowseMode.movies);

  final _futures = <String, ObservableFuture<dynamic>>{};

  ObservableFuture<dynamic>? getFuture(String key) {
    return _futures[key];
  }

  selectMovie(int id) {
    final client = vyuh.di.get<TMDBClient>();

    _fetchMovieInfo(
      id,
      '$id.movie',
      (id) => client.movies.details(id),
    );
    _fetchMovieInfo(
      id,
      '$id.movie.credits'.toString(),
      (id) => client.movies.credits(id),
    );
    _fetchMovieInfo(
      id,
      '$id.movie.images'.toString(),
      (id) => client.movies.images(id),
    );
    _fetchMovieInfo(
      id,
      '$id.movie.recommendations'.toString(),
      (id) => client.movies.recommendations(id),
    );
    _fetchMovieInfo(
      id,
      '$id.movie.reviews'.toString(),
      (id) => client.movies.reviews(id),
    );
    _fetchMovieInfo(
      id,
      '$id.movie.trailer'.toString(),
      (id) => client.movies.trailer(id),
    );
  }

  ObservableFuture<ListResponse<MovieShortInfo>> fetchMovieList(
    MovieListType listType, {
    int? genreId,
  }) {
    assert(
      listType != MovieListType.bySelectedList,
      'Invalid list type: $listType. This should be resolved to one of other values in the list.',
    );

    final client = vyuh.di.get<TMDBClient>();

    if (listType == MovieListType.bySelectedGenre) {
      return client.movies.list.byGenres([genreId.toString()]).asObservable();
    }
    final key = listType.cacheKey;

    if (_futures.containsKey(key) == false) {
      _futures[key] = listType.listApi(client).asObservable();
    }

    return _futures[key] as ObservableFuture<ListResponse<MovieShortInfo>>;
  }

  get isMoviesMode => mode.value == BrowseMode.movies;

  void toggleBrowseMode() {
    runInAction(() {
      mode.value = mode.value == BrowseMode.movies
          ? BrowseMode.series
          : BrowseMode.movies;
    });
  }

  selectSeries(int id) {
    final client = vyuh.di.get<TMDBClient>();

    _fetchSeriesInfo(
      id,
      '$id.series',
      (id) => client.series.details(id),
    );
    _fetchSeriesInfo(
      id,
      '$id.series.credits'.toString(),
      (id) => client.series.credits(id),
    );
    _fetchSeriesInfo(
      id,
      '$id.series.images'.toString(),
      (id) => client.series.images(id),
    );
    _fetchSeriesInfo(
      id,
      '$id.series.recommendations'.toString(),
      (id) => client.series.recommendations(id),
    );
    _fetchSeriesInfo(
      id,
      '$id.series.reviews'.toString(),
      (id) => client.series.reviews(id),
    );
    _fetchSeriesInfo(
      id,
      '$id.series.trailer'.toString(),
      (id) => client.series.trailer(id),
    );
  }

  ObservableFuture<ListResponse<SeriesShortInfo>> fetchSeriesList(
    SeriesListType listType, {
    int? genreId,
  }) {
    assert(
      listType != SeriesListType.bySelectedList,
      'Invalid list type: $listType. This should be resolved to one of other values in the list.',
    );

    final client = vyuh.di.get<TMDBClient>();

    if (listType == SeriesListType.bySelectedGenre) {
      return client.series.list.byGenres([genreId.toString()]).asObservable();
    }

    final key = listType.cacheKey;

    if (_futures.containsKey(key) == false) {
      _futures[key] = listType.listApi(client).asObservable();
    }

    return _futures[key] as ObservableFuture<ListResponse<SeriesShortInfo>>;
  }

  _fetchMovieInfo(
    int id,
    String key,
    Future<dynamic> Function(int id) fetch,
  ) async {
    if (_futures.containsKey(key)) {
      return;
    }

    final future = fetch(id);
    _futures[key] = future.asObservable();
  }

  _fetchSeriesInfo(
    int id,
    String key,
    Future<dynamic> Function(int id) fetch,
  ) async {
    if (_futures.containsKey(key)) {
      return;
    }

    final future = fetch(id);
    _futures[key] = future.asObservable();
  }

  void selectPerson(int id) {
    final client = vyuh.di.get<TMDBClient>();

    _fetchPersonInfo(id, '$id.person', (id) => client.persons.details(id));
    _fetchPersonInfo(
      id,
      '$id.person.credits.movie'.toString(),
      (id) => client.persons.movieCredits(id),
    );
    _fetchPersonInfo(
      id,
      '$id.person.credits.tv'.toString(),
      (id) => client.persons.tvCredits(id),
    );
  }

  void addToWatchlist(ShortInfo item) {
    runInAction(() {
      // If present in watchlist, do not add again
      if (watchlist.firstWhereOrNull((x) => x.id == item.id) != null) {
        return;
      }

      watchlist.add(item);
    });
  }

  _fetchPersonInfo(
    int id,
    String key,
    Future<dynamic> Function(int id) fetch,
  ) async {
    if (_futures.containsKey(key)) {
      return;
    }

    final future = fetch(id);
    _futures[key] = future.asObservable();
  }
}
