import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'toggle_theme.g.dart';

@JsonSerializable()
final class ToggleTheme extends ActionConfiguration {
  static const schemaName = 'tmdb.action.toggleTheme';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: ToggleTheme.fromJson,
    title: 'Toggle Light/Dark Theme',
  );

  ToggleTheme() : super(schemaType: schemaName);

  factory ToggleTheme.fromJson(Map<String, dynamic> json) =>
      _$ToggleThemeFromJson(json);

  @override
  FutureOr<void> execute(BuildContext context) {
    vyuh.di.get<ThemeService>().toggleTheme();
  }
}
