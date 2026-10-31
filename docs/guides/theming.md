---
title: Theming
description: Give the framework one theme, and its loaders, error views and placeholders follow it in light and dark mode.
---

# Theming

Give the app its theme once, with `VyuhTheme`. Every screen the framework draws
uses it:

- the loading screen before the app starts
- the startup failure screen
- the default app root
- route and content loaders
- error views
- placeholders

All of them follow light and dark mode.

```dart
runApp(
  platformWidgetBuilder: PlatformWidgetBuilder.system.copyWith(
    theme: VyuhTheme(
      light: MyDesign.light,
      dark: MyDesign.dark,
      mode: ThemeMode.system,
    ),
  ),
  features: () => [...],
);
```

For a quick start, `VyuhTheme.fromSeed(color)` builds Material 3 light and dark
themes from one color.

## Your own app root

If you build the root yourself in `appBuilder`, read the same theme from the
platform, so the first frame and the app match:

```dart
appBuilder: (context, platform) {
  final theme = platform.widgetBuilder.theme;
  return MaterialApp.router(
    theme: theme.light,
    darkTheme: theme.dark,
    themeMode: theme.mode,
    routerConfig: platform.router.instance,
  );
},
```

## Switching themes at runtime

The system feature's `ThemeService` starts from the same `VyuhTheme`. Read
`currentMode` inside an `Observer` to follow the user's choice and the
platform brightness:

```dart
appBuilder: (context, platform) => Observer(
  builder: (_) {
    final theme = platform.widgetBuilder.theme;
    final mode = platform.di.get<ThemeService>().currentMode.value;
    return MaterialApp.router(
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: mode,
      routerConfig: platform.router.instance,
    );
  },
),
```

The theme toggle action, the theme-mode condition and the theme modifier all
use this service. You don't need to call `setThemes` yourself.

## Framework tokens

To restyle the framework's own UI without replacing its widgets, add a
`VyuhThemeExtension` to your `ThemeData`. Any token you leave out falls back to
a value from the theme's `ColorScheme`:

```dart
ThemeData(
  colorSchemeSeed: brand,
  extensions: const [
    VyuhThemeExtension(
      loaderDelay: Duration(milliseconds: 300),
      showPoweredBy: false,
      radius: 16,
    ),
  ],
);
```

| Token | Used for | Falls back to |
|---|---|---|
| `appLoaderBackground` | Full-screen app loader | `surface` |
| `loaderColor` | All loaders | `primary` |
| `routeLoaderBackground` | Page behind a loading route | `surface` |
| `placeholderBackground`, `placeholderForeground` | Image and broken-widget placeholders | `surfaceContainerHighest`, `onSurfaceVariant` |
| `failureBackground`, `failureForeground` | Failure icon badge, inline failures | `errorContainer`, `onErrorContainer` |
| `debugBackground`, `debugForeground`, `debugBorder` | Debug-only diagnostics such as unknown content | `errorContainer`, `onErrorContainer`, `error` |
| `radius` | Cards, placeholders, diagnostics | `12` |
| `loaderDelay` | Wait before a route or content loader appears, so fast loads don't flash | `200ms` |
| `showPoweredBy` | "Powered by Vyuh" on the app loader | `true` |

Read the resolved tokens in your own widgets with
`VyuhThemeExtension.of(context)`.

## Replace a widget entirely

For a completely different loader or error view, replace the builder on
`PlatformWidgetBuilder`. See [platform customization](platform-customization)
and [errors and recovery](errors-and-recovery#customize-the-views).
