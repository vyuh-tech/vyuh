// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuAction _$MenuActionFromJson(Map<String, dynamic> json) => MenuAction(
      title: json['title'] as String? ?? '',
      icon: $enumDecodeNullable(_$MenuIconTypeEnumMap, json['icon']) ??
          MenuIconType.home,
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
    );

const _$MenuIconTypeEnumMap = {
  MenuIconType.home: 'home',
  MenuIconType.settings: 'settings',
  MenuIconType.category: 'category',
  MenuIconType.account: 'account',
  MenuIconType.menu: 'menu',
};

DefaultRouteLayout _$DefaultRouteLayoutFromJson(Map<String, dynamic> json) =>
    DefaultRouteLayout(
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => MenuAction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
