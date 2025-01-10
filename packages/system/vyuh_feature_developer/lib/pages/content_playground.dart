import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

final class ContentPlayground extends StatefulWidget {
  const ContentPlayground({super.key});

  @override
  State<ContentPlayground> createState() => ContentPlaygroundState();
}

final class ContentPlaygroundState extends State<ContentPlayground> {
  ContentBuilder? _selectedBuilder;
  TypeDescriptor<LayoutConfiguration>? _selectedLayout;
  late final List<ContentBuilder> _builders;
  FeatureDescriptor? _selectedFeature;

  @override
  void initState() {
    super.initState();
    _builders = vyuh.content.contentBuilders() ?? [];
  }

  List<ContentBuilder> _getFilteredBuilders() {
    if (_selectedFeature == null) {
      return _builders;
    }
    return _builders
        .where((b) => b.sourceFeature == _selectedFeature!.name)
        .toList();
  }

  Widget _buildFeatureList(BuildContext context) {
    final features = vyuh.features.toList();
    final allFeatures = [
      const _FeatureItem(title: 'All Content', feature: null),
      ...features.map(
        (f) => _FeatureItem(
          title: f.title,
          feature: f,
        ),
      ),
    ];

    return _ContentList(
      title: 'Features',
      items: allFeatures.map((item) {
        final isSelected = item.feature?.name == _selectedFeature?.name;

        return _ContentListItem(
          title: item.title,
          isSelected: isSelected,
          isSpecial: item.feature == null,
          onTap: () {
            setState(() {
              _selectedFeature = item.feature;
              _selectedBuilder = null;
              _selectedLayout = null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildContentList(BuildContext context) {
    final filteredBuilders = _getFilteredBuilders();
    return _ContentList(
      title: 'Content',
      items: filteredBuilders.map((builder) {
        final isSelected = builder == _selectedBuilder;
        return _ContentListItem(
          title: builder.content.title,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedBuilder = builder;
              _selectedLayout = null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildLayoutList(BuildContext context) {
    if (_selectedBuilder == null) {
      return const _ContentList(
        title: 'Layouts',
        items: [],
        emptyStateWidget: Center(
          child: Text(
            'Select a content type',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return _ContentList(
      title: 'Layouts',
      items: _selectedBuilder!.layouts.map((layout) {
        final isSelected = layout == _selectedLayout;
        return _ContentListItem(
          title: layout.title,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedLayout = layout;
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Playground'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFeatureList(context),
                    VerticalDivider(
                        width: 3, color: theme.colorScheme.surfaceDim),
                    _buildContentList(context),
                    VerticalDivider(
                        width: 3, color: theme.colorScheme.surfaceDim),
                    _buildLayoutList(context),
                  ],
                ),
              ),
            ),
            Divider(height: 3, color: theme.colorScheme.surfaceDim),
            Expanded(
              flex: 2,
              child: _PreviewPanel(
                feature: _selectedFeature,
                builder: _selectedBuilder,
                layout: _selectedLayout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ContentList extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final Widget? emptyStateWidget;

  const _ContentList({
    required this.title,
    required this.items,
    this.emptyStateWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width * 0.4;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.all(2),
            child: Text(
              '$title (${items.length})',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.apply(
                fontWeightDelta: 2,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          Expanded(
            child: items.isEmpty && emptyStateWidget != null
                ? emptyStateWidget!
                : ListView(
                    children: items,
                  ),
          ),
        ],
      ),
    );
  }
}

final class _ContentListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isSpecial;
  final VoidCallback? onTap;

  const _ContentListItem({
    required this.title,
    required this.isSelected,
    this.isSpecial = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = isSelected
        ? theme.colorScheme.onPrimaryContainer
        : isSpecial
            ? theme.colorScheme.primary
            : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : null,
        ),
        padding: const EdgeInsets.all(4.0),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.apply(
            color: textColor,
            fontWeightDelta: isSelected || isSpecial ? 2 : 0,
          ),
        ),
      ),
    );
  }
}

final class _FeatureItem {
  final String title;
  final FeatureDescriptor? feature;

  const _FeatureItem({
    required this.title,
    required this.feature,
  });
}

final class _PreviewPanel extends StatelessWidget {
  final FeatureDescriptor? feature;
  final ContentBuilder? builder;
  final TypeDescriptor<LayoutConfiguration>? layout;

  const _PreviewPanel({
    this.feature,
    this.builder,
    this.layout,
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
          if (feature != null) ...[
            Text(feature!.title, style: textStyle),
          ],
          if (builder != null) ...[
            if (feature != null) Text(' / ', style: separatorStyle),
            Text(builder!.content.title, style: textStyle),
          ],
          if (layout != null) ...[
            if (builder != null) Text(' / ', style: separatorStyle),
            Text(layout!.title, style: textStyle),
          ],
          if (feature == null && builder == null && layout == null)
            Text('Select a content item to preview', style: textStyle),
        ],
      ),
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
            child: _Preview(
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
}

final class _Preview extends StatelessWidget {
  final ContentBuilder builder;
  final TypeDescriptor<LayoutConfiguration<ContentItem>> layout;

  const _Preview({
    required this.builder,
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = builder.content.preview?.call();
    final contentLayout = layout.preview?.call();

    // Wrap inside a LimitedBox to ensure that we give sufficient height.
    // Otherwise, it will be an infinite height inside the SingleChildScrollView.
    final widget = (content == null || contentLayout == null)
        ? null
        : LimitedBox(
            maxHeight: MediaQuery.sizeOf(context).height * 0.5,
            child: vyuh.content
                .buildContent(context, content, layout: contentLayout),
          );

    final message = [
      if (content == null) '${builder.content.runtimeType}',
      if (contentLayout == null) '${layout.runtimeType}',
    ].join(' and ');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: widget ??
          Card(
            color: theme.colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '''
No Preview available for "${layout.title}".
         
Make sure to supply the 'preview' parameter for $message.
                      ''',
                style: theme.textTheme.labelLarge?.apply(
                  fontFamily: 'Courier',
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),
    );
  }
}
