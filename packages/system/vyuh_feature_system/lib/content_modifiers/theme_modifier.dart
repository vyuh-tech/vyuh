import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/service/theme_service.dart';

part 'theme_modifier.g.dart';

@JsonSerializable()
final class ThemeModifier extends ContentModifierConfiguration {
  static const schemaName = 'vyuh.content.modifier.theme';

  static final typeDescriptor = TypeDescriptor(
    fromJson: ThemeModifier.fromJson,
    schemaType: schemaName,
    title: 'Theme Modifier',
  );

  final ThemeMode mode;

  ThemeModifier({this.mode = ThemeMode.light}) : super(schemaType: schemaName);

  factory ThemeModifier.fromJson(Map<String, dynamic> json) =>
      _$ThemeModifierFromJson(json);

  @override
  Widget build(BuildContext context, Widget child, ContentItem content) {
    final service = vyuh.di.get<ThemeService>();
    final themeData = service.theme(mode);

    return themeData != null ? Theme(data: themeData, child: child) : child;
  }
}
