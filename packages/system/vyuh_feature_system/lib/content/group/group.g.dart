// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      title: json['title'] as String?,
      description: json['description'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      layout: typeFromFirstOfListJson(json['layout']),
    );

DefaultGroupLayout _$DefaultGroupLayoutFromJson(Map<String, dynamic> json) =>
    DefaultGroupLayout();
