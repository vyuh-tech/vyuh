import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

/// A [Scaffold] that displays the first item in the body region of a [vf.Route].
///
/// The [AppBar] and [body] are optional, and can be set via the [appBar] and
/// [body] properties, respectively.
///
/// The [useSafeArea] property determines whether or not to use [SafeArea]
/// around the content.
///
/// {@category Widgets}
final class SingleItemRouteScaffold extends StatelessWidget {
  /// The [vf.Route] instance to display.
  final vf.Route content;

  /// The [AppBar] to display at the top of the page.
  final AppBar? appBar;

  /// The [AppBar] to display at the top of the page.
  final Widget? body;

  /// Whether to use [SafeArea] around the content.
  final bool useSafeArea;

  /// Creates a new [SingleItemRouteScaffold] instance.
  const SingleItemRouteScaffold({
    super.key,
    required this.content,
    this.appBar,
    this.body,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final firstItem = content.regions
        .where((x) => x.identifier == vf.KnownRegionType.body.name)
        .expand((elt) => elt.items)
        .firstOrNull;

    final child = firstItem == null
        ? vf.empty
        : VyuhBinding.instance.content.buildContent(context, firstItem);

    return vf.RouteScaffold(
      content: content,
      appBar: appBar,
      body: child,
      useSafeArea: useSafeArea,
    );
  }
}
