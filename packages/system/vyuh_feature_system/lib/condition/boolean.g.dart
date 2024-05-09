// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boolean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooleanCondition _$BooleanConditionFromJson(Map<String, dynamic> json) =>
    BooleanCondition(
      value: json['value'] as bool? ?? false,
      evaluationDelayInSeconds:
          (json['evaluationDelayInSeconds'] as num?)?.toInt() ?? 0,
    );
