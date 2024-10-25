import 'package:json_annotation/json_annotation.dart';

part 'genre.g.dart';

@JsonSerializable()
final class GenresListResponse {
  final List<Genre> genres;

  GenresListResponse({required this.genres});

  factory GenresListResponse.fromJson(Map<String, dynamic> json) =>
      _$GenresListResponseFromJson(json);
}

@JsonSerializable()
final class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}
