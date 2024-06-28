import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/content/route/default_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

class DefaultPageRouteLayout extends StatelessWidget {
  final vf.Route content;

  final DefaultRouteLayout layout;

  const DefaultPageRouteLayout(
      {super.key, required this.content, required this.layout});

  @override
  Widget build(BuildContext context) {
    final bodyItems = content.regions.length == 1
        ? content.regions.first.items
        : content.regions
            .where((x) => x.identifier == 'body')
            .expand((elt) => elt.items)
            .toList(growable: false);

    final drawerItems = content.regions
        .where((x) => x.identifier == 'drawer')
        .expand((elt) => elt.items)
        .toList(growable: false);

    final endDrawerItems = content.regions
        .where((x) => x.identifier == 'endDrawer')
        .expand((elt) => elt.items)
        .toList(growable: false);

    return vf.RouteContainer(
      content: content,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            primary: true,
            key: PageStorageKey<String>(
              content.path,
            ),
            slivers: [
              if (layout.showAppBar)
                SliverAppBar(
                  pinned: true,
                  stretch: false,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(content.title),
                    centerTitle: true,
                  ),
                  scrolledUnderElevation: 2,
                  actions: layout.actions
                      ?.map(
                        (e) => IconButton(
                            onPressed: () => e.action?.execute(context),
                            icon: Icon(e.icon.iconData)),
                      )
                      .toList(growable: false),
                ),
              SliverList.builder(
                itemBuilder: (context, index) =>
                    vyuh.content.buildContent(context, bodyItems[index]),
                itemCount: bodyItems.length,
              )
            ],
          ),
        ),
        drawer:
            drawerItems.isNotEmpty ? _buildDrawer(context, drawerItems) : null,
        endDrawer: endDrawerItems.isNotEmpty
            ? _buildDrawer(context, endDrawerItems)
            : null,
      ),
    );
  }

  _buildDrawer(BuildContext context, List<ContentItem> items) {
    return NavigationDrawer(
      children: [
        for (final item in items) vyuh.content.buildContent(context, item),
      ],
    );
  }
}
