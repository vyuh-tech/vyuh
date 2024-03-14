import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

final class ThemeService {
  final Observable<ThemeMode> currentMode = Observable(ThemeMode.light);

  void changeTheme(ThemeMode mode) {
    runInAction(() => currentMode.value = mode);
  }
}
