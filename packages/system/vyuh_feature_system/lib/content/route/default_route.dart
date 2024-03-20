import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as vf;

Page<dynamic> defaultRoutePageBuilder(
    BuildContext context, GoRouterState state) {
  final route = state.extra as vf.Route?;

  if (route == null) {
    return MaterialPage(
      child: vyuh.content
          .buildRoute(context, url: Uri.parse(state.matchedLocation)),
    );
  }

  return route.createPage(context);
}
