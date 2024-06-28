// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrawerAction _$DrawerActionFromJson(Map<String, dynamic> json) => DrawerAction(
      title: json['title'] as String?,
      actionType:
          $enumDecodeNullable(_$DrawerActionTypeEnumMap, json['actionType']) ??
              DrawerActionType.open,
      isEndDrawer: json['isEndDrawer'] as bool? ?? false,
    );

const _$DrawerActionTypeEnumMap = {
  DrawerActionType.open: 'open',
  DrawerActionType.close: 'close',
};
