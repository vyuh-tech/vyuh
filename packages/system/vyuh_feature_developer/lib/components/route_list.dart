import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as g;
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_developer/components/items.dart';

/// A widget to display a list of routes.
///
final class RoutesList extends StatefulWidget {
  /// The feature descriptor to display routes for.
  ///
  final FeatureDescriptor feature;

  /// Creates a new routes list widget.
  ///
  const RoutesList({super.key, required this.feature});

  @override
  State<RoutesList> createState() => _RoutesListState();
}

class _RoutesListState extends State<RoutesList> {
  late final Future<List<_PathInfo>> _paths;

  @override
  void initState() {
    super.initState();

    _paths = _fetchRoutes();
  }

  // The return-type is necessary here otherwise Dart will treat this as
  // as Future<dynamic> and cause a CastException
  Future<List<_PathInfo>> _fetchRoutes() async {
    final routes = await widget.feature.routes?.call();

    final List<_PathInfo> paths = [];
    if (routes != null) {
      _recurse(routes, paths, '', 0);
    }

    return paths;
  }

  _recurse(List<g.RouteBase> routes, List<_PathInfo> accumulator,
      String parentPath, int depth) {
    for (final route in routes) {
      String prefix = parentPath;

      if (route is g.GoRoute) {
        final path = '''${depth == 0 ? '' : '$parentPath/'}${route.path}''';

        prefix = path;
        accumulator.add((path, depth));
      }

      if (route.routes.isNotEmpty) {
        final actualDepth = route is ShellRouteBase ? depth : depth + 1;
        _recurse(route.routes, accumulator, prefix, actualDepth);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _paths,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final paths = snapshot.data!;
          return _PathList(paths: paths);
        } else {
          return const SliverToBoxAdapter(child: EmptyItemTile());
        }
      },
    );
  }
}

typedef _PathInfo = (String path, int depth);

class _PathList extends StatelessWidget {
  final List<_PathInfo> paths;

  const _PathList({required this.paths});

  @override
  Widget build(BuildContext context) {
    return paths.isNotEmpty
        ? SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList.builder(
              itemBuilder: (_, index) {
                final path = paths[index];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: path.$2 * 8),
                    if (path.$2 > 0)
                      Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationX(pi),
                          child: const Icon(Icons.turn_right)),
                    Expanded(
                      child: Text(
                        path.$1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.apply(fontFamily: 'Courier'),
                      ),
                    ),
                  ],
                );
              },
              itemCount: paths.length,
            ),
          )
        : const SliverToBoxAdapter(child: EmptyItemTile());
  }
}
