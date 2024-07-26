import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

enum _KnownRegions {
  body,
  drawer,
  endDrawer,
  header,
  footer,
}

/// A [Scaffold] that uses a [CustomScrollView] to display the content of a [vf.Route].
/// Use this when creating custom layouts for the Route content.
final class PageRouteScaffold extends StatelessWidget {
  /// The [vf.Route] instance to display.
  final vf.Route content;

  /// The [AppBar] to display at the top of the page.
  final AppBar? appBar;

  /// The [AppBar] to display at the top of the page.
  final Widget? body;

  /// Whether to use [SafeArea] around the content.
  final bool useSafeArea;

  /// Creates a new [PageRouteScaffold] instance.
  PageRouteScaffold({
    super.key,
    required this.content,
    this.appBar,
    this.body,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final bodyItems = content.regions
        .where((x) => x.identifier == _KnownRegions.body.name)
        .expand((elt) => elt.items)
        .toList(growable: false);

    final drawerItems = content.regions
        .where((x) => x.identifier == _KnownRegions.drawer.name)
        .expand((elt) => elt.items)
        .toList(growable: false);

    final endDrawerItems = content.regions
        .where((x) => x.identifier == _KnownRegions.endDrawer.name)
        .expand((elt) => elt.items)
        .toList(growable: false);

    final headerItems = content.regions
        .where((x) => x.identifier == _KnownRegions.header.name)
        .expand((elt) => elt.items)
        .toList(growable: false);

    final footerItems = content.regions
        .where((x) => x.identifier == _KnownRegions.footer.name)
        .expand((elt) => elt.items)
        .toList(growable: false);

    final bodyContent = Column(
      children: [
        for (final headerItem in headerItems)
          vyuh.content.buildContent(context, headerItem),
        Expanded(
          child: body ??
              _ScrollView(
                content: content,
                bodyItems: bodyItems,
              ),
        ),
        for (final footerItem in footerItems)
          vyuh.content.buildContent(context, footerItem),
      ],
    );

    return vf.RouteContainer(
      content: content,
      child: Scaffold(
        appBar: appBar,
        body: useSafeArea ? SafeArea(child: bodyContent) : bodyContent,
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

class _ScrollView extends StatelessWidget {
  const _ScrollView({
    required this.content,
    required this.bodyItems,
  });

  final vf.Route content;
  final List<ContentItem> bodyItems;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      cacheExtent: MediaQuery.sizeOf(context).height * 1.5,
      primary: true,
      slivers: [
        SliverList.builder(
          itemBuilder: (context, index) =>
              vyuh.content.buildContent(context, bodyItems[index]),
          itemCount: bodyItems.length,
        )
      ],
    );
  }
}
