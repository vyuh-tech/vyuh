import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/service/theme_service.dart';

final feature = FeatureDescriptor(
  name: 'root',
  title: 'Vyuh Root Feature',
  description: 'The root feature for the Vyuh Demo app',
  init: () async {
    vyuh.event.once<SystemReadyEvent>((event) {
      final themeService = vyuh.di.get<ThemeService>();
      themeService.setThemes({
        ThemeMode.light: DesignSystem.lightTheme,
        ThemeMode.dark: DesignSystem.darkTheme,
      });
    });
  },
  routes: () => [
    GoRoute(path: '/chakra', pageBuilder: defaultRoutePageBuilder),
  ],
);
