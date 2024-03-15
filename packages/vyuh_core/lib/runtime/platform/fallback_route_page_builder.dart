import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:vyuh_core/vyuh_core.dart';

Page<dynamic> fallbackRoutePageBuilder(
    BuildContext context, g.GoRouterState state) {
  return MaterialPage(
    child: _FallbackRouteNotifier(
      path: state.matchedLocation,
      child: vyuh.content
          .buildRoute(context, url: Uri.parse(state.matchedLocation)),
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
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: child),
              const Icon(
                Icons.warning,
                color: Colors.red,
              ),
              Text(
                'Using a fallback Page for "$path"',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return child;
  }
}
