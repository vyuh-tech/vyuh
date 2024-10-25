import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MovieListType', () {
    test('cacheKey returns correct values', () {
      expect(MovieListType.popular.cacheKey, equals('movies.popular'));
      expect(MovieListType.upcoming.cacheKey, equals('movies.upcoming'));
      expect(MovieListType.bySelectedGenre.cacheKey, equals('movies.popular'));
    });

    test('title returns correct values', () {
      expect(MovieListType.popular.title, equals('Popular Movies'));
      expect(MovieListType.upcoming.title, equals('Upcoming Movies'));
      expect(MovieListType.bySelectedGenre.title, equals('Popular Movies'));
    });
  });

  group('SeriesListType', () {
    test('cacheKey returns correct values', () {
      expect(SeriesListType.popular.cacheKey, equals('series.popular'));
      expect(SeriesListType.airingToday.cacheKey, equals('series.airingToday'));
      expect(SeriesListType.bySelectedGenre.cacheKey, equals('series.popular'));
    });

    test('title returns correct values', () {
      expect(SeriesListType.popular.title, equals('Popular Series'));
      expect(SeriesListType.airingToday.title, equals('Airing Today Series'));
      expect(SeriesListType.bySelectedGenre.title, equals('Popular Series'));
    });
  });
}
