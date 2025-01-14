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

# Vyuh Developer Tools 🛠️

[![vyuh_feature_developer](https://img.shields.io/pub/v/vyuh_feature_developer.svg?label=vyuh_feature_developer&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_feature_developer)

A powerful developer toolset for Vyuh applications that provides insights into
your app's features, content, and plugins. This feature helps developers
understand and debug their Vyuh applications more effectively.

## Features ✨

- **Feature Explorer** 📋

  - List all registered features
  - View feature details including routes and extensions
  - Inspect feature configurations
  - Navigate feature hierarchies

- **Content Playground** 🎮

  - Preview content layouts in real-time
  - Test different content types
  - Experiment with layout configurations
  - Debug content rendering

- **Plugin Inspector** 🔍

  - View active plugins
  - Inspect plugin configurations
  - Monitor plugin states
  - Debug plugin interactions

- **Route Explorer** 🛣️
  - List all registered routes
  - View route parameters
  - Test route navigation
  - Debug route configurations

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_feature_developer: ^1.0.0
```

## Usage 💡

### Basic Setup

Add the developer feature to your Vyuh application:

```dart
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_developer/vyuh_feature_developer.dart' as developer;

void main() {
  vyuh.runApp(
    features: () => [
      developer.feature, // adds the developer tools
      // your other features
    ],
  );
}
```

### Accessing Developer Tools

The developer tools can be accessed through:

1. The feature list in your app's navigation
2. The `/developer` route in your app
3. The Developer Tools icon in the app bar (if enabled)

### Content Playground Usage

```dart
// Navigate to the content playground
vyuh.router.push('/developer/playground');
```

### Feature Inspector Usage

```dart
// Navigate to feature details
vyuh.router.push('/developer/feature/:name');
```

## Best Practices 🌟

1. **Development Only**

   - Consider disabling the developer tools in production
   - Use environment variables to control visibility

2. **Performance Monitoring**

   - Monitor content rendering performance
   - Check for unnecessary re-renders
   - Profile feature initialization

3. **Debugging**
   - Use the content playground for layout issues
   - Check plugin states for integration problems
   - Verify route configurations

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request. For major
changes, please open an issue first to discuss what you would like to change.

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for
  source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

## License 📄

This project is licensed under the terms specified in the LICENSE file.
