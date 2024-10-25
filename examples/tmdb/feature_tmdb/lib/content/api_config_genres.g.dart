// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_config_genres.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiConfigGenreSelection _$ApiConfigGenreSelectionFromJson(
        Map<String, dynamic> json) =>
    ApiConfigGenreSelection(
      allowModeToggle: json['allowModeToggle'] as bool? ?? false,
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
    );
