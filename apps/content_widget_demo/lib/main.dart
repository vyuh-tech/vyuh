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

// The examples to display in the dashboard.
final examples = [
  const HelloWorldExample(),
  const CustomWidgetExample(),
  const ConferencesExample(),
  const RouteExample(),
];

void main() async {
  // Initialize the Sanity content provider with the appropriate configuration.
  final sanityProvider = SanityContentProvider.withConfig(
    config: SanityConfig(
      projectId: '8b76lu9s',
      dataset: 'production',
      perspective: Perspective.previewDrafts,
      useCdn: false,
      token:
          'skt2tSTitRob9TonNNubWg09bg0dACmwE0zHxSePlJisRuF1mWJOvgg3ZF68CAWrqtSIOzewbc56dGavACyznDTsjm30ws874WoSH3E5wPMFrqVW8C0Hc0pJGzpYQiehfL9GTRrIyoO3y2aBQIxHpegGspzxAevZcchleelaH5uM6LAnOJT1',
    ),
    cacheDuration: const Duration(seconds: 1),
  );

  // Initialize VyuhContentBinding with the Sanity provider and the default content feature.
  VyuhContentBinding.init(
    plugins: PluginDescriptor(
      content: DefaultContentPlugin(provider: sanityProvider),
      telemetry: TelemetryPlugin(providers: [ConsoleLoggerTelemetryProvider()]),
    ),
    descriptors: [system.descriptor],
  );

  // Run the app.
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // The GoRouter instance.
  late final GoRouter _router = GoRouter(
    routes: [
      // The dashboard page route.
      GoRoute(
        path: '/',
        builder: (context, state) => DashboardPage(examples: examples),
      ),
      // The route for each example.
      GoRoute(
        path: '/:index',
        builder: (context, state) {
          final index = int.parse(state.pathParameters['index']!);

          // Return the content for the example.
          return ExampleContent(example: examples[index]);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // Return the MaterialApp with the GoRouter.
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

class DashboardPage extends StatelessWidget {
  final List<ExampleWidget> examples;
  const DashboardPage({super.key, required this.examples});

  @override
  Widget build(BuildContext context) {
    // Return the Scaffold with the list of examples.
    return Scaffold(
      appBar: AppBar(title: const Text('Content-driven UI')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: examples.length,
            itemBuilder: (_, index) {
              final ex = examples[index];

              // Return a ListTile for each example.
              return ListTile(
                title: Text(ex.title),
                subtitle: Text(ex.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/$index'),
              );
            },
          ),
        ),
      ),
    );
  }
}
