// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureFlagCondition _$FeatureFlagConditionFromJson(
        Map<String, dynamic> json) =>
    FeatureFlagCondition(
      flagName: json['flagName'] as String? ?? '',
      dataType: $enumDecodeNullable(_$FlagDataTypeEnumMap, json['dataType']) ??
          FlagDataType.string,
    );

const _$FlagDataTypeEnumMap = {
  FlagDataType.string: 'string',
  FlagDataType.number: 'number',
  FlagDataType.boolean: 'boolean',
  FlagDataType.json: 'json',
};
