import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

final featureSettings = FeatureDescriptor(
  name: 'settings',
  title: 'Settings',
  description: 'Settings to adjust the light/dark mode and other features',
  icon: Icons.settings,
  routes: () async {
    return [
      GoRoute(
          path: '/settings',
          builder: (context, state) {
            return const _Settings();
          }),
    ];
  },
);

class _Settings extends StatefulWidget {
  const _Settings();

  @override
  State<_Settings> createState() => _SettingsState();
}

class _SettingsState extends State<_Settings> {
  @override
  Widget build(BuildContext context) {
    final service = vyuh.di.get<ThemeService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Change your Theme',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.dark_mode),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Observer(
                            builder: (_) => Switch.adaptive(
                                  value: service.currentMode.value ==
                                      ThemeMode.light,
                                  onChanged: (value) {
                                    runInAction(() =>
                                        service.currentMode.value = value
                                            ? ThemeMode.light
                                            : ThemeMode.dark);
                                  },
                                )),
                      ),
                      const Icon(Icons.light_mode),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
