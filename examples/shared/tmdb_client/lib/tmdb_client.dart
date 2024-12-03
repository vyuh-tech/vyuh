library;

import 'package:tmdb_client/search_api.dart';
import 'package:tmdb_client/tmdb_client.dart';

export 'package:tmdb_client/model/base.dart';
export 'package:tmdb_client/model/genre.dart';
export 'package:tmdb_client/model/image.dart';
export 'package:tmdb_client/model/movie.dart';
export 'package:tmdb_client/model/person.dart';
export 'package:tmdb_client/model/review.dart';
export 'package:tmdb_client/model/series.dart';
export 'package:tmdb_client/model/trailer.dart';
export 'package:tmdb_client/movies_api.dart';
export 'package:tmdb_client/person_api.dart';
export 'package:tmdb_client/series_api.dart';

final class TMDBClient {
  final String apiKey;

  late final MovieApi movies;
  late final SeriesApi series;
  late final PersonApi persons;
  late final SearchApi search;

  TMDBClient(this.apiKey) {
    movies = MovieApi(apiUrl: _apiUrl);
    series = SeriesApi(apiUrl: _apiUrl);
    persons = PersonApi(apiUrl: _apiUrl);
    search = SearchApi(apiUrl: _apiUrl);
  }

  Uri _apiUrl(String path) {
    final suffix = path.contains('?') ? '&' : '?';
    return Uri.parse(
        'https://api.themoviedb.org/3/$path${suffix}api_key=$apiKey');
  }

  static String? Function(String? value) imageFromJson(
          String imageSizePrefix) =>
      (String? value) {
        if (value == null) {
          return null;
        }

        return 'https://image.tmdb.org/t/p/$imageSizePrefix$value';
      };
}
