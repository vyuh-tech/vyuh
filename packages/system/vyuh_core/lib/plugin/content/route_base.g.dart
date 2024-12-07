// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      identifier: json['identifier'] as String,
      title: json['title'] as String,
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: Category.modifierList(json['modifiers']),
    );
