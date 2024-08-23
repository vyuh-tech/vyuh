# Vyuh Content Provider for Sanity

This is a Content Provider for Sanity, as part of the Vyuh Framework. It allows
you to fetch content from Sanity.io and use it in your Vyuh application.

## Features

- Fetch single or multiple documents from Sanity.io
- Fetch the Route as per the Vyuh framework schema
- Fetch image, file, and other assets from Sanity.io
- Relies on the [sanity_client](https://pub.dev/packages/sanity_client) package
  to make the network connection

## Usage

```dart
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:sanity_client/sanity_client.dart';
import 'package:vyuh_plugin_content_provider_sanity/vyuh_plugin_content_provider_sanity.dart';

final contentProvider = SanityContentProvider.withConfig(
  config: SanityConfig(
    projectId: '<project-id>',
    dataset: 'production',
    perspective: Perspective.previewDrafts,
    useCdn: false,
    token: '<your-token',
  ),
  cacheDuration: const Duration(seconds: 5),
);

void main() async {

  vc.runApp(
    features: () => [
      // all your features here
    ],
    plugins: [
      contentProvider,
      // other plugins
    ],
    // other configurations
  );
}

```
