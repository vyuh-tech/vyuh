import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_developer/components/standard_plugin_view.dart';
import 'package:vyuh_feature_developer/components/sticky_section.dart';

class ContentPluginDetailsView extends StatelessWidget {
  final ContentPlugin content;

  const ContentPluginDetailsView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(content.title),
            pinned: true,
            primary: true,
          ),
          SliverToBoxAdapter(
            child: Card(
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StandardPluginView(plugin: content),
                      const SizedBox(height: 8),
                      Text(
                        content.provider.title,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${content.provider.name})',
                        style: theme.textTheme.bodyMedium
                            ?.apply(color: theme.disabledColor),
                      ),
                    ],
                  ),
                )),
          ),
          for (final entry in content.typeRegistry.entries)
            StickySection(
              title: '${entry.key.toString()} [${entry.value.length}]',
              sliver: SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverList.list(
                  children: [
                    for (final schemaType
                        in entry.value.keys.sortedBy((element) => element))
                      Text(schemaType)
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
