import 'dart:convert';

import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class MovieApi {
  final ApiUrlBuilder apiUrl;
  final MovieListApi list;

  MovieApi({required this.apiUrl}) : list = MovieListApi(apiUrl: apiUrl);

  Future<GenresListResponse> genres() async {
    final response = await vyuh.network.get(apiUrl('genre/movie/list'));

    final data = jsonDecode(response.body);
    return GenresListResponse.fromJson(data);
  }

  Future<ListResponse<MovieShortInfo>> listByGenres(List<String> genres) async {
    final queryParams = [
      'with_genres=${genres.join(',')}',
      'include_adult=false',
      'include_video=false',
      'language=en-US',
      'page=1',
      'sort_by=popularity.desc',
    ].join('&');
    final response =
        await vyuh.network.get(apiUrl('discover/movie?$queryParams'));

    final data = jsonDecode(response.body);
    return ListResponse<MovieShortInfo>.fromJson(data);
  }

  Future<Movie> details(int movieId) async {
    final response = await vyuh.network.get(apiUrl('movie/$movieId'));

    final data = jsonDecode(response.body);
    return Movie.fromJson(data);
  }

  Future<Credits> credits(int movieId) async {
    final response = await vyuh.network.get(apiUrl('movie/$movieId/credits'));

    final data = jsonDecode(response.body);
    return Credits.fromJson(data);
  }

  Future<TMDBImageSet> images(int movieId) async {
    final response = await vyuh.network.get(apiUrl('movie/$movieId/images'));

    final data = jsonDecode(response.body);
    return TMDBImageSet.fromJson(data);
  }

  Future<ListResponse<Review>> reviews(int movieId) async {
    final response = await vyuh.network.get(apiUrl('movie/$movieId/reviews'));

    final data = jsonDecode(response.body);
    return ListResponse<Review>.fromJson(data);
  }

  Future<ListResponse<Trailer>> trailer(int movieId) async {
    final response = await vyuh.network.get(apiUrl('movie/$movieId/videos'));
    final data = jsonDecode(response.body);

    return ListResponse<Trailer>.fromJson(data);
  }

  Future<ListResponse<MovieShortInfo>> recommendations(int movieId) async {
    final response =
        await vyuh.network.get(apiUrl('movie/$movieId/recommendations'));

    final data = jsonDecode(response.body);
    return ListResponse<MovieShortInfo>.fromJson(data);
  }
}

final class MovieListApi {
  final ApiUrlBuilder apiUrl;

  MovieListApi({required this.apiUrl});

  Future<ListResponse<MovieShortInfo>> popular() => _list('movie/popular');
  Future<ListResponse<MovieShortInfo>> topRated() => _list('movie/top_rated');
  Future<ListResponse<MovieShortInfo>> upcoming() => _list('movie/upcoming');
  Future<ListResponse<MovieShortInfo>> nowPlaying() =>
      _list('movie/now_playing');
  Future<ListResponse<MovieShortInfo>> trendingToday() =>
      _list('trending/movie/day');
  Future<ListResponse<MovieShortInfo>> trendingThisWeek() =>
      _list('trending/movie/week');
  Future<ListResponse<MovieShortInfo>> byGenres(List<String>? genreIds) {
    final query = genreIds != null && genreIds.isNotEmpty
        ? '?with_genres=${genreIds.join(',')}'
        : '';
    return _list('discover/movie$query');
  }

  Future<ListResponse<MovieShortInfo>> _list(String path) async {
    final response = await vyuh.network.get(apiUrl(path));

    final data = jsonDecode(response.body);
    return ListResponse<MovieShortInfo>.fromJson(data);
  }
}
