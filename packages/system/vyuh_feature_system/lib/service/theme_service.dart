import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

/// Service for managing application themes and theme switching.
///
/// Holds two layers:
///
/// * **[mode]** — the user's stated intent. Can be
///   `ThemeMode.light`, `ThemeMode.dark`, or `ThemeMode.system`.
///   Updated through [changeTheme] / [toggleTheme].
/// * **[currentMode]** — the actively-resolved mode. Always either
///   `ThemeMode.light` or `ThemeMode.dark` (never `system`). Reactively
///   tracks both [mode] AND the OS-level platform brightness, so an OS
///   dark-mode toggle flips this when the intent is `system`.
///
/// Use [currentMode] to look up `ThemeData` and pass to `MaterialApp`.
/// Use [mode] when you need the user intent (e.g. to highlight which of
/// light / dark / system is currently selected in a UI control).
///
/// Built on MobX, so reads inside `Observer` / `autorun` /
/// `reaction` automatically rebuild on changes.
final class ThemeService {
  ThemeService() {
    // Listen for OS-level brightness changes alongside Flutter's own
    // WidgetsBinding (which uses the same hook to drive MediaQuery).
    // We register as an additional observer rather than overwriting
    // `PlatformDispatcher.onPlatformBrightnessChanged`, which would
    // silently break MediaQuery-based rebuilds.
    WidgetsBinding.instance.addObserver(_brightnessBridge);
  }

  final Map<ThemeMode, ThemeData> _themeMap = {};

  /// The user's stated theme intent. Update through [changeTheme] /
  /// [toggleTheme]. Defaults to [ThemeMode.system].
  final Observable<ThemeMode> mode = Observable(ThemeMode.system);

  /// OS-level platform brightness. Updated by the bridge below
  /// when the user toggles dark mode at the OS level.
  final Observable<Brightness> _platformBrightness = Observable<Brightness>(
    PlatformDispatcher.instance.platformBrightness,
  );

  late final _PlatformBrightnessBridge _brightnessBridge =
      _PlatformBrightnessBridge(_platformBrightness);

  /// The actively-resolved theme mode. Always either [ThemeMode.light] or
  /// [ThemeMode.dark] — never [ThemeMode.system]. Reactive to changes in
  /// both [mode] and the OS platform brightness.
  ///
  /// This is what you pass to [theme] to look up the active `ThemeData`.
  late final Computed<ThemeMode> currentMode = Computed<ThemeMode>(() {
    final intent = mode.value;
    if (intent == ThemeMode.light) return ThemeMode.light;
    if (intent == ThemeMode.dark) return ThemeMode.dark;
    return _platformBrightness.value == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
  });

  /// Updates the user's intent. Pass [ThemeMode.system] to follow the OS
  /// theme — [currentMode] then resolves to light / dark based on the
  /// platform brightness and re-resolves automatically when the OS
  /// theme is toggled.
  ///
  /// Example:
  /// ```dart
  /// themeService.changeTheme(ThemeMode.system);
  /// ```
  void changeTheme(ThemeMode requestedMode) {
    runInAction(() => mode.value = requestedMode);
  }

  /// Flips between light and dark, taking the resolved [currentMode] as
  /// the starting point. Always sets [mode] to a concrete [ThemeMode.light]
  /// or [ThemeMode.dark] — toggling out of [ThemeMode.system].
  void toggleTheme() {
    final next = currentMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    runInAction(() => mode.value = next);
  }

  /// Configures theme data for different theme modes.
  ///
  /// Only [ThemeMode.light] and [ThemeMode.dark] need entries; the
  /// service resolves [ThemeMode.system] to one of these two via
  /// [currentMode] before lookup.
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

  /// Gets the theme data for the specified theme mode. Returns `null`
  /// if no theme data is configured for the specified mode.
  ThemeData? theme(ThemeMode mode) => _themeMap[mode];
}

/// [WidgetsBindingObserver] that pumps [PlatformDispatcher.platformBrightness]
/// changes into a MobX [Observable]. Living inside [ThemeService] so the
/// reactivity is encapsulated and not exposed to consumers.
class _PlatformBrightnessBridge with WidgetsBindingObserver {
  _PlatformBrightnessBridge(this._sink);

  final Observable<Brightness> _sink;

  @override
  void didChangePlatformBrightness() {
    runInAction(() {
      _sink.value = PlatformDispatcher.instance.platformBrightness;
    });
  }
}
