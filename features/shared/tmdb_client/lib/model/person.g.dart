// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credits _$CreditsFromJson(Map<String, dynamic> json) => Credits(
      cast: (json['cast'] as List<dynamic>)
          .map((e) => Cast.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>)
          .map((e) => Crew.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Crew _$CrewFromJson(Map<String, dynamic> json) => Crew(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      profileImage: profileImageFromPath(json['profile_path'] as String?),
      knownFor: json['job'] as String,
      knownForDepartment: json['known_for_department'] as String?,
    );

Cast _$CastFromJson(Map<String, dynamic> json) => Cast(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      knownFor: json['character'] as String,
      profileImage: profileImageFromPath(json['profile_path'] as String?),
      knownForDepartment: json['known_for_department'] as String?,
    );
