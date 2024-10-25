// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Series _$SeriesFromJson(Map<String, dynamic> json) => Series(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      overview: json['overview'] as String,
      posterImage: posterImageFromPath(json['poster_path'] as String?),
      backdropImage: backdropImageFromPath(json['backdrop_path'] as String?),
      firstAirDate: dateTimeFromJson(json['first_air_date'] as String?),
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
      tagline: json['tagline'] as String?,
      numberOfEpisodes: (json['number_of_episodes'] as num?)?.toInt(),
      numberOfSeasons: (json['number_of_seasons'] as num?)?.toInt(),
      popularity: (json['popularity'] as num).toDouble(),
      status: json['status'] as String?,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      networks: (json['networks'] as List<dynamic>?)
              ?.map((e) => Provider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      adult: json['adult'] as bool,
    );

Provider _$ProviderFromJson(Map<String, dynamic> json) => Provider(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      logoImage: logoImageFromPath(json['logo_path'] as String?),
      originCountry: json['origin_country'] as String?,
    );

SeriesShortInfo _$SeriesShortInfoFromJson(Map<String, dynamic> json) =>
    SeriesShortInfo(
      id: (json['id'] as num).toInt(),
      title: json['name'] as String,
      overview: json['overview'] as String,
      posterImage: posterImageFromPath(json['poster_path'] as String?),
      backdropImage: backdropImageFromPath(json['backdrop_path'] as String?),
      releaseDate: dateTimeFromJson(json['first_air_date'] as String?),
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
    );
