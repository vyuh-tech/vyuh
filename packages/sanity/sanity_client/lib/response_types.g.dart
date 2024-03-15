// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SanityDataset _$SanityDatasetFromJson(Map<String, dynamic> json) =>
    SanityDataset(
      name: json['name'] as String,
      aclMode: json['aclMode'] as String,
    );

ServerResponse _$ServerResponseFromJson(Map<String, dynamic> json) =>
    ServerResponse(
      result: json['result'] as Map<String, dynamic>?,
      ms: json['ms'] as int,
      query: json['query'] as String,
    );
