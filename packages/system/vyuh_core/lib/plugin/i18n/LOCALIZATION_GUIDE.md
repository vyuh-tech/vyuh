# Vyuh Internationalization (i18n) Guide

How to add multi-language support to a Vyuh app with `LocalePlugin`, using
[slang](https://pub.dev/packages/slang) as the example translation library.
Any library works the same way.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Core Components](#core-components)
3. [Setting Up Slang](#setting-up-slang)
4. [Feature Registration](#feature-registration)
5. [Locale Change Flow](#locale-change-flow)
6. [Best Practices](#best-practices)
7. [Complete Example](#complete-example)
8. [Advanced Patterns](#advanced-patterns)

---

## Architecture Overview

The i18n support has three parts:

1. **LocalePlugin** holds the current locale as a MobX `Observable`, saves the
   user's language, and tells every registered feature when the language
   changes.
2. **TranslationRegistration** is how a feature hooks in: a `name` and an
   async `onLocaleChange` callback.
3. **Your translation library** (slang here) generates the strings and loads
   them, with deferred loading if you want it.

```
                 LocalePlugin
   currentLocale: Observable<Locale>
   isLoadingLocale: Observable<bool>
                      |
        setLocale(locale) awaits each
        registration's onLocaleChange
          /           |            \
   Feature A      Feature B      Feature C
   (slang)        (slang)        (any library)
```

`LocalePlugin` does not wrap your app in any widget and does not install
Flutter's localization delegates. You connect `currentLocale` to your
`MaterialApp` yourself (see [Complete Example](#complete-example)).

---

## Core Components

### 1. LocalePlugin

`LocalePlugin` is an optional plugin, so you register it in
`PluginDescriptor(others: [...])`. Its name is `'vyuh.plugin.locale'`. Read it
with `vyuh.locale` (null when it isn't registered) or
`vyuh.getPlugin<LocalePlugin>()`.

```dart
final localePlugin = LocalePlugin(
  locales: [english, hindi, german], // at least one
  defaultLocale: english,            // optional; locales.first if left out
);

runApp(
  features: () => [/* ... */],
  plugins: PluginDescriptor(others: [localePlugin]),
);
```

Its members:

| Member | What it does |
| --- | --- |
| `locales` | The `List<LocaleConfiguration>` you passed in |
| `defaultLocale` | The `defaultLocale` you passed, or `locales.first` |
| `supportedLocales` | `List<Locale>` of all configured locales, for `MaterialApp` |
| `currentLocale` | `Observable<Locale>`, the active locale. Read `.value` in an `Observer` |
| `currentLocaleCode` | The active language code, such as `'hi'` |
| `isLoadingLocale` | `Observable<bool>`, `true` while `setLocale` runs the callbacks |
| `setLocale(locale)` | `Future<bool>`. Switches language; `false` if it isn't configured |
| `useDeviceLocale()` | Switches to the configured locale for the device's language, or the default |
| `isLocaleActive(locale)` | `true` when `locale` has the current language code |
| `getLocaleName(code)` / `getLocaleIcon(code)` | The `nativeName` / `icon` for a language code |
| `registerTranslations(registration)` | Adds a feature's `TranslationRegistration` |
| `registrationCount` | How many registrations there are |

Matching is by **language code** only. `setLocale(Locale('hi', 'IN'))` makes
the configured `Locale('hi')` current, and saves `'hi'`.

### 2. LocaleConfiguration

Describes one supported language.

```dart
const english = LocaleConfiguration(
  locale: Locale('en'),
  nativeName: 'English', // how the language names itself
  icon: '🇺🇸',            // flag emoji or any short text
);

const hindi = LocaleConfiguration(
  locale: Locale('hi'),
  nativeName: 'हिन्दी',
  icon: '🇮🇳',
);

// The same, from a language code:
final german = LocaleConfiguration.fromCode('de', nativeName: 'Deutsch', icon: '🇩🇪');
```

### 3. TranslationRegistration

```dart
class TranslationRegistration {
  /// Name used in log messages.
  final String name;

  /// Called when the locale changes. Async, so you can load a deferred library.
  final Future<void> Function(Locale locale) onLocaleChange;

  const TranslationRegistration({
    required this.name,
    required this.onLocaleChange,
  });
}
```

There is no provider or widget field. If your library needs a widget (for
example slang's `TranslationProvider` for `context.t`), wrap it around the app
yourself in `appBuilder`.

---

## Setting Up Slang

### 1. Add Dependencies

```yaml
# pubspec.yaml
dependencies:
  slang_flutter: ^3.31.0

dev_dependencies:
  slang: ^3.31.0
  build_runner: ^2.4.0
```

### 2. Create Slang Configuration

Create `slang.yaml` in your package root:

```yaml
base_locale: en
input_directory: lib/i18n
output_directory: lib/generated
output_file_name: my_feature_translations.g.dart
fallback_strategy: base_locale
namespaces: true
translate_var: t
lazy: true
locale_handling: true
flutter_integration: true
key_case: camel
```

`lazy: true` makes slang load non-base languages as deferred libraries.
`locale_handling: true` generates `LocaleSettings`.

### 3. Create Translation Files

```
lib/
├── i18n/
│   ├── strings_en.i18n.json  # base language
│   ├── strings_hi.i18n.json
│   └── strings_de.i18n.json
└── generated/
    └── my_feature_translations.g.dart  # generated by slang
```

### 4. Generate Translation Code

```bash
dart run slang
```

This generates the `AppLocale` enum, `LocaleSettings`, the `t` accessor and,
with `flutter_integration`, a `TranslationProvider` widget.

---

## Feature Registration

Each feature registers its translations in its `init`. `LocalePlugin` starts
before any feature's `init`, so the plugin is ready there.

```dart
import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'generated/my_feature_translations.g.dart' as my_t;

final feature = FeatureDescriptor(
  name: 'my_feature',
  title: 'My Feature',
  init: () async {
    vyuh.locale?.registerTranslations(
      TranslationRegistration(
        name: 'my_feature',
        onLocaleChange: (locale) async {
          final appLocale = my_t.AppLocale.values.firstWhere(
            (l) => l.languageCode == locale.languageCode,
            orElse: () => my_t.AppLocale.en,
          );
          await my_t.LocaleSettings.setLocale(appLocale);
        },
      ),
    );
  },
  routes: () => [/* ... */],
);
```

What happens:

1. The registration is added to the plugin's list.
2. On the next microtask, the plugin calls `onLocaleChange` with the current
   locale, so the feature loads its strings. An error there is logged with
   `vyuh.log.error` as `Error initializing "<name>" translations`.
3. Every later `setLocale` calls `onLocaleChange` again.

---

## Locale Change Flow

```
1. The user picks a language
   -> vyuh.locale?.setLocale(Locale('hi'))
2. Unsupported language? Return false. Otherwise pick the configured locale
   for that language.
3. isLoadingLocale = true
4. For each registration, in order:
     await registration.onLocaleChange(locale)
   (a callback that throws is logged and skipped)
5. currentLocale = locale
   -> an Observer around MaterialApp rebuilds, with the strings already loaded
6. Save the language code under 'app_locale' in SharedPreferences
7. isLoadingLocale = false, and setLocale returns true
```

`currentLocale` changes only after every callback finished, so screens
rebuild with the new strings in place.

At startup, `init()` reads `'app_locale'`. If that language is configured it
calls `setLocale` with it; otherwise it calls `useDeviceLocale()`. `dispose()`
removes all registrations and resets `currentLocale` to the default locale.

---

## Best Practices

1. **Keep strings in each feature.** Each feature registers its own
   translations; no feature imports another's strings.
2. **Map languages with a fallback.** Your `onLocaleChange` gets a `Locale`.
   Map it to your library's locale type by `languageCode`, with a fallback to
   the base language.
3. **Use plain language locales** in `LocaleConfiguration`, such as
   `Locale('hi')`. Matching is by language code.
4. **Avoid hardcoded strings.** Use the generated accessors, for example
   `Text(my_t.t.common.actions.save)`.
5. **Keep text flexible.** Let labels wrap, test longer languages, and use
   the locale for dates, numbers and plurals.
6. **Test translations.** For example, check that every locale builds:

```dart
test('all locales have translations', () {
  for (final locale in my_t.AppLocale.values) {
    expect(locale.buildSync().common.actions.save, isNotEmpty);
  }
});
```

---

## Complete Example

### Connect the locale to `MaterialApp`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

final widgetBuilder = PlatformWidgetBuilder.system.copyWith(
  appBuilder: (_, platform) => Observer(
    builder: (_) {
      final locale = platform.locale; // null if LocalePlugin isn't registered
      final theme = platform.widgetBuilder.theme;

      return MaterialApp.router(
        routerConfig: platform.router.instance,
        theme: theme.light,
        darkTheme: theme.dark,
        themeMode: theme.mode,
        locale: locale?.currentLocale.value,
        supportedLocales: locale?.supportedLocales ?? const [Locale('en')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
      );
    },
  ),
);

void main() {
  runApp(
    platformWidgetBuilder: widgetBuilder,
    plugins: PluginDescriptor(
      others: [LocalePlugin(locales: [english, hindi])],
    ),
    features: () => [feature],
  );
}
```

### A language picker

```dart
class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final plugin = vyuh.locale;
    if (plugin == null) return const SizedBox.shrink();

    return Observer(
      builder: (_) => Column(
        children: [
          if (plugin.isLoadingLocale.value) const LinearProgressIndicator(),
          for (final config in plugin.locales)
            ListTile(
              leading: Text(config.icon),
              title: Text(config.nativeName),
              trailing: plugin.isLocaleActive(config.locale)
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => plugin.setLocale(config.locale),
            ),
        ],
      ),
    );
  }
}
```

To go back to the device language, call `vyuh.locale?.useDeviceLocale()`.

---

## Advanced Patterns

### Context-based access

Slang's `context.t` needs its `TranslationProvider` above the widget. Vyuh
does not add it for you, so wrap it around the app in `appBuilder`:

```dart
appBuilder: (_, platform) => my_t.TranslationProvider(
  child: Observer(builder: (_) => MaterialApp.router(/* as above */)),
),
```

### Extra behaviour on a change

To do more when the language changes, such as saving it to the user's
account, extend `LocalePlugin` and override `setLocale`:

```dart
class AccountLocalePlugin extends LocalePlugin {
  AccountLocalePlugin({required super.locales});

  @override
  Future<bool> setLocale(Locale locale) async {
    final changed = await super.setLocale(locale);
    if (changed) {
      await vyuh.analytics.reportEvent(
        'language_changed',
        params: {'language': locale.languageCode},
      );
    }
    return changed;
  }
}
```

`vyuh.locale` still finds it, because the lookup matches subclasses of
`LocalePlugin`.

---

## Resources

- [Slang documentation](https://pub.dev/packages/slang)
- [Flutter internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [MobX](https://pub.dev/packages/mobx)
