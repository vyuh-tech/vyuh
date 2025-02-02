# Sanity Client 🔌

[![sanity_client](https://img.shields.io/pub/v/sanity_client.svg?label=sanity_client&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/sanity_client)

A powerful Dart client for connecting to [Sanity.io](https://www.sanity.io)
projects and executing GROQ queries. This package provides a type-safe and
efficient way to interact with Sanity's HTTP API, making it easy to fetch and
manage content in your Dart and Flutter applications.

## Features ✨

- **GROQ Support** 🔍: Execute powerful GROQ queries with full type safety
- **HTTP API Support** 🌐:
  - Complete support for Sanity's HTTP API parameters
  - Configurable API versions
  - Published/Draft content perspectives
  - Query explanations for debugging
  - CDN support for better performance
- **Asset Handling** 🖼️:
  - Flexible image URL builders
  - Support for external image services (Cloudinary, ImageKit)
  - File asset management
- **Type Safety** 🛡️:
  - Strong typing for queries and responses
  - Proper error handling and validation
  - Null safety support

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  sanity_client: ^1.0.0
```

## Usage 💡

### Basic Setup

Create a SanityClient instance with your project configuration:

```dart
import 'package:sanity_client/sanity_client.dart';

final client = SanityClient(
  SanityConfig(
    projectId: 'your_project_id',
    dataset: 'your_dataset',
    apiVersion: 'v2024-02-16',
    useCdn: true,
  ),
);
```

### Executing Queries

Run GROQ queries to fetch your content:

```dart
// Simple query
final movies = await client.fetch('''
  *[_type == "movie"] {
    _id,
    title,
    releaseDate,
    "director": crewMembers[job == "Director"][0].person->name
  }
''');

// Query with parameters
final recentMovies = await client.fetch('''
  *[_type == "movie" && releaseDate >= \$fromDate] {
    _id,
    title,
    releaseDate,
    "poster": poster.asset->url
  }
''', parameters: {
  'fromDate': '2024-01-01',
});
```

### Image URL Building

Generate image URLs with transformations:

```dart
final imageUrl = client.imageUrl
    .image(imageRef)
    .width(800)
    .height(600)
    .fit('crop')
    .toString();
```

### Custom Image Service (Optional and only indicative)

Use external image services:

```dart
// Using Cloudinary
client.imageUrlBuilder = (ref) {
  return CloudinaryUrlBuilder(
    cloudName: 'your-cloud-name',
    imageId: ref.asset.id,
  );
};
```

## Configuration 🔧

The `SanityConfig` class supports various options:

```dart
final config = SanityConfig(
  projectId: 'your_project_id',
  dataset: 'your_dataset',

  // Authentication (optional)
  token: 'your_token',  // For accessing private datasets

  // Content delivery options
  useCdn: true,         // Use CDN for better performance
  perspective: Perspective.published,  // switching perspectives for query execution

  // API options
  apiVersion: 'v2024-02-16',
  explainQuery: false,  // Get query explanations for debugging
);
```

## Error Handling 🚨

The client provides proper error handling:

```dart
try {
  final result = await client.fetch(query);
  // Handle success
} on SanityError catch (e) {
  // Handle Sanity-specific errors
  print('Sanity error: ${e.message}');
} catch (e) {
  // Handle other errors
  print('Error: $e');
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

---

<p align="center">Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a></p>
