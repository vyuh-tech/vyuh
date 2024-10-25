// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListResponse<TResult> _$ListResponseFromJson<TResult>(
  Map<String, dynamic> json,
  TResult Function(Object? json) fromJsonTResult,
) =>
    ListResponse<TResult>(
      page: (json['page'] as num?)?.toInt(),
      results:
          (json['results'] as List<dynamic>?)?.map(fromJsonTResult).toList() ??
              [],
      totalResults: (json['total_results'] as num?)?.toInt(),
      totalPages: (json['total_pages'] as num?)?.toInt(),
    );
