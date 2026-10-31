// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageReference _$ImageReferenceFromJson(Map<String, dynamic> json) =>
    ImageReference(
      type: readValue(json, 'type') as String,
      asset: json['asset'] == null
          ? null
          : ObjectReference.fromJson(json['asset'] as Map<String, dynamic>),
      sanityAsset: json['_sanityAsset'] as String?,
    );

FileReference _$FileReferenceFromJson(Map<String, dynamic> json) =>
    FileReference(
      type: readValue(json, 'type') as String,
      asset: json['asset'] == null
          ? null
          : ObjectReference.fromJson(json['asset'] as Map<String, dynamic>),
    );

ObjectReference _$ObjectReferenceFromJson(Map<String, dynamic> json) =>
    ObjectReference(
      type: readValue(json, 'type') as String,
      ref: readValue(json, 'ref') as String,
    );
