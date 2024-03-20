// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialogRouteLayout _$DialogRouteLayoutFromJson(Map<String, dynamic> json) =>
    DialogRouteLayout(
      dialogType:
          $enumDecodeNullable(_$DialogTypeEnumMap, json['dialogType']) ??
              DialogType.dialog,
    );

const _$DialogTypeEnumMap = {
  DialogType.modalBottomSheet: 'modalBottomSheet',
  DialogType.dialog: 'dialog',
};
