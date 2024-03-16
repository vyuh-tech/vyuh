import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

final featureLauncher = FeatureDescriptor(
  name: 'launcher',
  title: 'A launchpad for all features',
  description: 'Launchpad for features where the actual liftoff happens',
  routes: () async {
    return [
      GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: _LaunchPage());
          }),
    ];
  },
  init: () async {
    vyuh.di.register<ThemeService>(ThemeService());
  },
);

class _LaunchPage extends StatelessWidget {
  const _LaunchPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Launchpad')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Developer Tools'),
            subtitle: const Text('See details of all the features and plugins'),
            onTap: () => context.push('/developer'),
            leading: const Icon(Icons.account_tree),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            title: const Text('Counter'),
            subtitle: const Text('The classic Flutter counter'),
            onTap: () => context.push('/counter'),
            leading: const Icon(Icons.add_circle_outlined),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            title: const Text('Theme Settings'),
            subtitle: const Text('Switch to Light / Dark mode'),
            onTap: () => context.push('/settings'),
            leading: const Icon(Icons.light_mode),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
