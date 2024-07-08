import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:vyuh_core/runtime/platform/powered_by_widget.dart';
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
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.redAccent,
              ),
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
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.apply(color: Colors.redAccent),
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
