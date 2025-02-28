// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveCard _$LiveCardFromJson(Map<String, dynamic> json) => LiveCard(
      document: json['document'] == null
          ? null
          : ObjectReference.fromJson(json['document'] as Map<String, dynamic>),
      includeDrafts: json['includeDrafts'] as bool? ?? false,
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

LiveCardDefaultLayout _$LiveCardDefaultLayoutFromJson(
        Map<String, dynamic> json) =>
    LiveCardDefaultLayout();
