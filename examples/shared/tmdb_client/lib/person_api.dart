import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:tmdb_client/util.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'person_api.g.dart';

final class PersonApi {
  final ApiUrlBuilder apiUrl;

  PersonApi({required this.apiUrl});

  Future<Person> details(int peopleId) async {
    final response = await vyuh.network.get(apiUrl('person/$peopleId'));

    final data = jsonDecode(response.body);
    return Person.fromJson(data);
  }

  Future<ListResponse<MovieShortInfo>> movieCredits(int peopleId) async {
    final response =
        await vyuh.network.get(apiUrl('person/$peopleId/movie_credits'));

    final data = jsonDecode(response.body);
    final list = List<MovieShortInfo>.from(
        data['cast'].map((x) => MovieShortInfo.fromJson(x)));

    return ListResponse(
        page: 1, results: list, totalResults: list.length, totalPages: 1);
  }

  Future<ListResponse<SeriesShortInfo>> tvCredits(int peopleId) async {
    final response =
        await vyuh.network.get(apiUrl('person/$peopleId/tv_credits'));

    final data = jsonDecode(response.body);
    final list = List<SeriesShortInfo>.from(
        data['cast'].map((x) => SeriesShortInfo.fromJson(x)));

    return ListResponse(
        page: 1, results: list, totalResults: list.length, totalPages: 1);
  }
}

@JsonSerializable()
final class Person extends BasePerson {
  final bool adult;

  @JsonKey(name: 'also_known_as')
  final List<String>? alsoKnownAs;

  @override
  @JsonKey(name: 'profile_path', fromJson: largeProfileImageFromPath)
  final String? profileImage;

  final String? biography;

  @JsonKey(fromJson: dateTimeFromJson)
  final DateTime? birthday;

  @JsonKey(name: 'deathday', fromJson: dateTimeFromJson)
  final DateTime? deathDay;

  final int gender;

  final String? homepage;

  @JsonKey(name: 'imdb_id')
  final String? imdbId;

  @override
  String? get knownFor => super.knownForDepartment;

  @JsonKey(name: 'place_of_birth')
  final String? placeOfBirth;
  final double popularity;

  Person({
    required super.name,
    required super.id,
    required this.adult,
    required this.alsoKnownAs,
    required this.biography,
    required this.birthday,
    required this.deathDay,
    required this.gender,
    required this.homepage,
    required this.imdbId,
    required this.placeOfBirth,
    required this.popularity,
    required this.profileImage,
    super.knownForDepartment,
  }) : super();

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}
