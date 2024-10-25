// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterImage: posterImageFromPath(json['poster_path'] as String?),
      backdropImage: backdropImageFromPath(json['backdrop_path'] as String?),
      releaseDate: dateTimeFromJson(json['release_date'] as String?),
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
      tagline: json['tagline'] as String?,
      budget: (json['budget'] as num?)?.toInt(),
      runtime: (json['runtime'] as num?)?.toInt(),
      revenue: (json['revenue'] as num?)?.toInt(),
      popularity: (json['popularity'] as num).toDouble(),
      homepage: json['homepage'] as String?,
      status: json['status'] as String?,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      adult: json['adult'] as bool,
    );

MovieShortInfo _$MovieShortInfoFromJson(Map<String, dynamic> json) =>
    MovieShortInfo(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterImage: posterImageFromPath(json['poster_path'] as String?),
      backdropImage: backdropImageFromPath(json['backdrop_path'] as String?),
      releaseDate: dateTimeFromJson(json['release_date'] as String?),
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
    );
