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
- **Event System** 📡: Typed events, with lifecycle events from the platform
  and declarative per-feature handlers
- **Errors and recovery** 🛟: Themed failure views that always offer a way out,
  reported once to telemetry and as events
- **Theming** 🎨: One `VyuhTheme` for every framework screen, plus design tokens
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
self-contained with its own routes, UI and business logic, and can also act on
the whole app through event handlers and redirects. The platform starts and
stops all of it with the feature, so there is nothing to clean up by hand.

```dart
import 'package:vyuh_core/vyuh_core.dart';

final feature = FeatureDescriptor(
  name: 'account',
  title: 'Account',
  routes: () => [
    GoRoute(path: '/account', builder: (_, _) => const AccountPage()),
  ],
  // App-level listeners, subscribed before init and removed on dispose.
  events: [
    EventHandler<SystemReadyEvent>((_) => restoreSession()),
  ],
  // App-wide redirects that re-run when their triggers fire.
  redirects: [
    FeatureRedirect(
      name: 'require-sign-in',
      refreshOn: [UserSignedOutEvent],
      redirect: (_, state) =>
          !signedIn && state.matchedLocation.startsWith('/account')
              ? '/login'
              : null,
    ),
  ],
);
```

Lazy features (`LazyFeatureDescriptor`) get the same behaviour when they
activate.

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

// Go to the home route (runApp's homeLocation)
vyuh.router.goHome();
```

Features add app-wide redirects with `FeatureDescriptor.redirects`. See
[Routes and navigation](https://docs.vyuh.tech/guides/routes-and-navigation#feature-redirects).

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

Features declare typed listeners with `FeatureDescriptor.events` (see above).
For shorter-lived listeners, subscribe directly and cancel with the returned
function:

```dart
final cancel = vyuh.event.on<UserSignedOutEvent>((event) { /* ... */ });
vyuh.event.emit(UserSignedOutEvent());
cancel();
```

The platform emits `SystemEvent`s for its lifecycle: `SystemInitStartedEvent`,
`FeatureLoadedEvent`, `FeatureLoadFailedEvent`, `SystemReadyEvent`,
`SystemInitFailedEvent` and `RouteFailureEvent`. Delivery is asynchronous.

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

### Theme, errors and platform widgets 🎨

Give the framework your theme once. The loading screen, the startup failure
screen, the default app root, loaders, error views and placeholders all follow
it in light and dark mode:

```dart
vyuh.runApp(
  homeLocation: '/', // where "Go home" leads from any failure
  platformWidgetBuilder: vyuh.PlatformWidgetBuilder.system.copyWith(
    theme: vyuh.VyuhTheme(light: MyDesign.light, dark: MyDesign.dark),
  ),
  features: () => [...],
);
```

Every route failure has a way out: Try again, Back, Go home, or Restart app,
whichever applies. A missing route, a failed lazy feature, a failed CMS page and
a failed startup all work this way. Failures are reported once to telemetry
and as a `RouteFailureEvent`. Error details show only in debug builds.

Restyle the defaults with `VyuhThemeExtension` tokens in your `ThemeData`, or
replace any builder with `copyWith`:

- `appBuilder`: the root app widget; read `platform.widgetBuilder.theme`
- `appLoader`, `routeLoader`, `contentLoader`: loaders
- `routeErrorView`: full-page failures (`FailurePage` by default)
- `errorView`: inline failures (`FailureCard` by default)
- `unknown`: debug view for unregistered content
- `imagePlaceholder`: image placeholder
- `theme`: the app's `VyuhTheme`

Inside a custom error view, `VyuhFailureScope.maybeOf(context)` gives the full
`VyuhFailure` and `FailureActions` tells you which actions apply. See
[Theming](https://docs.vyuh.tech/guides/theming) and
[Errors and recovery](https://docs.vyuh.tech/guides/errors-and-recovery).

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for
  source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

---

<p align="center">Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a></p>
