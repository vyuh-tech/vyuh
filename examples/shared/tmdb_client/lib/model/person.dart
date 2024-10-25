import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_client/model/image.dart';

part 'person.g.dart';

@JsonSerializable()
final class Credits {
  final List<Cast> cast;
  final List<Crew> crew;

  Credits({required this.cast, required this.crew});

  factory Credits.fromJson(Map<String, dynamic> json) =>
      _$CreditsFromJson(json);
}

abstract base class BasePerson {
  final String name;

  final int id;

  String? get knownFor;

  String? get profileImage;

  @JsonKey(name: 'known_for_department')
  final String? knownForDepartment;

  BasePerson({
    required this.name,
    required this.id,
    this.knownForDepartment,
  });
}

@JsonSerializable()
final class Crew extends BasePerson {
  @override
  @JsonKey(name: 'job')
  final String knownFor;

  @override
  @JsonKey(name: 'profile_path', fromJson: profileImageFromPath)
  final String? profileImage;

  Crew({
    required super.id,
    required super.name,
    this.profileImage,
    required this.knownFor,
    super.knownForDepartment,
  });

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);
}

@JsonSerializable()
final class Cast extends BasePerson {
  @override
  @JsonKey(name: 'character')
  final String knownFor;

  @override
  @JsonKey(name: 'profile_path', fromJson: profileImageFromPath)
  final String? profileImage;

  Cast({
    required super.id,
    required super.name,
    required this.knownFor,
    this.profileImage,
    super.knownForDepartment,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
}
