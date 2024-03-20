// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageRouteType _$PageRouteTypeFromJson(Map<String, dynamic> json) =>
    PageRouteType(
      behavior: $enumDecodeNullable(_$PageBehaviorEnumMap, json['behavior']) ??
          PageBehavior.material,
    );

const _$PageBehaviorEnumMap = {
  PageBehavior.material: 'material',
  PageBehavior.cupertino: 'cupertino',
};

DialogRouteType _$DialogRouteTypeFromJson(Map<String, dynamic> json) =>
    DialogRouteType(
      behavior:
          $enumDecodeNullable(_$DialogBehaviorEnumMap, json['behavior']) ??
              DialogBehavior.modalBottomSheet,
    );

const _$DialogBehaviorEnumMap = {
  DialogBehavior.modalBottomSheet: 'modalBottomSheet',
  DialogBehavior.fullscreen: 'fullscreen',
};
