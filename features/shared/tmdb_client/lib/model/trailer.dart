import 'package:json_annotation/json_annotation.dart';
part 'trailer.g.dart';

@JsonSerializable()
final class Trailer {
  final String iso_639_1;
  final String iso_3166_1;
  final bool official;
  final String id;

  @JsonKey(name: 'published_at')
  final String publishedAt;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'key')
  final String key;

  @JsonKey(name: 'site')
  final String site;

  @JsonKey(name: 'type')
  final String type;

  Trailer(
      {required this.name,
      required this.key,
      required this.site,
      required this.type,
      required this.iso_639_1,
      required this.iso_3166_1,
      required this.official,
      required this.publishedAt,
      required this.id});

  factory Trailer.fromJson(Map<String, dynamic> json) =>
      _$TrailerFromJson(json);
}
