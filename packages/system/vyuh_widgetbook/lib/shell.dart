import 'package:flutter/material.dart';
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
              data: lightTheme ?? ThemeData.light(useMaterial3: true),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: darkTheme ?? ThemeData.dark(useMaterial3: true),
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
    final featureBuilders =
        builders.where((b) => b.sourceFeature == feature.name).toList();

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
          builder: (context) => _ContentPreview(
            builder: builder,
            layout: layout,
          ),
        ),
    ];
  }
}

class _ContentPreview extends StatelessWidget {
  final ContentBuilder builder;
  final TypeDescriptor<LayoutConfiguration> layout;

  const _ContentPreview({
    required this.builder,
    required this.layout,
  });

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

    return vyuh.content.buildContent(
      context,
      previewContent,
      layout: previewLayout,
    );
  }
}
