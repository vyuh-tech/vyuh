import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'theme_modifier.g.dart';

/// A content modifier that applies theme data to a content subtree.
///
/// Features:
/// * Theme mode specification
/// * Integration with [ThemeService]
/// * Subtree theme overrides
/// * Fallback handling
///
/// Example:
/// ```dart
/// // Apply light theme to content
/// final content = Card(
///   title: 'My Card',
///   modifiers: [
///     ContentModifier(
///       configuration: ThemeModifier(mode: ThemeMode.light),
///     ),
///   ],
/// );
///
/// // Apply dark theme to content
/// final content = Group(
///   items: [myCard, myDivider],
///   modifiers: [
///     ContentModifier(
///       configuration: ThemeModifier(mode: ThemeMode.dark),
///     ),
///   ],
/// );
/// ```
///
/// The modifier:
/// * Gets theme data from [ThemeService]
/// * Wraps content in a [Theme] widget
/// * Falls back to original content if no theme data
/// * Affects all descendants of the modified content
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
