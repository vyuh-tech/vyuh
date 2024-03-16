import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_developer/components/feature_hero_card.dart';
import 'package:vyuh_feature_developer/components/items_as_grid.dart';
import 'package:vyuh_feature_developer/components/routes_detail.dart';
import 'package:vyuh_feature_developer/components/sticky_section.dart';

extension WidgetBuilder on FeatureDescriptor {
  Widget build(BuildContext context) {
    return _FeatureItem(feature: this);
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.feature,
  });

  final FeatureDescriptor feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push('/developer/detail', extra: feature),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0),
          child: Row(
            children: [
              Hero(
                tag: feature.name,
                transitionOnUserGestures: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(feature.icon ?? Icons.question_mark_rounded,
                      size: 32),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        feature.name,
                        style: theme.textTheme.bodySmall
                            ?.apply(color: theme.disabledColor),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        feature.title,
                        style: theme.textTheme.bodyLarge,
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        feature.description ?? '',
                        style: theme.textTheme.bodySmall,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
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
                  ? ItemsAsGrid(
                      columns: 1,
                      childAspectRatio: 1 / 0.3,
                      items: feature.extensions!
                          .map((e) => (e.title, e.runtimeType.toString())))
                  : null,
            ),
            StickySection(
              title: 'Extension Builders',
              sliver: feature.extensionBuilders != null
                  ? ItemsAsGrid(
                      columns: 1,
                      childAspectRatio: 1 / 0.3,
                      items: feature.extensionBuilders!
                          .map((e) => (e.title, null)))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
