// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelSection _$LevelSectionFromJson(Map<String, dynamic> json) => LevelSection(
      title: json['title'] as String,
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

LevelSectionLayout _$LevelSectionLayoutFromJson(Map<String, dynamic> json) =>
    LevelSectionLayout();
