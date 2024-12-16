import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

enum KnownRegionType {
  body,
  drawer,
  endDrawer,
  header,
  footer,
}

/// A [Scaffold] that uses a [CustomScrollView] to display the content of a [vf.Route].
/// Use this when creating custom layouts for the Route content.
final class RouteScaffold extends StatelessWidget {
  /// The [vf.Route] instance to display.
  final vf.Route content;

  /// The [AppBar] to display at the top of the page.
  final AppBar? appBar;

  /// The [AppBar] to display at the top of the page.
  final Widget? body;

  /// Whether to use [SafeArea] around the content.
  final bool useSafeArea;

  /// Creates a new [RouteScaffold] instance.
  const RouteScaffold({
    super.key,
    required this.content,
    this.appBar,
    this.body,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final bodyItems = content.regionItems(KnownRegionType.body.name);

    final drawerItems = content.regionItems(KnownRegionType.drawer.name);

    final endDrawerItems = content.regionItems(KnownRegionType.endDrawer.name);

    final headerItems = content.regionItems(KnownRegionType.header.name);

    final footerItems = content.regionItems(KnownRegionType.footer.name);

    final bodyContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final headerItem in headerItems)
          vyuh.content.buildContent(context, headerItem),
        Expanded(
          child: body ?? vf.ContentItemsScrollView(items: bodyItems),
        ),
        for (final footerItem in footerItems)
          vyuh.content.buildContent(context, footerItem),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: useSafeArea ? SafeArea(child: bodyContent) : bodyContent,
      drawer:
          drawerItems.isNotEmpty ? _buildDrawer(context, drawerItems) : null,
      endDrawer: endDrawerItems.isNotEmpty
          ? _buildDrawer(context, endDrawerItems)
          : null,
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

extension RegionItems on vf.Route {
  regionItems(String regionName) {
    return regions
        .where((x) => x.identifier == regionName)
        .expand((elt) => elt.items)
        .toList(growable: false);
  }
}
