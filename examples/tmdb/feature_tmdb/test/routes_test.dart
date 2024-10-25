import 'package:feature_tmdb/content/enums/config_enum.dart';
import 'package:feature_tmdb/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'routes_test.mocks.dart';

@GenerateMocks([go.GoRouterState])
void main() {
  group('once function tests', () {
    test('once function should only execute the main function once', () {
      int counter = 0;
      final testOnce = once<int>(
        () {
          counter++;
          return counter;
        },
        () => 0,
      );

      expect(testOnce(), equals(1));
      expect(testOnce(), equals(0));
      expect(testOnce(), equals(0));
      expect(counter, equals(1));
    });

    test('personRoute should return the correct route only once', () {
      final personRoute = once<List<CMSRoute>>(
        () => [
          CMSRoute(
            path: '/tmdb/person/:path(.*)',
            cmsPathResolver: mediaPathResolver,
          ),
        ],
        () => [],
      );

      // First call should return the route
      final firstCall = personRoute();
      expect(firstCall.length, equals(1));
      expect(firstCall[0].path, equals('/tmdb/person/:path(.*)'));
      expect(firstCall[0].cmsPathResolver, equals(mediaPathResolver));

      // Subsequent calls should return an empty list
      expect(personRoute(), isEmpty);
      expect(personRoute(), isEmpty);
    });
  });

  group('mediaPathResolver', () {
    test('resolves movie list paths', () {
      expect(
        mediaPathResolver('/home/movie/popular'),
        equals('/tmdb/movie/list'),
      );
      expect(
        mediaPathResolver(
          '/home/movie/upcoming',
        ),
        equals('/tmdb/movie/list'),
      );
      expect(
        mediaPathResolver('/home/movie/topRated'),
        equals('/tmdb/movie/list'),
      );
      expect(
        mediaPathResolver('/home/movie/nowPlaying'),
        equals('/tmdb/movie/list'),
      );
      expect(
        mediaPathResolver('/home/movie/trendingToday'),
        equals('/tmdb/movie/list'),
      );
      expect(
        mediaPathResolver('/home/movie/trendingThisWeek'),
        equals('/tmdb/movie/list'),
      );
    });

    test('resolves movie detail paths', () {
      expect(
        mediaPathResolver('/home/movie/123'),
        equals('/tmdb/movie/details'),
      );
      expect(
        mediaPathResolver('/home/movie/456/cast'),
        equals('/tmdb/movie/cast'),
      );
      expect(
        mediaPathResolver('/home/movie/789/crew'),
        equals('/tmdb/movie/crew'),
      );
      expect(
        mediaPathResolver('/home/movie/101112/reviews'),
        equals('/tmdb/movie/reviews'),
      );
      expect(
        mediaPathResolver('/home/movie/131415/similar'),
        equals('/tmdb/movie/similar'),
      );
    });

    test('resolves movie genre search path', () {
      expect(
        mediaPathResolver('/search/movie/genres/28'),
        equals('/tmdb/movie/genres'),
      );
    });

    test('resolves series list paths', () {
      expect(
        mediaPathResolver('/home/series/airingToday'),
        equals('/tmdb/series/list'),
      );
      expect(
        mediaPathResolver('/home/series/popular'),
        equals('/tmdb/series/list'),
      );
      expect(
        mediaPathResolver('/home/series/topRated'),
        equals('/tmdb/series/list'),
      );
      expect(
        mediaPathResolver('/home/series/trendingToday'),
        equals('/tmdb/series/list'),
      );
      expect(
        mediaPathResolver('/home/series/trendingThisWeek'),
        equals('/tmdb/series/list'),
      );
    });

    test('resolves series detail paths', () {
      expect(
        mediaPathResolver('/home/series/123'),
        equals('/tmdb/series/details'),
      );
      expect(
        mediaPathResolver('/home/series/456/cast'),
        equals('/tmdb/series/cast'),
      );
      expect(
        mediaPathResolver('/home/series/789/crew'),
        equals('/tmdb/series/crew'),
      );
      expect(
        mediaPathResolver('/home/series/101112/reviews'),
        equals('/tmdb/series/reviews'),
      );
      expect(
        mediaPathResolver('/home/series/131415/similar'),
        equals('/tmdb/series/similar'),
      );
    });

    test('resolves series genre search path', () {
      expect(
        mediaPathResolver('/search/series/genres/18'),
        equals('/tmdb/series/genres'),
      );
    });

    test('resolves person detail path', () {
      expect(mediaPathResolver('/person/123'), equals('/tmdb/person/details'));
    });

    test('returns original path for unmatched cases', () {
      expect(
        mediaPathResolver('/some/random/path'),
        equals('/some/random/path'),
      );
    });
  });

  group('IdExtraction', () {
    late MockGoRouterState mockState;

    setUp(() {
      mockState = MockGoRouterState();
    });

    test('movieId extracts correct ID', () {
      when(mockState.matchedLocation).thenReturn('/movie/123');
      expect(mockState.movieId(), 123);

      when(mockState.matchedLocation).thenReturn('/movie/abc');
      expect(mockState.movieId(), null);

      when(mockState.matchedLocation).thenReturn('/series/123');
      expect(mockState.movieId(), null);
    });

    test('movieListType extracts correct type', () {
      when(mockState.matchedLocation).thenReturn('/movie/popular');
      expect(mockState.movieListType(), MovieListType.popular);

      when(mockState.matchedLocation).thenReturn('/movie/topRated');
      expect(mockState.movieListType(), MovieListType.topRated);

      when(mockState.matchedLocation).thenReturn('/movie/unknown');
      expect(mockState.movieListType(), null);
    });

    test('seriesListType extracts correct type', () {
      when(mockState.matchedLocation).thenReturn('/series/popular');
      expect(mockState.seriesListType(), SeriesListType.popular);

      when(mockState.matchedLocation).thenReturn('/series/topRated');
      expect(mockState.seriesListType(), SeriesListType.topRated);

      when(mockState.matchedLocation).thenReturn('/series/unknown');
      expect(mockState.seriesListType(), null);
    });

    test('seriesId extracts correct ID', () {
      when(mockState.matchedLocation).thenReturn('/series/456');
      expect(mockState.seriesId(), 456);

      when(mockState.matchedLocation).thenReturn('/series/abc');
      expect(mockState.seriesId(), null);

      when(mockState.matchedLocation).thenReturn('/movie/456');
      expect(mockState.seriesId(), null);
    });

    test('personId extracts correct ID', () {
      when(mockState.matchedLocation).thenReturn('/person/789');
      expect(mockState.personId(), 789);

      when(mockState.matchedLocation).thenReturn('/person/abc');
      expect(mockState.personId(), null);

      when(mockState.matchedLocation).thenReturn('/movie/789');
      expect(mockState.personId(), null);
    });

    test('genreId extracts correct ID', () {
      when(mockState.matchedLocation).thenReturn('/genres/101');
      expect(mockState.genreId(), 101);

      when(mockState.matchedLocation).thenReturn('/genres/abc');
      expect(mockState.genreId(), null);

      when(mockState.matchedLocation).thenReturn('/movie/101');
      expect(mockState.genreId(), null);
    });
  });

  group('TmdbPath', () {
    test('movieDetails returns correct path', () {
      expect(TmdbPath.movieDetails(123), '/tmdb/home/movie/123');
    });

    test('seriesDetails returns correct path', () {
      expect(TmdbPath.seriesDetails(456), '/tmdb/home/series/456');
    });

    test('movieCastList returns correct path', () {
      expect(TmdbPath.movieCastList(789), '/tmdb/home/movie/789/cast');
    });

    test('seriesCastList returns correct path', () {
      expect(TmdbPath.seriesCastList(101), '/tmdb/home/series/101/cast');
    });

    test('movieCrewList returns correct path', () {
      expect(TmdbPath.movieCrewList(112), '/tmdb/home/movie/112/crew');
    });

    test('seriesCrewList returns correct path', () {
      expect(TmdbPath.seriesCrewList(131), '/tmdb/home/series/131/crew');
    });

    test('movieReviewsList returns correct path', () {
      expect(TmdbPath.movieReviewsList(415), '/tmdb/home/movie/415/reviews');
    });

    test('seriesReviewsList returns correct path', () {
      expect(TmdbPath.seriesReviewsList(161), '/tmdb/home/series/161/reviews');
    });

    test('movieRecommendationList returns correct path', () {
      expect(
        TmdbPath.movieRecommendationList(718),
        '/tmdb/home/movie/718/similar',
      );
    });

    test('seriesRecommendationList returns correct path', () {
      expect(
        TmdbPath.seriesRecommendationList(192),
        '/tmdb/home/series/192/similar',
      );
    });

    test('movieList returns correct path', () {
      expect(
        TmdbPath.movieList(MovieListType.popular),
        '/tmdb/home/movie/popular',
      );
    });

    test('seriesList returns correct path', () {
      expect(
        TmdbPath.seriesList(SeriesListType.popular),
        '/tmdb/home/series/popular',
      );
    });

    test('seriesGenres returns correct path', () {
      expect(TmdbPath.seriesGenres(28), '/tmdb/search/series/genres/28');
    });

    test('movieGenres returns correct path', () {
      expect(TmdbPath.movieGenres(35), '/tmdb/search/movie/genres/35');
    });

    test('watchlist returns correct path', () {
      expect(TmdbPath.watchlist(), '/tmdb/watchlist');
    });

    test('personDetails returns correct path', () {
      expect(TmdbPath.personDetails(500), '/tmdb/person/500');
    });

    test('movie returns correct path', () {
      expect(TmdbPath.movie(), '/tmdb/movie');
    });

    test('series returns correct path', () {
      expect(TmdbPath.series(), '/tmdb/series');
    });
  });
}
