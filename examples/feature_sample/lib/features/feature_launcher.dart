import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A feature that provides a launchpad for all features. This is built as
/// a function to demonstrate a different way of creating a feature.
featureLauncher(List<EntryPoint> entryPoints) => FeatureDescriptor(
      name: 'launcher',
      title: 'A launchpad for all features',
      description: 'Launchpad for features where the actual liftoff happens',
      icon: Icons.rocket_launch,
      routes: () async {
        return [
          GoRoute(
              path: '/',
              pageBuilder: (context, state) {
                return MaterialPage(
                    child: _LaunchPage(entryPoints: entryPoints));
              }),
        ];
      },
    );

/// A simple entry point for a feature
final class EntryPoint {
  /// Title of the entry point
  final String title;

  /// Description of the entry point
  final String description;

  /// Path to navigate to when the entry point is selected
  final String path;

  /// Icon to display for the entry point
  final IconData icon;

  /// Constructor for the entry point
  EntryPoint({
    required this.title,
    required this.description,
    required this.path,
    required this.icon,
  });
}

class _LaunchPage extends StatelessWidget {
  final List<EntryPoint> entryPoints;
  const _LaunchPage({required this.entryPoints});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Launchpad')),
      body: Column(
        children: [
          for (final entryPoint in entryPoints)
            ListTile(
              title: Text(entryPoint.title),
              subtitle: Text(entryPoint.description),
              onTap: () => vyuh.router.push(entryPoint.path),
              leading: Icon(entryPoint.icon),
              trailing: const Icon(Icons.chevron_right),
            ),
        ],
      ),
    );
  }
}
