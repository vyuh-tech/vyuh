import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'navigation.g.dart';

enum NavigationType { go, push }

enum LinkType { url, route }

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
  }) : super(schemaType: schemaName);

  factory NavigationAction.fromJson(Map<String, dynamic> json) =>
      _$NavigationActionFromJson(json);

  @override
  void execute(BuildContext context) async {
    assert(url != null || route != null, 'One of url or route must be set.');

    if (linkType == LinkType.route && route != null) {
      _performNavigation(context, routeId: route!.ref);
      return;
    }

    final uri = Uri.parse(url!);

    if (uri.scheme.startsWith('http')) {
      context.push('/__system_navigate__', extra: uri);

      return;
    }

    final localRoute = vyuh.router.configuration.findMatch(uri.toString());
    var isLocal = localRoute.routes.any((route) => route is CMSRoute) == false;

    if (isLocal) {
      navigationType.apply(context, uri.toString());
      return;
    }

    _performNavigation(context, uri: uri);
  }

  _performNavigation(BuildContext context, {Uri? uri, String? routeId}) async {
    final state = Overlay.of(context);
    final entry = OverlayEntry(
        builder: (_) => vyuh.widgetBuilder.routeLoader(uri, routeId));
    state.insert(entry);

    try {
      final routeResult = await vyuh.content.provider
          .fetchRoute(path: uri?.toString(), routeId: routeId);
      final route = await routeResult?.init();

      final path = (route as vf.Route?)?.path;
      if (path == null) {
        throw ArgumentError(
            'Unable to determine path from route. Tried with uri: ${uri.toString()}, routeId: $routeId');
      }

      if (!context.mounted) {
        return;
      }

      navigationType.apply(context, path, route);
    } catch (e) {
      context.push('/__system_error__', extra: e);
    } finally {
      entry.remove();
    }
  }
}

extension on NavigationType {
  void apply(BuildContext context, String path, [vf.Route? route]) {
    if (this == NavigationType.push) {
      context.push(path, extra: route);
    } else {
      context.go(path, extra: route);
    }
  }
}
