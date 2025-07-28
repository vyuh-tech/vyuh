import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'navigation.g.dart';

/// The type of navigation operation to perform.
///
/// * [go] - Navigate to a route, replacing the entire history stack
/// * [push] - Add a new route to the navigation stack
/// * [replace] - Replace the current route with a new one
enum NavigationType { go, push, replace }

/// The type of destination to navigate to.
///
/// * [url] - Navigate to a URL (local or external)
/// * [route] - Navigate to a route by its ID (from CMS)
enum LinkType { url, route }

/// An action configuration for handling navigation within the application.
///
/// Features:
/// * Local route navigation
/// * External URL handling
/// * CMS route navigation
/// * Different navigation types (push, replace, go)
/// * Loading states during navigation
/// * Error handling
///
/// Example:
/// ```dart
/// // Navigate to a local route
/// final action = NavigationAction(
///   linkType: LinkType.url,
///   url: '/home',
///   navigationType: NavigationType.push,
/// );
///
/// // Navigate to a CMS route
/// final action = NavigationAction(
///   linkType: LinkType.route,
///   route: ObjectReference('route-id'),
///   navigationType: NavigationType.replace,
/// );
///
/// // Navigate to external URL
/// final action = NavigationAction(
///   linkType: LinkType.url,
///   url: 'https://example.com',
/// );
/// ```
@JsonSerializable()
final class NavigationAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.navigation';
  static final typeDescriptor = TypeDescriptor(
    schemaType: NavigationAction.schemaName,
    title: 'Navigation Action',
    fromJson: NavigationAction.fromJson,
  );

  final LinkType linkType;
  final String? url;
  final ObjectReference? route;

  final NavigationType navigationType;

  NavigationAction({
    this.navigationType = NavigationType.push,
    this.linkType = LinkType.url,
    this.route,
    this.url,
    super.title,
    super.isAwaited,
  }) : super(schemaType: schemaName);

  factory NavigationAction.fromJson(Map<String, dynamic> json) =>
      _$NavigationActionFromJson(json);

  @override
  void execute(BuildContext context, {Map<String, dynamic>? arguments}) async {
    assert(url != null || route != null, 'One of url or route must be set.');

    if (linkType == LinkType.route && route != null) {
      _performNavigation(context, routeId: route!.ref);
      return;
    }

    final uri = Uri.parse(url!);

    if (uri.scheme.startsWith('http')) {
      vyuh.router.push('/__system_navigate__', extra: uri);

      return;
    }

    final localRoute = vyuh.router.instance.configuration.findMatch(uri);
    var isLocal = localRoute.isNotEmpty;

    if (isLocal) {
      navigationType.apply(context, uri.toString());
      return;
    }

    _performNavigation(context, uri: uri);
  }

  Future<void> _performNavigation(BuildContext context,
      {Uri? uri, String? routeId}) async {
    final state = Overlay.of(context);
    final entry = OverlayEntry(
        builder: (_) => VyuhBinding.instance.widgetBuilder
            .routeLoader(context, uri, routeId));
    state.insert(entry);

    try {
      final route = await VyuhBinding.instance.content.provider
          .fetchRoute(path: uri?.toString(), routeId: routeId);
      if (!context.mounted) {
        return;
      }

      final path = route?.path;
      if (path == null) {
        throw ArgumentError(
            'Unable to determine path from route. Tried with uri: ${uri.toString()}, routeId: $routeId');
      }

      if (!context.mounted) {
        return;
      }

      navigationType.apply(context, path);
    } catch (e, stackTrace) {
      vyuh.router.push('/__system_error__', extra: (e, stackTrace));
    } finally {
      entry.remove();
    }
  }
}

/// Extension to apply different navigation types using the router.
///
/// Each navigation type has a different effect on the navigation stack:
/// * [go] - Replaces entire history
/// * [push] - Adds to history
/// * [replace] - Replaces current route
extension on NavigationType {
  void apply(BuildContext context, String path) {
    switch (this) {
      case NavigationType.go:
        vyuh.router.go(path);
        break;
      case NavigationType.push:
        vyuh.router.push(path);
        break;
      case NavigationType.replace:
        vyuh.router.replace(path);
        break;
    }
  }
}
