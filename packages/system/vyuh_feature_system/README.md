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

# Vyuh Feature System 🔧

[![vyuh_feature_system](https://img.shields.io/pub/v/vyuh_feature_system.svg?label=vyuh_feature_system&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_feature_system)

The system feature package for Vyuh framework, providing essential content
types, actions, conditions, and services for building CMS-driven Flutter
applications.

## Features ✨

### Content Types 📝

#### Routes 🧭

- **Page Routes**: Full-screen pages with various layouts

  - Default page layout with app bar and body
  - Tabs layout for sectioned content
  - Single item layout for focused content
  - Conditional layout for dynamic routing

- **Dialog Routes**: Modal dialogs with customizable content
  - Default dialog layout
  - Custom dialog layouts

#### Cards 🎴

- **Default Card**: Standard card layout with title, content, and actions
- **List Item Card**: Compact layout for list views
- **Button Card**: Interactive card with action triggers
- **Conditional Card**: Dynamic layout based on conditions

#### Groups 📦

- **Carousel**: Horizontal scrolling group of items

  - Auto-play support
  - Navigation controls
  - Custom transitions

- **Grid**: Responsive grid layout

  - Configurable columns
  - Responsive breakpoints
  - Custom item spacing

- **List**: Vertical list of items
  - Configurable spacing
  - Dividers support
  - Custom item layouts

#### Other Items 🔧

- **Portable Text**: Rich text content with custom marks
  - Action invocation marks
  - Link marks with custom styling
  - Custom block styles
- **Empty**: Empty content placeholder
- **Unknown**: Fallback for unknown content types
- **Conditional**: Content based on conditions

Each content type can be extended with custom layouts by implementing
`LayoutConfiguration<T>` and registering the layout in your feature descriptor.

### Actions 🎯

The system feature provides several built-in actions for navigation, UI control,
and system operations:

#### Navigation Actions 🧭

- **NavigateAction**: Navigate to a new route with optional query parameters
- **NavigateBackAction**: Return to the previous route in history
- **NavigateReplaceAction**: Replace current route with a new one
- **OpenUrlAction**: Open external URLs in browser or app

#### UI Actions 🎨

- **AlertAction**: Display snackbar messages with different types (success,
  error, info)
- **DrawerAction**: Show or hide the navigation drawer
- **OpenInDialogAction**: Display content in a modal dialog
- **ToggleThemeAction**: Switch between light and dark themes

#### System Actions ⚙️

- **DelayAction**: Add a timed delay between action executions
- **RouteRefreshAction**: Refresh the current route's content
- **RestartAction**: Restart the entire application

### Conditions 🔄

- **Boolean**: Simple boolean conditions
- **Feature Flag**: Toggle features based on conditions
- **Screen Size**: Responsive layouts based on screen size
- **Current Platform**: Platform-specific content
- **Theme Mode**: Theme-based content
- **User Authentication**: Content based on auth state

### Content Modifiers

Content modifiers allow you to transform content before rendering:

```dart
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

// Apply theme-based modifications
ThemeModifier(
  light: LightContent(),
  dark: DarkContent(),
);
```

### API Handlers

Configure API content handling:

```dart
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

final apiConfig = JsonPathApiConfiguration(
  baseUrl: 'https://api.example.com',
  paths: {
    'products': '$.items[*]',
    'categories': '$.categories[*]',
  },
);
```

### Services 🛠️

#### Breakpoint Service

Handle responsive layouts:

```dart
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

final breakpointService = vyuh.di.get<system.BreakpointService>();

Observer(
  builder: (_) {
    if (breakpointService.isMobile) {
      return MobileLayout();
    }
    if (breakpointService.isTablet) {
      return TabletLayout();
    }
    return DesktopLayout();
  },
);

// Custom breakpoints
breakpointService.setBreakpoints(
  mobile: 480,
  tablet: 768,
  desktop: 1024,
);
```

#### Theme Service

Manage app theme and mode:

```dart
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

// Get theme service
final themeService = vyuh.di.get<system.ThemeService>();

// Toggle theme
system.ToggleThemeAction().execute();

// Observe current theme mode
Observer(
  builder: (_) {
    final mode = themeService.currentMode.value;
    return Text('Current theme: $mode');
  },
);
```

### Content Extensions

Register content types and builders:

```dart
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

final feature = FeatureDescriptor(
  name: 'my_feature',
  extensions: [
    ContentExtensionDescriptor(
      contents: [
        // Your content descriptors
      ],
      contentBuilders: [
        Route.contentBuilder,
        Card.contentBuilder,
        Group.contentBuilder,
      ],
      contentModifiers: [
        ThemeModifier.modifier,
      ],
    ),
  ],
);
```

### System Routes

The system feature provides built-in routes:

#### Error Route

- Path: `/__system_error__`
- Purpose: Displays system errors with stack trace
- Usage: Automatically used by the framework for error handling

#### Navigation Route

- Path: `/__system_navigate__`
- Purpose: Handles external navigation (URLs, deep links)
- Usage: Automatically used by navigation actions

These routes are registered automatically when using the system feature and
provide consistent error handling and navigation behavior across your app.

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_feature_system: any
```

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for
  source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

---

<p align="center">Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a></p>
