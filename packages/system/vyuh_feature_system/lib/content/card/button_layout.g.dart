// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ButtonCardLayout _$ButtonCardLayoutFromJson(Map<String, dynamic> json) =>
    ButtonCardLayout(
      buttonType:
          $enumDecodeNullable(_$ButtonTypeEnumMap, json['buttonType']) ??
              ButtonType.filled,
      isStretched: json['isStretched'] as bool? ?? false,
    );

const _$ButtonTypeEnumMap = {
  ButtonType.filled: 'filled',
  ButtonType.outlined: 'outlined',
  ButtonType.text: 'text',
};
