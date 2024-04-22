// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditional.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conditional _$ConditionalFromJson(Map<String, dynamic> json) => Conditional(
      cases: (json['cases'] as List<dynamic>?)
              ?.map((e) =>
                  CaseItem<SchemaItem>.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      condition: json['condition'] == null
          ? null
          : Condition.fromJson(json['condition'] as Map<String, dynamic>),
      defaultCase: json['defaultCase'] as String?,
    );

CaseItem<T> _$CaseItemFromJson<T extends SchemaItem>(
        Map<String, dynamic> json) =>
    CaseItem<T>(
      value: json['value'] as String?,
      item: typeFromFirstOfListJson(json['item']),
    );
