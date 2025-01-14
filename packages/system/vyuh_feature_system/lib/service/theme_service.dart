import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

/// Service for managing application themes and theme switching.
///
/// This service provides functionality to:
/// * Switch between light and dark themes
/// * Toggle between themes
/// * Configure theme data for different theme modes
/// * Access current theme mode and theme data
///
/// Uses MobX for reactive theme state management.
final class ThemeService {
  final Map<ThemeMode, ThemeData> _themeMap = {};

  /// The current theme mode (light/dark) as an observable value.
  ///
  /// Can be used with MobX observers to react to theme changes.
  final Observable<ThemeMode> currentMode = Observable(ThemeMode.light);

  /// Changes the current theme mode to the specified mode.
  ///
  /// Example:
  /// ```dart
  /// themeService.changeTheme(ThemeMode.dark);
  /// ```
  void changeTheme(ThemeMode mode) {
    runInAction(() => currentMode.value = mode);
  }

  /// Toggles between light and dark themes.
  ///
  /// If current theme is light, switches to dark and vice versa.
  void toggleTheme() {
    final newValue =
        currentMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    runInAction(() => currentMode.value = newValue);
  }

  /// Configures theme data for different theme modes.
  ///
  /// Example:
  /// ```dart
  /// themeService.setThemes({
  ///   ThemeMode.light: ThemeData.light(),
  ///   ThemeMode.dark: ThemeData.dark(),
  /// });
  /// ```
  void setThemes(Map<ThemeMode, ThemeData> themes) {
    _themeMap.addAll(themes);
  }

  /// Gets the theme data for the specified theme mode.
  ///
  /// Returns null if no theme data is configured for the specified mode.
  ThemeData? theme(ThemeMode mode) => _themeMap[mode];
}
