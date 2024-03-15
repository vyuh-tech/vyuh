import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

final featureDevLink = FeatureDescriptor(
  name: 'devLink',
  title: 'Link to /developer',
  description: 'A simple feature that links to the /developer route',
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
      appBar: AppBar(title: const Text('Local Root')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Developer Tools'),
            subtitle: const Text('See details of all the features and plugins'),
            onTap: () => context.push('/developer'),
            leading: const Icon(Icons.account_tree),
            trailing: const Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}
