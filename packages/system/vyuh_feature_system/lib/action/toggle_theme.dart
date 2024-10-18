import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'toggle_theme.g.dart';

@JsonSerializable()
final class ToggleThemeAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.toggleTheme';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: ToggleThemeAction.fromJson,
    title: 'Toggle Light/Dark Theme',
  );

  ToggleThemeAction({super.isAwaited}) : super(schemaType: schemaName);

  factory ToggleThemeAction.fromJson(Map<String, dynamic> json) =>
      _$ToggleThemeActionFromJson(json);

  @override
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) {
    vyuh.di.get<ThemeService>().toggleTheme();
  }
}
