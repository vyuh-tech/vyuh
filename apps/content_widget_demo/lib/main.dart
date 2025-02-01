import 'package:content_widget_demo/my_widget.dart';
import 'package:feature_conference/feature_conference.dart' as conf;
import 'package:flutter/material.dart';
import 'package:sanity_client/sanity_client.dart';
import 'package:vyuh_core/vyuh_core.dart' hide runApp;
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;
import 'package:vyuh_plugin_content_provider_sanity/vyuh_plugin_content_provider_sanity.dart';

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
    plugin: DefaultContentPlugin(provider: sanityProvider),
    descriptors: [
      system.extensionDescriptor,
      conf.extensionDescriptor,
    ],
    onReady: (binding) async {
      binding.di.register(system.ThemeService());
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Content-driven UI')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: VyuhContentWidget.fromDocument(
                    identifier: 'first-words',
                  ),
                ),
                Expanded(
                  child: VyuhContentWidget(
                    query: Queries.conference.query,
                    fromJson: Queries.conference.fromJson,
                    builder: (context, content) {
                      return SingleChildScrollView(
                        child: VyuhContentBinding.content
                            .buildContent(context, content),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef ContentItemFromJson = ContentItem Function(Map<String, dynamic> json);

enum Queries {
  route(
    query: '''
*[_type == "vyuh.route" && path == "/devrel"][0]{
  ...,
  category->,
  regions[] {
    "identifier": region->identifier,
    "title": region->title,
    items
  },
}''',
    fromJson: system.Route.fromJson,
  ),

  conference(
    query: '''
*[_type == "conf.conference" && slug.current == "flutter-conference"][0]{
  ...,
  "slug": slug.current,
}
  ''',
    fromJson: conf.Conference.fromJson,
  );

  final String query;
  final ContentItemFromJson fromJson;

  const Queries({
    required this.query,
    required this.fromJson,
  });
}

/*

- single content item as document (vyuh.document schema)
- add factory method for simple usage (VyuhContentWidget.document(identifier: ""))
- refresh button during debug mode
- Typed argument T for the VyuhContentWidget
 */
