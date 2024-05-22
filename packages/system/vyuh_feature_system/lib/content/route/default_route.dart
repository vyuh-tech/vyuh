import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_core/vyuh_core.dart';

Page<dynamic> defaultRoutePageBuilder(
    BuildContext context, GoRouterState state) {
  final route = state.extra as vc.RouteBase?;

  if (route == null) {
    return MaterialPage(
      child: vyuh.content
          .buildRoute(context, url: Uri.parse(state.matchedLocation)),
      name: state.matchedLocation,
    );
  }

  return route.createPage(context);
}
