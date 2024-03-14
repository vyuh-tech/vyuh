import 'package:go_router/go_router.dart';

/// A route purely meant to identify CMS pages. Use it to distinguish between the way
/// local routes and CMS routes are handled.
final class CMSRoute extends GoRoute {
  CMSRoute({
    required super.path,
    super.builder,
    super.pageBuilder,
    super.parentNavigatorKey,
    super.name,
    super.onExit,
    super.redirect,
    super.routes,
  });
}
