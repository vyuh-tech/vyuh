import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' hide RouteBase;
import 'package:vyuh_core/vyuh_core.dart';

/// A function that resolves a CMS path from a local path. This is useful when
/// multiple local routes use a single template path on the CMS. For example:
/// (Local path) /blog/:slug -> /blog (CMS path)
typedef CMSPathResolver = String Function(String path);

String _identityPathResolver(String path) => path;

/// A route purely meant to identify CMS pages. Use it to distinguish between the way
/// local routes and CMS routes are handled.
final class CMSRoute extends GoRoute {
  /// A function that resolves a CMS path from a local path.
  final CMSPathResolver cmsPathResolver;

  /// Creates a new CMS route.
  CMSRoute({
    required super.path,
    this.cmsPathResolver = _identityPathResolver,
    super.builder,
    GoRouterPageBuilder? pageBuilder,
    super.parentNavigatorKey,
    super.name,
    super.onExit,
    super.redirect,
    super.routes,
  }) : super(
          pageBuilder: pageBuilder == null && redirect == null
              ? defaultRoutePageBuilder
              : pageBuilder,
        );
}

/// The default page builder for CMS routes.
Page<dynamic> defaultRoutePageBuilder(
    BuildContext context, GoRouterState state) {
  final route = state.extra as RouteBase?;

  if (route == null) {
    final path = state.topRoute is CMSRoute
        ? (state.topRoute as CMSRoute).cmsPathResolver(state.matchedLocation)
        : state.matchedLocation;

    return MaterialPage(
      child: vyuh.content.buildRoute(context, url: Uri.parse(path)),
      name: state.matchedLocation,
      key: state.pageKey,
    );
  }

  return route.createPage(context, state.pageKey);
}
