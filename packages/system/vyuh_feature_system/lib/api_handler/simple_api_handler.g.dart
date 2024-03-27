// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_api_handler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplayFieldMap _$DisplayFieldMapFromJson(Map<String, dynamic> json) =>
    DisplayFieldMap(
      title: json['title'] == null ? null : JSONPath.fromJson(json['title']),
      description: json['description'] == null
          ? null
          : JSONPath.fromJson(json['description']),
      imageUrl:
          json['imageUrl'] == null ? null : JSONPath.fromJson(json['imageUrl']),
    );

SimpleAPIHandler _$SimpleAPIHandlerFromJson(Map<String, dynamic> json) =>
    SimpleAPIHandler(
      title: json['title'] as String?,
      url: json['url'] as String? ?? '',
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      requestBody: (json['requestBody'] as List<dynamic>?)
          ?.map((e) => _$recordConvert(
                e,
                ($jsonValue) => (
                  $jsonValue[r'$1'] as String,
                  $jsonValue[r'$2'] as String,
                ),
              ))
          .toList(),
      rootField: json['rootField'] == null
          ? const JSONPath(r'$')
          : JSONPath.fromJson(json['rootField']),
      fieldMap: json['fieldMap'] == null
          ? null
          : DisplayFieldMap.fromJson(json['fieldMap'] as Map<String, dynamic>),
    );

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);
