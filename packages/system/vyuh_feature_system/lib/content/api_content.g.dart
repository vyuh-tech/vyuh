// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIContent _$APIContentFromJson(Map<String, dynamic> json) => APIContent(
      showError: json['showError'] as bool? ?? kDebugMode,
      showPending: json['showPending'] as bool? ?? true,
      configuration: typeFromFirstOfListJson(json['configuration']),
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
