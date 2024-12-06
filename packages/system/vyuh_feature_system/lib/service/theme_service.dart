import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

final class ThemeService {
  final Map<ThemeMode, ThemeData> _themeMap = {};

  final Observable<ThemeMode> currentMode = Observable(ThemeMode.light);

  void changeTheme(ThemeMode mode) {
    runInAction(() => currentMode.value = mode);
  }

  void toggleTheme() {
    final newValue =
        currentMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    runInAction(() => currentMode.value = newValue);
  }

  void setThemes(Map<ThemeMode, ThemeData> themes) {
    _themeMap.addAll(themes);
  }

  ThemeData? theme(ThemeMode mode) => _themeMap[mode];
}
