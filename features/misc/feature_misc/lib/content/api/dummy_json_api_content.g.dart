// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dummy_json_api_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DummyJsonApiConfiguration _$DummyJsonApiConfigurationFromJson(
        Map<String, dynamic> json) =>
    DummyJsonApiConfiguration(
      type: $enumDecode(_$DummyJsonProductApiTypeEnumMap, json['type']),
      searchText: json['searchText'] as String?,
      limit: (json['limit'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
    );

const _$DummyJsonProductApiTypeEnumMap = {
  DummyJsonProductApiType.products: 'products',
  DummyJsonProductApiType.search: 'search',
};
