import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as go;
import 'package:go_router/go_router.dart';

buildRoutes() {
  return [
    GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(child: _LaunchPage());
        }),
  ];
}

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
