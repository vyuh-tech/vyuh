// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditional.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conditional _$ConditionalFromJson(Map<String, dynamic> json) => Conditional(
      cases: (json['cases'] as List<dynamic>?)
              ?.map((e) => CaseItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      condition: json['condition'] == null
          ? null
          : Condition.fromJson(json['condition'] as Map<String, dynamic>),
      defaultCase: json['defaultCase'] as String?,
    );

CaseItem _$CaseItemFromJson(Map<String, dynamic> json) => CaseItem(
      value: json['value'] as String?,
      item: typeFromFirstOfListJson(json['item']),
    );
