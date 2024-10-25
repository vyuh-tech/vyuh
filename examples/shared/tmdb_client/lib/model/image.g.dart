// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TMDBImageSet _$TMDBImageSetFromJson(Map<String, dynamic> json) => TMDBImageSet(
      backdrops: (json['backdrops'] as List<dynamic>)
          .map((e) => TMDBImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      posters: (json['posters'] as List<dynamic>)
          .map((e) => TMDBImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

TMDBImage _$TMDBImageFromJson(Map<String, dynamic> json) => TMDBImage(
      path: json['file_path'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble(),
    );
