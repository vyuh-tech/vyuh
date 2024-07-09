import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

enum _KnownRegions {
  // ignore: unused_field
  body,
  drawer,
  endDrawer,
}

/// A [Scaffold] that uses a [CustomScrollView] to display the content of a [vf.Route].
/// Use this when creating custom layouts for the Route content.
final class PageRouteScaffold extends StatelessWidget {
  /// The [vf.Route] instance to display.
  final vf.Route content;

  /// The [SliverAppBar] to display at the top of the page.
  final SliverAppBar? sliverAppBar;

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
    this.sliverAppBar,
    this.body,
    this.useSafeArea = true,
  }) {
    assert(appBar == null || sliverAppBar == null,
        'Cannot provide both an AppBar and a SliverAppBar');
  }

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

    final bodyContent = body ??
        _ScrollView(
          content: content,
          appBar: sliverAppBar,
          bodyRegions: bodyRegions,
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
    required this.appBar,
    required this.bodyRegions,
  });

  final vf.Route content;
  final SliverAppBar? appBar;
  final List<vf.Region> bodyRegions;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      cacheExtent: MediaQuery.sizeOf(context).height * 1.5,
      primary: true,
      key: PageStorageKey<String>(content.path),
      slivers: [
        if (appBar != null) appBar!,
        for (final body in bodyRegions)
          SliverList.builder(
            itemBuilder: (context, index) =>
                vyuh.content.buildContent(context, body.items[index]),
            itemCount: body.items.length,
          )
      ],
    );
  }
}
