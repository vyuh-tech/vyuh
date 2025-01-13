import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' hide RouteBase;

Future<List<RouteBase>> routes() async {
  return [
    CMSRoute(path: '/wonderous'),
    GoRoute(
      path: '/wonderous/wonder/:wonder([^/]+)',
      redirect: (params, state) {
        final part = state.uri.pathSegments.last;
        final wonder = state.pathParameters['wonder'];

        if (['details', 'events', 'photos'].contains(part)) {
          return '/wonderous/wonder/$wonder/$part';
        }

        return '/wonderous/wonder/$wonder/details';
      },
      routes: [
        StatefulShellRoute.indexedStack(
          branches: [
            StatefulShellBranch(
              routes: [
                CMSRoute(path: 'details', cmsPathResolver: wonderPathResolver),
              ],
            ),
            StatefulShellBranch(
              routes: [
                CMSRoute(path: 'events', cmsPathResolver: wonderPathResolver),
              ],
            ),
            StatefulShellBranch(
              routes: [
                CMSRoute(path: 'photos', cmsPathResolver: wonderPathResolver),
              ],
            ),
          ],
          builder: (context, __, shell) {
            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () => vyuh.router.go('/wonderous'),
                    icon: const Icon(Icons.home),
                  ),
                ],
              ),
              body: shell,
              bottomNavigationBar: NavigationBar(
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: const [
                  NavigationDestination(
                    label: 'Details',
                    icon: Icon(Icons.receipt_long_outlined),
                  ),
                  NavigationDestination(
                    label: 'Events',
                    icon: Icon(Icons.event_available),
                  ),
                  NavigationDestination(
                    label: 'Photos',
                    icon: Icon(Icons.photo_library_outlined),
                  ),
                ],
                selectedIndex: shell.currentIndex,
                onDestinationSelected: (index) => shell.goBranch(index),
              ),
            );
          },
        ),
      ],
    ),
  ];
}

String wonderPathResolver(String path) {
  return switch (path) {
    (String x) when x.contains(RegExp(r'/wonder/[^/]+/details')) =>
      '/wonderous/wonder/details',
    (String x) when x.contains(RegExp(r'/wonder/[^/]+/events')) =>
      '/wonderous/wonder/events',
    (String x) when x.contains(RegExp(r'/wonder/[^/]+/photos')) =>
      '/wonderous/wonder/photos',
    _ => path
  };
}
