import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'package:tmdb_client/util.dart';

part 'series.g.dart';

@JsonSerializable()
final class Series extends FeaturedShow {
  final String name;
  @JsonKey(name: 'first_air_date', fromJson: dateTimeFromJson)
  final DateTime? firstAirDate;

  @JsonKey(name: 'number_of_episodes')
  final int? numberOfEpisodes;

  @JsonKey(name: 'number_of_seasons')
  final int? numberOfSeasons;
  final List<Provider> networks;

  Series({
    required super.id,
    required this.name,
    required super.overview,
    required super.posterImage,
    super.backdropImage,
    this.firstAirDate,
    required super.voteAverage,
    required super.voteCount,
    required super.tagline,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required super.popularity,
    required super.status,
    super.genres,
    this.networks = const [],
    required super.adult,
  });

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  SeriesShortInfo shortInfo() => SeriesShortInfo(
        id: id,
        title: name,
        overview: overview,
        posterImage: posterImage,
        releaseDate: firstAirDate,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );
}

@JsonSerializable()
final class Provider {
  final int id;
  final String name;

  @JsonKey(name: 'origin_country')
  final String? originCountry;

  @JsonKey(name: 'logo_path', fromJson: logoImageFromPath)
  final String? logoImage;

  Provider({
    required this.id,
    required this.name,
    this.logoImage,
    this.originCountry,
  });

  factory Provider.fromJson(Map<String, dynamic> json) =>
      _$ProviderFromJson(json);
}

@JsonSerializable()
final class SeriesShortInfo extends ShortInfo {
  @override
  @JsonKey(name: 'first_air_date', fromJson: dateTimeFromJson)
  final DateTime? releaseDate;

  @override
  @JsonKey(name: 'name')
  final String title;

  SeriesShortInfo({
    required super.id,
    required this.title,
    required super.overview,
    required super.posterImage,
    super.backdropImage,
    this.releaseDate,
    required super.voteAverage,
    required super.voteCount,
  });

  factory SeriesShortInfo.fromJson(Map<String, dynamic> json) =>
      _$SeriesShortInfoFromJson(json);
}
