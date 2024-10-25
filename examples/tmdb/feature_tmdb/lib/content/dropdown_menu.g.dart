// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropdown_menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DropDownMenu _$DropDownMenuFromJson(Map<String, dynamic> json) => DropDownMenu(
      items: (json['items'] as List<dynamic>)
          .map((e) => DropDownItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      label: json['label'] as String? ?? '',
      selectionChanged: json['selectionChanged'] == null
          ? null
          : Action.fromJson(json['selectionChanged'] as Map<String, dynamic>),
    );

DropDownItem _$DropDownItemFromJson(Map<String, dynamic> json) => DropDownItem(
      title: json['title'] as String? ?? '',
      value: json['value'] as String,
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
    );
