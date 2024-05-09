// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageReference _$ImageReferenceFromJson(Map<String, dynamic> json) =>
    ImageReference(
      asset: json['asset'] == null
          ? null
          : ObjectReference.fromJson(json['asset'] as Map<String, dynamic>),
      sanityAsset: json['_sanityAsset'] as String?,
    );

ObjectReference _$ObjectReferenceFromJson(Map<String, dynamic> json) =>
    ObjectReference(
      type: readValue(json, 'type') as String,
      ref: readValue(json, 'ref') as String,
    );
