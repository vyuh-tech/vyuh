import 'package:design_system/core/index.dart' as core;
import 'package:design_system/design_system.dart' as ds;
import 'package:flutter/material.dart';

extension BrightnessTheme on Brightness {
  ThemeData get theme => switch (this) {
        Brightness.light => ds.DesignSystem.lightTheme,
        Brightness.dark => ds.DesignSystem.darkTheme,
      };
}

extension DesignSystemExtension on ThemeData {
  ThemeData get withExtensions => copyWith(
        extensions: [
          const core.BorderRadius(),
          const core.BorderWidth(),
          const core.Sizing(),
          const core.Spacing(),
          const core.AspectRatio(),
          const core.LinearGradient(),
          const core.TmdbTextStyleTheme(),
        ],
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(const core.BorderRadius().large),
          ),
          constraints: const BoxConstraints(
            minHeight: 400,
            maxHeight: 600,
          ),
        ),
      );

  core.Spacing get spacing => extension<core.Spacing>() ?? const core.Spacing();

  core.Sizing get sizing => extension<core.Sizing>() ?? const core.Sizing();

  core.BorderWidth get borderWidth =>
      extension<core.BorderWidth>() ?? const core.BorderWidth();

  core.AspectRatio get aspectRatio =>
      extension<core.AspectRatio>() ?? const core.AspectRatio();

  core.BorderRadius get borderRadius =>
      extension<core.BorderRadius>() ?? const core.BorderRadius();

  core.TmdbTextStyleTheme get tmdbTheme =>
      extension<core.TmdbTextStyleTheme>() ?? const core.TmdbTextStyleTheme();

  core.LinearGradient get linearGradient =>
      extension<core.LinearGradient>() ?? const core.LinearGradient();
}
