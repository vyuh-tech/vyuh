import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';

part 'base.g.dart';

typedef ApiUrlBuilder = Uri Function(String path);

@JsonSerializable(genericArgumentFactories: true)
final class ListResponse<TResult> {
  final int? page;

  @JsonKey(defaultValue: [])
  final List<TResult> results;

  @JsonKey(name: 'total_results')
  final int? totalResults;

  @JsonKey(name: 'total_pages')
  final int? totalPages;

  ListResponse({
    required this.page,
    required this.results,
    required this.totalResults,
    required this.totalPages,
  });

  factory ListResponse.fromJson(Map<String, dynamic> json) =>
      _$ListResponseFromJson(json, fromResultTypeJson);

  static TResult fromResultTypeJson<TResult>(Object? json) {
    if (json == null || json is! Map<String, dynamic>) {
      throw Exception('Unknown result type');
    }

    if (json.containsKey('media_type')) {
      final mediaType = json['media_type'] as String;
      switch (mediaType) {
        case 'movie':
          return MovieShortInfo.fromJson(json) as TResult;
        case 'tv':
          return SeriesShortInfo.fromJson(json) as TResult;
        case 'person':
          return Person.fromJson(json) as TResult;
        default:
          throw Exception('Unknown media type');
      }
    }

    switch (TResult) {
      case const (Movie):
        return Movie.fromJson(json) as TResult;
      case const (Genre):
        return Genre.fromJson(json) as TResult;
      case const (MovieShortInfo):
        return MovieShortInfo.fromJson(json) as TResult;
      case const (Review):
        return Review.fromJson(json) as TResult;
      case const (SeriesShortInfo):
        return SeriesShortInfo.fromJson(json) as TResult;
      case const (Series):
        return Series.fromJson(json) as TResult;
      case const (Person):
        return Person.fromJson(json) as TResult;
      case const (Trailer):
        return Trailer.fromJson(json) as TResult;
      default:
        throw Exception('Unknown result type');
    }
  }
}

abstract base class FeaturedShow {
  final int id;
  final String overview;
  final bool adult;

  @JsonKey(name: 'poster_path', fromJson: posterImageFromPath)
  final String? posterImage;

  @JsonKey(name: 'backdrop_path', fromJson: backdropImageFromPath)
  final String? backdropImage;

  @JsonKey(name: 'vote_average')
  final double? voteAverage;

  @JsonKey(name: 'vote_count')
  final int? voteCount;

  final double popularity;

  final String? tagline;
  final String? status;
  final List<Genre>? genres;

  FeaturedShow({
    required this.id,
    required this.overview,
    required this.posterImage,
    this.backdropImage,
    this.voteAverage,
    this.voteCount,
    this.tagline,
    required this.popularity,
    required this.status,
    this.genres,
    required this.adult,
  });
}

extension IsMovie on FeaturedShow {
  bool get isMovie => this is Movie;
}

abstract class ShortInfo {
  final int id;
  String get title;
  final String overview;
  DateTime? get releaseDate;

  @JsonKey(name: 'poster_path', fromJson: posterImageFromPath)
  final String? posterImage;

  @JsonKey(name: 'backdrop_path', fromJson: backdropImageFromPath)
  final String? backdropImage;

  @JsonKey(name: 'vote_average')
  final double? voteAverage;

  @JsonKey(name: 'vote_count')
  final int? voteCount;

  ShortInfo({
    required this.id,
    required this.overview,
    required this.posterImage,
    this.backdropImage,
    this.voteAverage,
    this.voteCount,
  });
}
