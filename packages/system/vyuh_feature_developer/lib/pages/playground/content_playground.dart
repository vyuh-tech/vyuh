import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'widgets/widgets.dart';

/// A view to display a playground for content.
///
final class ContentPlayground extends StatefulWidget {
  /// Creates a new content playground view.
  ///
  const ContentPlayground({super.key});

  @override
  State<ContentPlayground> createState() => ContentPlaygroundState();
}

/// The state for the content playground view.
///
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
            Expanded(
              flex: 2,
              child: PreviewPanel(
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
      const FeatureItem(title: 'All Content', feature: null),
      ...features.map(
        (f) => FeatureItem(
          title: f.title,
          feature: f,
        ),
      ),
    ];

    return ContentList(
      title: 'Features',
      items: allFeatures.map((item) {
        final isSelected = item.feature?.name == _selectedFeature?.name;

        return ContentListItem(
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
    final builders = _getFilteredBuilders();

    return ContentList(
      title: 'Content',
      items: builders.map((b) {
        final isSelected = b == _selectedBuilder;

        return ContentListItem(
          title: b.content.title,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedBuilder = b;
              _selectedLayout = null;
            });
          },
        );
      }).toList(),
      emptyStateWidget: const Center(
        child: Text(
          'No content available',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLayoutList(BuildContext context) {
    final layouts = _selectedBuilder?.layouts ?? [];

    return ContentList(
      title: 'Layouts',
      items: layouts.map((l) {
        final isSelected = l == _selectedLayout;

        return ContentListItem(
          title: l.title,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedLayout = l;
            });
          },
        );
      }).toList(),
      emptyStateWidget: const Center(
        child: Text(
          'Select a content type',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
