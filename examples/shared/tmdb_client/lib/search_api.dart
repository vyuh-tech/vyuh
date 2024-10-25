import 'dart:convert';

import 'package:tmdb_client/tmdb_client.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class SearchApi {
  final ApiUrlBuilder apiUrl;

  SearchApi({required this.apiUrl});

  Future<ListResponse> searchAll(String query) async {
    final response =
        await vyuh.network.get(apiUrl('search/multi?query=$query'));

    final data = jsonDecode(response.body);
    return ListResponse.fromJson(data);
  }

  Future<ListResponse<MovieShortInfo>> searchMovies(String query) async {
    final response =
        await vyuh.network.get(apiUrl('search/movie?query=$query'));

    final data = jsonDecode(response.body);
    return ListResponse<MovieShortInfo>.fromJson(data);
  }

  Future<ListResponse<SeriesShortInfo>> searchSeries(String query) async {
    final response = await vyuh.network.get(apiUrl('search/tv?query=$query'));

    final data = jsonDecode(response.body);
    return ListResponse<SeriesShortInfo>.fromJson(data);
  }

  Future<ListResponse<Person>> searchPersons(String query) async {
    final response =
        await vyuh.network.get(apiUrl('search/person?query=$query'));

    final data = jsonDecode(response.body);
    //added null check for search results page exception
    if (data['results'] == null) {
      return ListResponse<Person>(
          page: 0, results: [], totalResults: 0, totalPages: 0);
    }
    final persons =
        List<Person>.from(data['results'].map((x) => Person.fromJson(x)));

    return ListResponse<Person>(
        page: data['page'],
        results: persons,
        totalResults: data['total_results'],
        totalPages: data['total_pages']);
  }
}
