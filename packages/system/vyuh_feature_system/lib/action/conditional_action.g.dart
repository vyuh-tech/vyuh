// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conditional_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConditionalAction _$ConditionalActionFromJson(Map<String, dynamic> json) =>
    ConditionalAction(
      cases: (json['cases'] as List<dynamic>?)
              ?.map((e) => ActionCase.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      condition: json['condition'] == null
          ? null
          : Condition.fromJson(json['condition'] as Map<String, dynamic>),
      defaultCase: json['defaultCase'] as String?,
      isAwaited: json['isAwaited'] as bool? ?? false,
    );

ActionCase _$ActionCaseFromJson(Map<String, dynamic> json) => ActionCase(
      value: json['value'] as String?,
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
    );
