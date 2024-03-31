import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_developer/components/items.dart';
import 'package:vyuh_feature_developer/components/sticky_section.dart';

class ContentExtensionDetail extends StatelessWidget {
  final ContentExtensionDescriptor extension;

  const ContentExtensionDetail({super.key, required this.extension});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(extension.title),
              pinned: true,
              primary: true,
            ),
            StickySection(
              title: 'Actions [${extension.actions?.length ?? 0}]',
              sliver: SliverList.list(
                children: [
                  for (final item in extension.actions ?? <TypeDescriptor>[])
                    ItemTile(title: item.title, description: item.schemaType)
                ],
              ),
            ),
            StickySection(
              title: 'Route Types [${extension.routeTypes?.length ?? 0}]',
              sliver: extension.routeTypes != null &&
                      extension.routeTypes!.isNotEmpty
                  ? SliverList.list(
                      children: [
                        for (final item
                            in extension.routeTypes ?? <TypeDescriptor>[])
                          ItemTile(
                              title: item.title, description: item.schemaType)
                      ],
                    )
                  : const SliverToBoxAdapter(child: EmptyItemTile()),
            ),
            StickySection(
              title: 'Conditions [${extension.conditions?.length ?? 0}]',
              sliver: extension.conditions != null &&
                      extension.conditions!.isNotEmpty
                  ? SliverList.list(
                      children: [
                        for (final item
                            in extension.conditions ?? <TypeDescriptor>[])
                          ItemTile(
                              title: item.title, description: item.schemaType)
                      ],
                    )
                  : const SliverToBoxAdapter(child: EmptyItemTile()),
            ),
            StickySection(
              title:
                  'Content Builders [${extension.contentBuilders?.length ?? 0}]',
              sliver: extension.contentBuilders != null &&
                      extension.contentBuilders!.isNotEmpty
                  ? SliverList.list(
                      children: [
                        for (final item
                            in extension.contentBuilders ?? <ContentBuilder>[])
                          ItemTile(
                              title: item.content.title,
                              description: item.content.schemaType)
                      ],
                    )
                  : const SliverToBoxAdapter(child: EmptyItemTile()),
            ),
            StickySection(
              title: 'Content Descriptors [${extension.contents?.length ?? 0}]',
              sliver:
                  extension.contents != null && extension.contents!.isNotEmpty
                      ? SliverList.list(
                          children: [
                            for (final item
                                in extension.contents ?? <ContentDescriptor>[])
                              _ContentDescriptorTile(item: item)
                          ],
                        )
                      : const SliverToBoxAdapter(child: EmptyItemTile()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentDescriptorTile extends StatelessWidget {
  const _ContentDescriptorTile({
    required this.item,
  });

  final ContentDescriptor item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ItemTile(
          title: item.title,
          description: item.schemaType,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('Layouts [${item.layouts?.length ?? 0}]',
              style: theme.textTheme.labelMedium),
        ),
        for (final layout in item.layouts ?? <TypeDescriptor>[])
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('↳',
                      style: theme.textTheme.bodyLarge
                          ?.apply(color: theme.disabledColor))),
              Expanded(
                child: ItemTile(
                  title: layout.title,
                  description: layout.schemaType,
                ),
              ),
            ],
          ),
        const Divider()
      ],
    );
  }
}
