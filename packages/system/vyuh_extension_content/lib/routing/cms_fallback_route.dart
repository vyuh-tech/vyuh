import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/runtime/platform/powered_by_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// A catch-all route that asks the CMS for every location no other route
/// matches, so a page published in the CMS is reachable at its path without a
/// local route.
///
/// Add it to a feature's routes; the router always places it last. The CMS
/// system feature (`vyuh_feature_system`) contributes it for you. Without it,
/// unmatched locations show the framework's not-found page.
final cmsFallbackRoute = g.GoRoute(
  path: NavigationPlugin.catchAllPath,
  pageBuilder: cmsFallbackPageBuilder,
);

/// The page builder of [cmsFallbackRoute]. In debug builds it marks the page
/// as served by the fallback.
Page<dynamic> cmsFallbackPageBuilder(
  BuildContext context,
  g.GoRouterState state,
) {
  return MaterialPage(
    child: _FallbackRouteNotifier(
      path: state.matchedLocation,
      child: vyuh.content.buildRoute(
        context,
        url: Uri.parse(state.matchedLocation),
      ),
    ),
  );
}

class _FallbackRouteNotifier extends StatelessWidget {
  final String path;
  final Widget child;

  const _FallbackRouteNotifier({required this.path, required this.child});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded),
              SizedBox(width: 8),
              Text('Missing Route'),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Using a fallback Page for "$path"',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium
                    ?.apply(color: Theme.of(context).colorScheme.error),
              ),
              Expanded(child: child),
              const PoweredByWidget(),
            ],
          ),
        ),
      );
    }

    return child;
  }
}
