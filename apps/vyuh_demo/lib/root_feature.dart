import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/content/card/button_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

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

      // NOTE
      // ====
      //
      // By uncommenting this line, you can change the default layout for the Card ContentItem.
      // This is useful when you switch to your own Design System with specific layouts for Card and other items.
      //
      // vyuh.content.setDefaultLayout(
      //   schemaType: Card.schemaName,
      //   layout: ButtonCardLayout(),
      //   fromJson: ButtonCardLayout.fromJson,
      // );
    });
  },
  routes: () => [
    GoRoute(path: '/chakra', pageBuilder: defaultRoutePageBuilder),
  ],
);
