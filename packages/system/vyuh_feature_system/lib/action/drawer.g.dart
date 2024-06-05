// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrawerAction _$DrawerActionFromJson(Map<String, dynamic> json) => DrawerAction(
      title: json['title'] as String?,
      type: $enumDecode(_$DrawerActionTypeEnumMap, json['type']),
      isEndDrawer: json['isEndDrawer'] as bool? ?? false,
    );

const _$DrawerActionTypeEnumMap = {
  DrawerActionType.open: 'open',
  DrawerActionType.close: 'close',
};
