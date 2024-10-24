import 'package:feature_unsplash/ui/collection_detail.dart';
import 'package:feature_unsplash/ui/home.dart';
import 'package:feature_unsplash/ui/photo_detail.dart';
import 'package:feature_unsplash/ui/search_view.dart';
import 'package:feature_unsplash/ui/topic_detail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

final _homeKey = GlobalKey<NavigatorState>();
final _searchKey = GlobalKey<NavigatorState>();

List<go.RouteBase> routes() {
  return [
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeKey,
          routes: [
            GoRoute(
              path: '/unsplash/home',
              builder: (context, state) {
                return const UnsplashHome();
              },
              routes: [
                GoRoute(
                  path: 'photos/:id',
                  builder: (context, state) {
                    return PhotoDetail(id: state.pathParameters['id']!);
                  },
                ),
                GoRoute(
                  path: 'collections/:id',
                  builder: (context, state) {
                    return CollectionDetailView(
                        id: state.pathParameters['id']!);
                  },
                ),
                GoRoute(
                  path: 'topics/:id',
                  builder: (context, state) {
                    return TopicDetailView(id: state.pathParameters['id']!);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _searchKey,
          routes: [
            GoRoute(
                path: '/unsplash/search',
                builder: (_, __) => const Scaffold(
                      body: SafeArea(child: SearchView()),
                    )),
          ],
        ),
      ],
      builder: (context, __, shell) {
        final theme = Theme.of(context);

        return Scaffold(
          body: shell,
          appBar: AppBar(
            title: const Text('Unsplash'),
            actions: [
              IconButton(
                  onPressed: () => vyuh.router.go('/chakra'),
                  icon: const Icon(Icons.home))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: theme.colorScheme.primary,
            type: BottomNavigationBarType.fixed,
            elevation: 2,
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home_outlined),
              ),
              BottomNavigationBarItem(
                label: 'Search',
                icon: Icon(Icons.search_outlined),
              ),
            ],
            currentIndex: shell.currentIndex,
            onTap: (index) => shell.goBranch(
              index,
              initialLocation: index == shell.currentIndex,
            ),
          ),
        );
      },
    ),
  ];
}
