import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'preview.dart';

/// A widget to display a preview of a content item.
///
final class PreviewPanel extends StatelessWidget {
  /// The content builder to preview.
  ///
  final ContentBuilder? builder;

  /// The layout to preview.
  ///
  final TypeDescriptor<LayoutConfiguration>? layout;

  /// The feature to preview.
  ///
  final FeatureDescriptor? feature;

  /// Creates a new preview panel widget.
  ///
  const PreviewPanel({
    super.key,
    this.builder,
    this.layout,
    this.feature,
  });

  Widget _buildBreadcrumb(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.apply(
      color: theme.colorScheme.onPrimary,
    );
    final separatorStyle = textStyle?.apply(
      color: theme.colorScheme.onPrimary.withValues(alpha: 0.5),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (feature != null) Text(feature!.title, style: textStyle),
          if (builder != null) ...[
            if (feature != null) Text(' / ', style: separatorStyle),
            Text(builder!.content.title, style: textStyle),
          ],
          if (layout != null) ...[
            if (builder != null) Text(' / ', style: separatorStyle),
            Text(layout!.title, style: textStyle),
          ],
          if (feature == null && builder == null && layout == null)
            Text('Select a feature', style: textStyle),
        ],
      ),
    );
  }

  Widget _featureHeader(BuildContext context, String featureName) {
    final feature =
        vyuh.features.firstWhereOrNull((f) => f.name == featureName);
    if (feature == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Row(
      spacing: 4,
      children: [
        Text('Source Feature: ', style: theme.textTheme.labelMedium),
        Text(feature.title),
        Text('(${feature.name})', style: theme.textTheme.labelSmall),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: _buildBreadcrumb(context),
        ),
        if (builder != null && layout != null) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _featureHeader(context, layout?.sourceFeature ?? ''),
          ),
          Expanded(
            child: Preview(
              builder: builder!,
              layout: layout!,
            ),
          )
        ] else
          const Expanded(
            child: Center(
              child: Text('Select a layout to preview'),
            ),
          ),
      ],
    );
  }
}
