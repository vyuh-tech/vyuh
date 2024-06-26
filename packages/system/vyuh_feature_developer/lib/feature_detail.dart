import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_developer/components/items.dart';
import 'package:vyuh_feature_developer/components/route_list.dart';
import 'package:vyuh_feature_developer/components/sticky_section.dart';

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    super.key,
    required this.feature,
  });

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

class FeatureDetail extends StatelessWidget {
  final FeatureDescriptor feature;

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

class FeatureHeroCard extends StatelessWidget {
  const FeatureHeroCard({
    super.key,
    required this.feature,
  });

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

extension WidgetBuilder on ExtensionDescriptor {
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
