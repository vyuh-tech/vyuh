<p align="center">
  <a href="https://vyuh.tech">
    <img src="https://github.com/vyuh-tech.png" alt="Vyuh Logo" height="128" />
  </a>
  <h1 align="center">Vyuh Framework</h1>
  <p align="center">Build Modular, Scalable Flutter Apps</p>
  <p align="center">
    <a href="https://docs.vyuh.tech">Docs</a> |
    <a href="https://vyuh.tech">Website</a>
  </p>
</p>

# Vyuh Core 🚀

[![vyuh_core](https://img.shields.io/pub/v/vyuh_core.svg?label=vyuh_core&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_core)

The core library for the Vyuh framework, providing essential building blocks and
runtime functionality for building modular, scalable Flutter applications.
This package is the foundation of the Vyuh ecosystem, offering a robust plugin
architecture and modular features. It has no CMS dependency: CMS-driven UI is
an optional add-on
([`vyuh_extension_content`](https://pub.dev/packages/vyuh_extension_content))
built on the extension mechanism.

## Features ✨

- **Feature-based Architecture** 🏗️: Build modular applications by breaking them
  into independent features, each encapsulating its own routes, UI, and business
  logic. Compose your app by assembling these features together.
- **Plugin Architecture** 🔌: Extensible plugin system for features like
  navigation, networking, storage, auth and telemetry
- **Extensions** 🧩: Features contribute to shared registries through
  `ExtensionDescriptor` and `ExtensionBuilder`. The optional CMS add-on is
  built this way.
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
and allows you to configure various aspects like navigation, environment
variables, and telemetry. You can also create custom plugins for specific needs.

Plugins are described with the `PluginDescriptor` class.

```dart
import 'package:vyuh_core/vyuh_core.dart' as vyuh;

PluginDescriptor _getPlugins() {
  // Enable URL reflection for navigation (optional)
  vyuh.DefaultNavigationPlugin.enableURLReflectsImperativeAPIs();
  vyuh.DefaultNavigationPlugin.usePathStrategy();

  return PluginDescriptor(
    // Configure environment plugin
    env: vyuh.DefaultEnvPlugin(),
    // Configure telemetry
    telemetry: vyuh.TelemetryPlugin(
      providers: [vyuh.ConsoleLoggerTelemetryProvider()],
    ),
  );
}
```

### Using a CMS 📝

Content types, layouts and CMS-driven routes are not part of `vyuh_core`. Add
[`vyuh_extension_content`](https://pub.dev/packages/vyuh_extension_content)
and register its plugin with `PluginDescriptor(others: [DefaultContentPlugin(provider: ...)])`.
See the [CMS docs](https://docs.vyuh.tech/cms/).

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
whichever applies. A missing route, a failed lazy feature, a page that fails to
load and a failed startup all work this way. Failures are reported once to telemetry
and as a `RouteFailureEvent`. Error details show only in debug builds.

Restyle the defaults with `VyuhThemeExtension` tokens in your `ThemeData`, or
replace any builder with `copyWith`:

- `appBuilder`: the root app widget; read `platform.widgetBuilder.theme`
- `appLoader`, `routeLoader`, `contentLoader`: loaders (`contentLoader` is the
  inline one, for a part of a page)
- `routeErrorView`: full-page failures (`FailurePage` by default)
- `errorView`: inline failures (`FailureCard` by default)
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
