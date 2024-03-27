// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIContent _$APIContentFromJson(Map<String, dynamic> json) => APIContent(
      showError: json['showError'] as bool? ?? true,
      showPending: json['showPending'] as bool? ?? true,
      handler: typeFromFirstOfListJson(json['handler']),
    );
