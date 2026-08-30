import 'package:flutter/material.dart' as legacy_material;
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_widgetbook/ui/no_preview_card.dart';
import 'package:widgetbook/widgetbook.dart';

final class WidgetBookShell extends StatelessWidget {
  final List<FeatureDescriptor> features;

  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  const WidgetBookShell({
    super.key,
    required this.features,
    this.lightTheme,
    this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        for (final feature in features)
          WidgetbookPackage(
            name: feature.title,
            children: _buildContentComponents(feature),
          ),
      ],
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: lightTheme == null
                  ? legacy_material.ThemeData.light(useMaterial3: true)
                  : _toLegacyTheme(lightTheme!),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: darkTheme == null
                  ? legacy_material.ThemeData.dark(useMaterial3: true)
                  : _toLegacyTheme(darkTheme!),
            ),
          ],
        ),
        TextScaleAddon(),
        InspectorAddon(),
        ZoomAddon(),
        AlignmentAddon(),
      ],
    );
  }

  List<WidgetbookComponent> _buildContentComponents(FeatureDescriptor feature) {
    final builders = vyuh.content.contentBuilders() ?? [];
    final featureBuilders = builders
        .where((b) => b.sourceFeature == feature.name)
        .toList();

    return [
      for (final builder in featureBuilders)
        WidgetbookComponent(
          name: builder.content.title,
          useCases: _buildLayoutUseCases(builder),
        ),
    ];
  }

  List<WidgetbookUseCase> _buildLayoutUseCases(ContentBuilder builder) {
    return [
      for (final layout in builder.layouts)
        WidgetbookUseCase(
          name: layout.title,
          builder: (context) =>
              _ContentPreview(builder: builder, layout: layout),
        ),
    ];
  }
}

class _ContentPreview extends StatelessWidget {
  final ContentBuilder builder;
  final TypeDescriptor<LayoutConfiguration> layout;

  const _ContentPreview({required this.builder, required this.layout});

  @override
  Widget build(BuildContext context) {
    final previewContent = builder.content.preview?.call();
    final previewLayout = layout.preview?.call();

    if (previewContent == null || previewLayout == null) {
      return NoPreviewCard(
        title: '"${builder.content.title}" with layout: "${layout.title}"',
        contentType: builder.content.runtimeType,
        layoutType: layout.runtimeType,
        content: previewContent,
        layout: previewLayout,
      );
    }

    return Theme(
      data: _toMaterialUiTheme(legacy_material.Theme.of(context)),
      child: Builder(
        builder: (context) => vyuh.content.buildContent(
          context,
          previewContent,
          layout: previewLayout,
        ),
      ),
    );
  }
}

legacy_material.ThemeData _toLegacyTheme(ThemeData theme) =>
    legacy_material.ThemeData(
      platform: theme.platform,
      visualDensity: legacy_material.VisualDensity(
        horizontal: theme.visualDensity.horizontal,
        vertical: theme.visualDensity.vertical,
      ),
      colorScheme: _toLegacyColorScheme(theme.colorScheme),
      textTheme: _toLegacyTextTheme(theme.textTheme),
      useMaterial3: true,
    );

ThemeData _toMaterialUiTheme(legacy_material.ThemeData theme) => ThemeData(
  platform: theme.platform,
  visualDensity: VisualDensity(
    horizontal: theme.visualDensity.horizontal,
    vertical: theme.visualDensity.vertical,
  ),
  colorScheme: _toMaterialUiColorScheme(theme.colorScheme),
  textTheme: _toMaterialUiTextTheme(theme.textTheme),
  useMaterial3: true,
);

legacy_material.ColorScheme _toLegacyColorScheme(ColorScheme scheme) =>
    legacy_material.ColorScheme(
      brightness: scheme.brightness,
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      secondary: scheme.secondary,
      onSecondary: scheme.onSecondary,
      secondaryContainer: scheme.secondaryContainer,
      onSecondaryContainer: scheme.onSecondaryContainer,
      tertiary: scheme.tertiary,
      onTertiary: scheme.onTertiary,
      tertiaryContainer: scheme.tertiaryContainer,
      onTertiaryContainer: scheme.onTertiaryContainer,
      error: scheme.error,
      onError: scheme.onError,
      errorContainer: scheme.errorContainer,
      onErrorContainer: scheme.onErrorContainer,
      surface: scheme.surface,
      onSurface: scheme.onSurface,
      surfaceDim: scheme.surfaceDim,
      surfaceBright: scheme.surfaceBright,
      surfaceContainerLowest: scheme.surfaceContainerLowest,
      surfaceContainerLow: scheme.surfaceContainerLow,
      surfaceContainer: scheme.surfaceContainer,
      surfaceContainerHigh: scheme.surfaceContainerHigh,
      surfaceContainerHighest: scheme.surfaceContainerHighest,
      onSurfaceVariant: scheme.onSurfaceVariant,
      outline: scheme.outline,
      outlineVariant: scheme.outlineVariant,
      shadow: scheme.shadow,
      scrim: scheme.scrim,
      inverseSurface: scheme.inverseSurface,
      onInverseSurface: scheme.onInverseSurface,
      inversePrimary: scheme.inversePrimary,
      surfaceTint: scheme.surfaceTint,
    );

ColorScheme _toMaterialUiColorScheme(legacy_material.ColorScheme scheme) =>
    ColorScheme(
      brightness: scheme.brightness,
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      secondary: scheme.secondary,
      onSecondary: scheme.onSecondary,
      secondaryContainer: scheme.secondaryContainer,
      onSecondaryContainer: scheme.onSecondaryContainer,
      tertiary: scheme.tertiary,
      onTertiary: scheme.onTertiary,
      tertiaryContainer: scheme.tertiaryContainer,
      onTertiaryContainer: scheme.onTertiaryContainer,
      error: scheme.error,
      onError: scheme.onError,
      errorContainer: scheme.errorContainer,
      onErrorContainer: scheme.onErrorContainer,
      surface: scheme.surface,
      onSurface: scheme.onSurface,
      surfaceDim: scheme.surfaceDim,
      surfaceBright: scheme.surfaceBright,
      surfaceContainerLowest: scheme.surfaceContainerLowest,
      surfaceContainerLow: scheme.surfaceContainerLow,
      surfaceContainer: scheme.surfaceContainer,
      surfaceContainerHigh: scheme.surfaceContainerHigh,
      surfaceContainerHighest: scheme.surfaceContainerHighest,
      onSurfaceVariant: scheme.onSurfaceVariant,
      outline: scheme.outline,
      outlineVariant: scheme.outlineVariant,
      shadow: scheme.shadow,
      scrim: scheme.scrim,
      inverseSurface: scheme.inverseSurface,
      onInverseSurface: scheme.onInverseSurface,
      inversePrimary: scheme.inversePrimary,
      surfaceTint: scheme.surfaceTint,
    );

legacy_material.TextTheme _toLegacyTextTheme(TextTheme theme) =>
    legacy_material.TextTheme(
      displayLarge: theme.displayLarge,
      displayMedium: theme.displayMedium,
      displaySmall: theme.displaySmall,
      headlineLarge: theme.headlineLarge,
      headlineMedium: theme.headlineMedium,
      headlineSmall: theme.headlineSmall,
      titleLarge: theme.titleLarge,
      titleMedium: theme.titleMedium,
      titleSmall: theme.titleSmall,
      bodyLarge: theme.bodyLarge,
      bodyMedium: theme.bodyMedium,
      bodySmall: theme.bodySmall,
      labelLarge: theme.labelLarge,
      labelMedium: theme.labelMedium,
      labelSmall: theme.labelSmall,
    );

TextTheme _toMaterialUiTextTheme(legacy_material.TextTheme theme) => TextTheme(
  displayLarge: theme.displayLarge,
  displayMedium: theme.displayMedium,
  displaySmall: theme.displaySmall,
  headlineLarge: theme.headlineLarge,
  headlineMedium: theme.headlineMedium,
  headlineSmall: theme.headlineSmall,
  titleLarge: theme.titleLarge,
  titleMedium: theme.titleMedium,
  titleSmall: theme.titleSmall,
  bodyLarge: theme.bodyLarge,
  bodyMedium: theme.bodyMedium,
  bodySmall: theme.bodySmall,
  labelLarge: theme.labelLarge,
  labelMedium: theme.labelMedium,
  labelSmall: theme.labelSmall,
);
