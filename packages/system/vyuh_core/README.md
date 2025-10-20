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

# Vyuh Core 🚀

[![vyuh_core](https://img.shields.io/pub/v/vyuh_core.svg?label=vyuh_core&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_core)

The core library for the Vyuh framework, providing essential building blocks and
runtime functionality for building modular, scalable, CMS-driven Flutter
applications. This package is the foundation of the Vyuh ecosystem, offering a
robust plugin architecture, modular features, and an optional CMS-driven UI via
the extension mechanism.

## Features ✨

- **Feature-based Architecture** 🏗️: Build modular applications by breaking them
  into independent features, each encapsulating its own routes, UI, and business
  logic. Compose your app by assembling these features together.
- **Plugin Architecture** 🔌: Extensible plugin system for features like
  navigation, networking, telemetry, and content management
- **Content Management** 📝: Modular content provider system for handling
  different content types. Default support is for
  [Sanity.io CMS](https://www.sanity.io/). The Provider interface can also be
  used to add support for other CMS integrations.
- **Navigation** 🧭: Advanced routing capabilities using Go Router
- **State Management** 💫: Integrated MobX for reactive state management. You
  are also free to use your own State Management solution.
- **Networking** 🌐: Flexible HTTP client with retry capabilities
- **Telemetry** 📊: Configurable telemetry system for logging and error tracking
- **Analytics** 📊: Built-in analytics system for tracking user interactions and
  app usage
- **Dependency Injection** 💉: Simple yet powerful DI system for managing
  dependencies
- **Event System** 📡: Pub/sub event system for decoupled communication
- **Storage** 💾: Persistent storage capabilities for local data
- **Environment Variables** 🔧: Flexible configuration system for managing
  environment-specific settings
- **Locale**: the locale plugin to manage translations
- **Platform Widgets** 🎨: Customizable widgets for common UI patterns like
  loaders and error views

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_core: any
```

## Usage 💡

### Basic App Setup

The entry point of your Vyuh application. Here you configure the initial route,
register your features, and set up any custom plugins. Features are assembled as
an array, making it easy to add or remove functionality.

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;

void main() {
  vyuh.runApp(
    initialLocation: '/',
    plugins: _getPlugins(),
    features: () => [
      // Your features here
      counter.feature,
      auth.feature(),
    ],
  );
}
```

### Feature Definition

Features are the building blocks of your application. Each feature is
self-contained with its own routes, UI components, and business logic. Features
can be developed and tested independently, then composed together to create the
full application.

```dart
import 'package:vyuh_core/vyuh_core.dart';

final feature = FeatureDescriptor(
  name: 'feature_name',
  title: 'Feature Title',
  description: 'Feature description',
  icon: Icons.feature_icon,
  routes: () async {
    return [
      GoRoute(
        path: '/feature-path',
        builder: (context, state) {
          return const FeatureWidget();
        },
      ),
    ];
  },
);
```

### Plugin Configuration

Plugins extend the core functionality of your app. The plugin system is flexible
and allows you to configure various aspects like content management, environment
variables, and telemetry. You can also create custom plugins for specific needs.

Plugins are described with the `PluginDescriptor` class.

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;

PluginDescriptor _getPlugins() {
  // Enable URL reflection for navigation (optional)
  vyuh.DefaultNavigationPlugin.enableURLReflectsImperativeAPIs();
  vyuh.DefaultNavigationPlugin.usePathStrategy();

  return PluginDescriptor(
    // Configure content plugin
    content: vyuh.DefaultContentPlugin(
      provider: yourContentProvider,
    ),
    // Configure environment plugin
    env: vyuh.DefaultEnvPlugin(),
    // Configure telemetry
    telemetry: vyuh.TelemetryPlugin(
      providers: [vyuh.ConsoleLoggerTelemetryProvider()],
    ),
  );
}
```

### Custom Content Types 📝

A Content type represents a specific type of content that can be managed by the
content management system. You can create custom content types and layouts for
your app.

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'my_card.g.dart';

@JsonSerializable()
final class MyCard extends ContentItem {
  static const schemaName = 'myCard';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'My Card',
    fromJson: MyCard.fromJson,
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: CustomCardLayout(),
    defaultLayoutDescriptor: CustomCardLayout.typeDescriptor,
  );

  final String title;
  final ImageReference? image;
  final String description;
  final List<Action> actions;

  MyCard({
    required super.id,
    required this.title,
    this.image,
    required this.description,
    this.actions = const [],
  }) : super(schemaType: schemaName);

  factory MyCard.fromJson(Map<String, dynamic> json) => _$MyCardFromJson(json);
}
```

### Custom Content Layout 🎨

Layouts are used to configure the visual layout of a content item. You can have
a default layout and also create custom layouts for your content types.

```dart
@JsonSerializable()
final class CustomCardLayout extends LayoutConfiguration<MyCard> {
  static const schemaName = '${MyCard.schemaName}.layout.custom';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Custom Layout',
    fromJson: CustomCardLayout.fromJson,
  );

  CustomCardLayout() : super(schemaType: schemaName);

  @override
  Widget build(BuildContext context, MyCard content) {
    return Card(
      child: Column(
        children: [
          Text(content.title),
          ContentImage(ref: content.image),
        ],
      ),
    );
  }
}
```

### Analytics 📊

Track events and user interactions using the analytics plugin:

```dart
// Get analytics plugin
final analytics = vyuh.di.get<AnalyticsPlugin>();

// Track a simple event
analytics.reportEvent('page_view');

// Track event with parameters
analytics.reportEvent(
  'button_click',
  params: {
    'button_id': 'submit',
    'screen': 'checkout',
  },
);

// Configure multiple providers
final analyticsPlugin = AnalyticsPlugin(
  providers: [
    GoogleAnalyticsProvider(),
    MixpanelProvider(),
    CustomAnalyticsProvider(),
  ],
);
```

### Navigation 🧭

Vyuh provides a simple yet powerful navigation system built on top of GoRouter.
The router is globally accessible through `vyuh.router`, making it easy to
navigate between routes from anywhere in your app.

For more information about GoRouter, visit the
[pub package](https://pub.dev/packages/go_router).

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;

// Navigate to a route
vyuh.router.push('/your-route');

// Navigate with named route
vyuh.router.pushNamed(
  'route-name',
  pathParameters: {'id': '123'},
  queryParameters: {'filter': 'active'},
);

// Go to a route (replaces current route)
vyuh.router.go('/your-route');

// Go back
vyuh.router.pop();
```

### State Management with MobX 💫

Vyuh comes with built-in support for MobX, providing reactive state management
out of the box. MobX's simple yet powerful approach makes it easy to manage
application state with minimal boilerplate.

```dart
import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// Create observable value
final counter = 0.obs();

// Use in widget with Observer
Column(
  children: [
    Observer(
      builder: (_) => Text('${counter.value}'),
    ),
    IconButton(
      icon: Icon(Icons.add),
      onPressed: () => runInAction(() => counter.value++),
    ),
  ],
);
```

### Dependency Injection 💉

A simple yet powerful dependency injection system for managing your app's
dependencies.

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;

// Register a dependency
vyuh.di.register<MyService>(() => MyServiceImpl());

// Get an instance
final service = vyuh.di.get<MyService>();
```

### Event System 📡

Use the event system for decoupled communication between different parts of your
app.

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;

// Subscribe to events
vyuh.events.on<UserLoggedIn>((event) {
  // Handle event
});

// Publish events
vyuh.events.emit(UserLoggedIn(userId: '123'));
```

### Storage 💾

Persist data locally using the storage plugin.

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;

// Store data
await vyuh.storage.set('key', 'value');

// Retrieve data
final value = await vyuh.storage.get('key');
```

### Environment Variables 🔧

Manage environment-specific configuration with the env plugin.

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;

// Access environment variables
final apiKey = vyuh.env.get('API_KEY');
final isDev = vyuh.env.get('IS_DEV', defaultValue: false);
```

### Platform Widgets 🎨

Customize the app's root widget and other platform-specific UI components. The
`defaultPlatformWidgetBuilder` provides default implementations that you can
customize using `copyWith`:

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;
import 'package:flutter_mobx/flutter_mobx.dart';

vyuh.runApp(
  platformWidgetBuilder:
      vyuh.defaultPlatformWidgetBuilder.copyWith(
        // Customize the root app widget
        appBuilder: (platform) {
          return Observer(
            builder: (_) {
              return MaterialApp.router(
                title: 'Your App',
                theme: YourTheme.light,
                darkTheme: YourTheme.dark,
                debugShowCheckedModeBanner: false,
                routerConfig: platform.router.instance,
              );
            },
          );
        },
        // Custom app loader shown during initial app load
        appLoader: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        // Custom content loader shown when loading content
        contentLoader: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        // Custom route loader shown during route transitions
        routeLoader: (context, color) {
          return DefaultRouteLoader(
            progressColor: color,
          );
        },
        // Custom error view for route errors
        routeErrorView: (context, error) {
          return Center(
            child: Text('Route Error: $error'),
          );
        },
        // Custom error view for general errors
        errorView: (context, error) {
          return Center(
            child: Text('Error: $error'),
          );
        },
        // Custom image placeholder
        imagePlaceholder: (context) {
          return const Center(
            child: Icon(Icons.image),
          );
        },
      ),
  // ... other configurations
);
```

The platform widget builder allows you to customize:

- `appBuilder`: The root app widget (typically MaterialApp.router)
- `appLoader`: Shown during initial app load
- `contentLoader`: Shown when loading content
- `routeLoader`: Shown during route transitions
- `routeErrorView`: Shown when a route fails to load
- `errorView`: Shown for general errors
- `imagePlaceholder`: Default placeholder for images

Each of these has a default implementation that you can override as needed.

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for
  source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

---

<p align="center">Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a></p>
