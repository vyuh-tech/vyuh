import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content/condition.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

/// A condition configuration that evaluates the current theme mode.
///
/// Features:
/// * Theme mode detection (light/dark)
/// * Integration with [ThemeService]
/// * Reactive theme changes
/// * Asynchronous evaluation
///
/// Example:
/// ```dart
/// // In a conditional content
/// final conditional = Conditional(
///   condition: Condition(
///     configuration: CurrentThemeMode(),
///   ),
///   cases: [
///     CaseItem(
///       value: 'light',
///       item: LightThemeContent(),
///     ),
///     CaseItem(
///       value: 'dark',
///       item: DarkThemeContent(),
///     ),
///   ],
///   defaultCase: 'light',
/// );
///
/// // In a conditional action
/// final action = ConditionalAction(
///   condition: Condition(
///     configuration: CurrentThemeMode(),
///   ),
///   cases: [
///     ActionCase(
///       value: 'light',
///       action: NavigationAction(url: '/light-theme'),
///     ),
///     ActionCase(
///       value: 'dark',
///       action: NavigationAction(url: '/dark-theme'),
///     ),
///   ],
///   defaultCase: 'light',
/// );
/// ```
///
/// The condition returns:
/// * 'light' for light theme mode
/// * 'dark' for dark theme mode
/// * 'system' for system theme mode
final class CurrentThemeMode extends ConditionConfiguration {
  static const schemaName = 'vyuh.condition.themeMode';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: (json) => CurrentThemeMode(),
    title: 'Current Theme Mode',
  );

  CurrentThemeMode() : super(schemaType: schemaName);

  @override
  Future<String?> execute(BuildContext context) {
    final mode = VyuhBinding.instance.di.get<ThemeService>().currentMode.value;

    return Future.value(mode.name);
  }
}
