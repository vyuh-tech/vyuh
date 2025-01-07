import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_developer/components/standard_plugin_view.dart';
import 'package:vyuh_feature_developer/components/sticky_section.dart';

class ContentPluginDetailsView extends StatelessWidget {
  final ContentPlugin plugin;

  const ContentPluginDetailsView({super.key, required this.plugin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final contentBuilders = vyuh.content.contentBuilders();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(plugin.title),
              pinned: true,
              primary: true,
            ),
            SliverToBoxAdapter(
              child: _ContentPluginHeader(plugin: plugin),
            ),
            if (contentBuilders?.isNotEmpty ?? false)
              StickySection(
                title: 'Content Builders [${contentBuilders!.length}]',
                headerColor: theme.colorScheme.primaryContainer,
                sliver: SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverList.list(
                    children: [
                      for (final builder in contentBuilders)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 8,
                                children: [
                                  Text(builder.content.title),
                                  Text(
                                    '(${builder.layouts.length} layout${builder.layouts.length == 1 ? '' : 's'})',
                                    style: theme.textTheme.labelMedium?.apply(
                                      color: theme.disabledColor,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '(${builder.content.schemaType})',
                                style: theme.textTheme.labelMedium
                                    ?.apply(color: theme.disabledColor),
                              ),
                              for (final layout in builder.layouts)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: const Text('↳'),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              layout.title,
                                              style:
                                                  theme.textTheme.labelMedium,
                                            ),
                                            Text(
                                              layout.schemaType,
                                              style: theme.textTheme.labelMedium
                                                  ?.apply(
                                                      color:
                                                          theme.disabledColor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            for (final entry in plugin.typeRegistry.entries)
              StickySection(
                title: '${entry.key.toString()} [${entry.value.length}]',
                sliver: SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverList.list(
                    children: [
                      for (final schemaType
                          in entry.value.keys.sortedBy((element) => element))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Text(entry.value[schemaType]!.title),
                              Text(
                                '($schemaType)',
                                style: theme.textTheme.labelMedium
                                    ?.apply(color: theme.disabledColor),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ContentPluginHeader extends StatelessWidget {
  const _ContentPluginHeader({
    required this.plugin,
  });

  final ContentPlugin plugin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StandardPluginItem(plugin: plugin),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle_rounded),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plugin.provider.title,
                      style: theme.textTheme.labelLarge,
                    ),
                    Text(
                      '(${plugin.provider.name})',
                      style: theme.textTheme.labelMedium
                          ?.apply(color: theme.disabledColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
