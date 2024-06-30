import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/content/route/default_layout.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

enum _KnownRegions {
  // ignore: unused_field
  body,
  drawer,
  endDrawer,
}

class DefaultPageRouteLayout extends StatelessWidget {
  final vf.Route content;

  final DefaultRouteLayout layout;

  const DefaultPageRouteLayout(
      {super.key, required this.content, required this.layout});

  @override
  Widget build(BuildContext context) {
    // Non-drawer items
    final bodyRegions = content.regions
        .where((x) =>
            x.identifier != _KnownRegions.drawer.name ||
            x.identifier != _KnownRegions.endDrawer.name)
        .toList(growable: false);

    final drawerItems = content.regions
        .where((x) => x.identifier == _KnownRegions.drawer.name)
        .expand((elt) => elt.items)
        .toList(growable: false);

    final endDrawerItems = content.regions
        .where((x) => x.identifier == _KnownRegions.endDrawer.name)
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
              for (final body in bodyRegions)
                SliverList.builder(
                  itemBuilder: (context, index) =>
                      vyuh.content.buildContent(context, body.items[index]),
                  itemCount: body.items.length,
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
