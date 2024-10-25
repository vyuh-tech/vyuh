import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:tmdb_client/util.dart';

part 'movie.g.dart';

@JsonSerializable()
final class Movie extends FeaturedShow {
  final String title;
  @JsonKey(name: 'release_date', fromJson: dateTimeFromJson)
  final DateTime? releaseDate;

  final int? budget;
  final int? runtime;
  final int? revenue;
  final String? homepage;

  Movie({
    required super.id,
    required this.title,
    required super.overview,
    required super.posterImage,
    super.backdropImage,
    required this.releaseDate,
    super.voteAverage,
    super.voteCount,
    super.tagline,
    required this.budget,
    required this.runtime,
    required this.revenue,
    required super.popularity,
    required this.homepage,
    required super.status,
    super.genres,
    required super.adult,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  shortInfo() => MovieShortInfo(
        id: id,
        title: title,
        overview: overview,
        posterImage: posterImage,
        releaseDate: releaseDate,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );
}

@JsonSerializable()
final class MovieShortInfo extends ShortInfo {
  @override
  @JsonKey(name: 'title')
  final String title;

  @override
  @JsonKey(name: 'release_date', fromJson: dateTimeFromJson)
  final DateTime? releaseDate;

  MovieShortInfo({
    required super.id,
    required this.title,
    required super.overview,
    required super.posterImage,
    super.backdropImage,
    required this.releaseDate,
    super.voteAverage,
    super.voteCount,
  });

  factory MovieShortInfo.fromJson(Map<String, dynamic> json) =>
      _$MovieShortInfoFromJson(json);
}
