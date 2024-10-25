// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hint_action_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HintActionText _$HintActionTextFromJson(Map<String, dynamic> json) =>
    HintActionText(
      layout: typeFromFirstOfListJson(json['layout']),
      hint: json['hint'] as String,
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
      alignment: $enumDecodeNullable(
              _$HintActionAlignmentEnumMap, json['alignment']) ??
          HintActionAlignment.center,
    );

const _$HintActionAlignmentEnumMap = {
  HintActionAlignment.start: 'start',
  HintActionAlignment.end: 'end',
  HintActionAlignment.center: 'center',
};

HintActionTextDefaultLayout _$HintActionTextDefaultLayoutFromJson(
        Map<String, dynamic> json) =>
    HintActionTextDefaultLayout();
