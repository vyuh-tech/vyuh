// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectMenuItem _$SelectMenuItemFromJson(Map<String, dynamic> json) =>
    SelectMenuItem(
      menuItem: json['menuItem'] == null
          ? null
          : ObjectReference.fromJson(json['menuItem'] as Map<String, dynamic>),
      isAwaited: json['isAwaited'] as bool? ?? false,
    );
