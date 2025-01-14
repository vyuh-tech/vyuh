<p align="center">
  <a href="https://vyuh.tech">
    <img src="https://github.com/vyuh-tech.png" alt="Vyuh Logo" height="128" />
  </a>
  <h1 align="center">Vyuh Framework</h1>
  <p align="center">Build Modular, Scalable, CMS-driven Flutter Apps</p>
  <p align="center">
    <a href="https://docs.vyuh.tech">Docs</a> |
    <a href="https://vyuh.tech">Website</a>
  </p>
</p>

# Vyuh Content Provider for Sanity 🔌

[![vyuh_plugin_content_provider_sanity](https://img.shields.io/pub/v/vyuh_plugin_content_provider_sanity.svg?label=vyuh_plugin_content_provider_sanity&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_plugin_content_provider_sanity)

A powerful content provider plugin that seamlessly integrates
[Sanity.io](https://www.sanity.io) with the Vyuh framework. This plugin enables
your Vyuh application to fetch, cache, and manage content from Sanity.io with
minimal configuration.

## Features ✨

- **Content Management** 📝

  - Fetch single or multiple documents
  - Support for all Sanity content types
  - Automatic content type mapping
  - Built-in caching with configurable duration

- **Asset Support** 🖼️

  - Image assets with transformations
  - File assets with metadata
  - Reference handling
  - Asset caching

- **Routing Integration** 🛣️

  - Automatic route generation from content
  - Support for Vyuh framework schema
  - Dynamic route parameters
  - Nested route handling

- **Performance** ⚡
  - Efficient content caching
  - CDN support
  - Optimized network requests
  - Parallel content fetching

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_plugin_content_provider_sanity: ^1.0.0
```

## Usage 💡

### Basic Setup

Create and configure the Sanity content provider:

```dart
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:sanity_client/sanity_client.dart';
import 'package:vyuh_plugin_content_provider_sanity/vyuh_plugin_content_provider_sanity.dart';

final contentProvider = SanityContentProvider.withConfig(
  config: SanityConfig(
    projectId: '<project-id>',
    dataset: 'production',
    perspective: Perspective.published,  // or previewDrafts for draft content
    useCdn: true,                       // enable CDN for better performance
  ),
  cacheDuration: const Duration(minutes: 5),
);

void main() async {
  vc.runApp(
    features: () => [
      // your features here
    ],
    plugins: [
      contentProvider,
      // other plugins
    ],
  );
}
```

### Fetching Content

```dart
// Fetch a single document
final post = await contentProvider.fetchSingle<Post>(
  '*[_type == "post" && _id == $id][0]',
  fromJson: Post.fromJson,
  queryParams: {'id': 'post-123'},
);

// Fetch multiple documents
final posts = await contentProvider.fetchMultiple<Post>(
  '*[_type == "post" && category == $category]',
  fromJson: Post.fromJson,
  queryParams: {'category': 'tech'},
);

// Fetch by ID
final author = await contentProvider.fetchById<Author>(
  'author-123',
  fromJson: Author.fromJson,
);
```

### Working with Assets

```dart
// Get an ImageProvider for use in Image widget
final imageProvider = contentProvider.image(
  ImageReference(
    asset: Asset(ref: 'image-Tb9Ew8CXIwaY6R1kjMvI0uRR-2000x3000-jpg'),
  ),
  width: 800,
  height: 600,
  devicePixelRatio: 2,
  quality: 80,
  format: 'webp',
);

// Use in an Image widget
if (imageProvider != null) {
  Image(image: imageProvider)
}

// Get a file URL
final fileUrl = contentProvider.fileUrl(fileRef);
```

### Route Handling

```dart
// Fetch route by path
final route = await contentProvider.fetchRoute(
  path: '/blog/my-post',
);

// Fetch route by ID
final route = await contentProvider.fetchRoute(
  routeId: 'route-123',
);

if (route != null) {
  // Handle route content
}
```

## Configuration 🔧

The content provider can be configured with various options:

```dart
final provider = SanityContentProvider.withConfig(
  config: SanityConfig(
    projectId: '<project-id>',
    dataset: 'production',

    // Content delivery options
    useCdn: true,                    // Use CDN for better performance
    perspective: Perspective.published, // Content perspective

    // Cache configuration
    cacheDuration: Duration(minutes: 5),

    // Optional authentication
    token: '<your-token>',           // For accessing private datasets
  ),

  // Additional options
  debug: true,                       // Enable debug logging
  retryOptions: RetryOptions(        // Configure retry behavior
    maxAttempts: 3,
    delayFactor: Duration(seconds: 1),
  ),
);
```

## Error Handling 🚨

The provider includes proper error handling for various scenarios:

```dart
try {
  final post = await contentProvider.fetchSingle<Post>(
    '*[_type == "post" && _id == $id][0]',
    fromJson: Post.fromJson,
    queryParams: {'id': 'post-123'},
  );
  // Handle post
} on InvalidResultTypeException catch (e) {
  print('Type mismatch: Expected ${e.expectedType}, got ${e.actualType}');
} on SanityError catch (e) {
  print('Sanity API error: ${e.message}');
} on Exception catch (e) {
  print('Unexpected error: $e');
}

// When fetching route
try {
  final route = await contentProvider.fetchRoute(path: '/blog/my-post');
  if (route == null) {
    print('Route not found');
    return;
  }
  // Handle route
} on SanityError catch (e) {
  print('Error fetching route: ${e.message}');
}
```

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request. For major
changes, please open an issue first to discuss what you would like to change.

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for
  source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)
- Learn more about [Sanity.io](https://www.sanity.io/docs)

## License 📄

This project is licensed under the terms specified in the LICENSE file.
