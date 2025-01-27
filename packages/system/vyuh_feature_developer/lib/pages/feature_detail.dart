import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_developer/components/items.dart';
import 'package:vyuh_feature_developer/components/route_list.dart';
import 'package:vyuh_feature_developer/components/sticky_section.dart';

/// A widget to display a feature.
///
class FeatureItem extends StatelessWidget {
  /// Creates a new feature item.
  ///
  const FeatureItem({
    super.key,
    required this.feature,
  });

  /// The feature to display.
  ///
  final FeatureDescriptor feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => vyuh.router.push('/developer/features/${feature.name}'),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
        leading: Hero(
          tag: feature.name,
          transitionOnUserGestures: true,
          child: Icon(feature.icon ?? Icons.question_mark_rounded, size: 32),
        ),
        isThreeLine: true,
        title: Text(
          feature.name,
          style: theme.textTheme.labelMedium?.apply(color: theme.disabledColor),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feature.title,
              style: theme.textTheme.bodyLarge
                  ?.apply(color: theme.colorScheme.primary, fontWeightDelta: 2),
              maxLines: 1,
            ),
            Text(
              feature.description ?? '',
              style: theme.textTheme.bodySmall,
              softWrap: false,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

/// A view to display details of a feature.
///
class FeatureDetail extends StatelessWidget {
  /// The feature to display details for.
  ///
  final FeatureDescriptor feature;

  /// Creates a new feature detail view.
  ///
  const FeatureDetail({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(feature.title),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FeatureHeroCard(feature: feature),
            ),
            StickySection(
              title: 'Routes',
              sliver: RoutesList(
                feature: feature,
              ),
            ),
            StickySection(
              title: 'Extensions',
              sliver: feature.extensions != null
                  ? SliverList.builder(
                      itemBuilder: (context, index) =>
                          feature.extensions![index].build(context),
                      itemCount: feature.extensions!.length,
                    )
                  : null,
            ),
            StickySection(
              title: 'Extension Builders',
              sliver: feature.extensionBuilders != null
                  ? SliverList.builder(
                      itemBuilder: (context, index) => ItemTile(
                          title: feature.extensionBuilders![index].title),
                      itemCount: feature.extensionBuilders!.length,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget to display a hero card for a feature.
///
class FeatureHeroCard extends StatelessWidget {
  /// Creates a new feature hero card.
  ///
  const FeatureHeroCard({
    super.key,
    required this.feature,
  });

  /// The feature to display.
  ///
  final FeatureDescriptor feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Hero(
            tag: feature.name,
            transitionOnUserGestures: true,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                feature.icon ?? Icons.question_mark_rounded,
                size: 64,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  feature.name,
                  style: theme.textTheme.labelMedium
                      ?.apply(color: theme.disabledColor),
                ),
                if (feature.description != null)
                  Flexible(child: Text(feature.description!)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// Extension to build widget representations of ExtensionDescriptor instances
///
extension WidgetBuilder on ExtensionDescriptor {
  /// Builds a widget representation of the extension descriptor.
  ///
  Widget build(BuildContext context) {
    switch (this) {
      case ContentExtensionDescriptor():
        return ItemTile(
          title: title,
          description: runtimeType.toString(),
          onTap: () =>
              vyuh.router.push('/developer/extensions/content', extra: this),
        );
      default:
        return ItemTile(
          title: title,
          description: runtimeType.toString(),
        );
    }
  }
}
