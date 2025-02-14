import 'package:content_widget_demo/examples/conferences.dart';
import 'package:content_widget_demo/examples/custom_widget.dart';
import 'package:content_widget_demo/examples/hello_world.dart';
import 'package:content_widget_demo/examples/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanity_client/sanity_client.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart' hide runApp;
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;
import 'package:vyuh_plugin_content_provider_sanity/vyuh_plugin_content_provider_sanity.dart';
import 'package:vyuh_plugin_telemetry_provider_console/vyuh_plugin_telemetry_provider_console.dart';

import 'example.dart';

final allExamples = [
  helloWorld,
  conferences,
  customWidget,
  route,
];

final sanityProvider = SanityContentProvider.withConfig(
  config: SanityConfig(
    projectId: '8b76lu9s',
    dataset: 'production',
    perspective: Perspective.previewDrafts,
    useCdn: false,
    token:
        'skt2tSTitRob9TonNNubWg09bg0dACmwE0zHxSePlJisRuF1mWJOvgg3ZF68CAWrqtSIOzewbc56dGavACyznDTsjm30ws874WoSH3E5wPMFrqVW8C0Hc0pJGzpYQiehfL9GTRrIyoO3y2aBQIxHpegGspzxAevZcchleelaH5uM6LAnOJT1',
  ),
  cacheDuration: const Duration(seconds: 5),
);

void main() async {
  VyuhContentBinding.init(
      plugins: PluginDescriptor(
        content: DefaultContentPlugin(provider: sanityProvider),
        telemetry:
            TelemetryPlugin(providers: [ConsoleLoggerTelemetryProvider()]),
      ),
      descriptors: [system.descriptor]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardPage(),
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content-driven UI')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: allExamples.length,
            itemBuilder: (_, index) {
              final ex = allExamples[index];

              return ListTile(
                title: Text(ex.title),
                subtitle: Text(ex.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExampleContent(example: ex),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
