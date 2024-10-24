import 'dart:convert';

import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class SeriesApi {
  final ApiUrlBuilder apiUrl;
  final SeriesListApi list;

  SeriesApi({required this.apiUrl}) : list = SeriesListApi(apiUrl: apiUrl);

  Future<GenresListResponse> genres() async {
    final response = await vyuh.network.get(apiUrl('genre/tv/list'));

    final data = jsonDecode(response.body);
    return GenresListResponse.fromJson(data);
  }

  Future<Series> details(int seriesId) async {
    // await Future.delayed(const Duration(seconds: 5));
    final response = await vyuh.network.get(apiUrl('tv/$seriesId'));

    final data = jsonDecode(response.body);
    return Series.fromJson(data);
  }

  Future<Credits> credits(int seriesId) async {
    // await Future.delayed(const Duration(seconds: 1000));
    final response = await vyuh.network.get(apiUrl('tv/$seriesId/credits'));

    final data = jsonDecode(response.body);
    return Credits.fromJson(data);
  }

  Future<TMDBImageSet> images(int seriesId) async {
    // await Future.delayed(const Duration(seconds: 1000));
    final response = await vyuh.network.get(apiUrl('tv/$seriesId/images'));

    final data = jsonDecode(response.body);
    return TMDBImageSet.fromJson(data);
  }

  Future<ListResponse<SeriesShortInfo>> recommendations(int seriesId) async {
    // await Future.delayed(const Duration(seconds: 1000));
    final response =
        await vyuh.network.get(apiUrl('tv/$seriesId/recommendations'));

    final data = jsonDecode(response.body);
    return ListResponse<SeriesShortInfo>.fromJson(data);
  }

  Future<ListResponse<Review>> reviews(int seriesId) async {
    // await Future.delayed(const Duration(seconds: 1000));
    final response = await vyuh.network.get(apiUrl('tv/$seriesId/reviews'));

    final data = jsonDecode(response.body);
    return ListResponse<Review>.fromJson(data);
  }

  Future<ListResponse<Trailer>> trailer(int seriesId) async {
    final response = await vyuh.network.get(apiUrl('tv/$seriesId/videos'));
    final data = jsonDecode(response.body);

    return ListResponse<Trailer>.fromJson(data);
  }
}

final class SeriesListApi {
  final ApiUrlBuilder apiUrl;

  SeriesListApi({required this.apiUrl});

  Future<ListResponse<SeriesShortInfo>> airingToday() =>
      _list('tv/airing_today');
  Future<ListResponse<SeriesShortInfo>> popular() => _list('tv/popular');
  Future<ListResponse<SeriesShortInfo>> topRated() => _list('tv/top_rated');
  Future<ListResponse<SeriesShortInfo>> trendingToday() =>
      _list('trending/tv/day');
  Future<ListResponse<SeriesShortInfo>> trendingThisWeek() =>
      _list('trending/tv/week');
  Future<ListResponse<SeriesShortInfo>> byGenres(List<String>? genreIds) {
    final query = genreIds != null && genreIds.isNotEmpty
        ? '?with_genres=${genreIds.join(',')}'
        : '';
    return _list('discover/tv$query');
  }

  Future<ListResponse<SeriesShortInfo>> _list(String path) async {
    final response = await vyuh.network.get(apiUrl(path));

    final data = jsonDecode(response.body);
    return ListResponse<SeriesShortInfo>.fromJson(data);
  }
}
