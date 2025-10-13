# Vyuh Internationalization (i18n) Guide

> Complete guide to implementing multi-language support in Vyuh Framework applications using the LocalePlugin and Slang.

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

Vyuh's internationalization system is built on three pillars:

1. **LocalePlugin** - Centralized locale management with reactive state using MobX
2. **Slang** - Type-safe translation code generation with deferred loading support
3. **TranslationRegistration** - Feature-level translation registration and provider nesting

```
┌─────────────────────────────────────────────────────────────┐
│                       Application Root                       │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              LocalePlugin (MobX Observable)            │ │
│  │  - currentLocale: Observable<Locale>                   │ │
│  │  - supportedLocales: List<LocaleConfiguration>         │ │
│  │  - registrations: List<TranslationRegistration>        │ │
│  └────────────────────────────────────────────────────────┘ │
│                              ↓                               │
│                    Nested TranslationProviders               │
│         ┌──────────────────┬──────────────────┐             │
│         ↓                  ↓                  ↓              │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐       │
│  │  Feature A  │   │  Feature B  │   │  Feature C  │       │
│  │ Translation │   │ Translation │   │ Translation │       │
│  │  Provider   │   │  Provider   │   │  Provider   │       │
│  └─────────────┘   └─────────────┘   └─────────────┘       │
│         ↓                  ↓                  ↓              │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐       │
│  │  UI Widgets │   │  UI Widgets │   │  UI Widgets │       │
│  │  using t.   │   │  using t.   │   │  using t.   │       │
│  └─────────────┘   └─────────────┘   └─────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

### Key Design Principles

1. **Reactive Locale State** - MobX observable ensures all UI responds to locale changes
2. **Deferred Loading** - Translations loaded asynchronously to reduce initial bundle size
3. **Feature Isolation** - Each feature manages its own translations independently
4. **Type Safety** - Slang generates compile-time checked translation keys
5. **Provider Nesting** - Multiple TranslationProviders compose naturally

---

## Core Components

### 1. LocalePlugin

The **LocalePlugin** is the central coordinator for all localization in a Vyuh application.

```dart
class LocalePlugin extends Plugin {
  // Reactive locale state (MobX Observable)
  final _currentLocale = Observable<Locale>(Locale('en'));
  Locale get currentLocale => _currentLocale.value;

  // Supported locales configuration
  final List<LocaleConfiguration> locales;

  // Feature translation registrations
  final List<TranslationRegistration> _registrations = [];

  // Change locale and notify all registered features
  Future<void> changeLocale(Locale newLocale) async {
    runInAction(() => _currentLocale.value = newLocale);

    // Notify all registered features (async for deferred loading)
    for (final registration in _registrations) {
      await registration.onLocaleChange(newLocale);
    }

    // Persist to SharedPreferences
    await _saveLocale(newLocale);
  }

  // Register feature translations
  void registerTranslations(TranslationRegistration registration) {
    _registrations.add(registration);
  }
}
```

**Key Features:**
- MobX Observable for reactive UI updates
- Async locale change for deferred loading support
- SharedPreferences persistence
- Feature registration management

### 2. LocaleConfiguration

Defines metadata for each supported locale.

```dart
class LocaleConfiguration {
  final Locale locale;
  final String nativeName;  // How the language calls itself
  final String icon;        // Flag emoji or icon

  const LocaleConfiguration({
    required this.locale,
    required this.nativeName,
    required this.icon,
  });

  // Predefined configurations
  static const english = LocaleConfiguration(
    locale: Locale('en'),
    nativeName: 'English',
    icon: '🇺🇸',
  );

  static const hindi = LocaleConfiguration(
    locale: Locale('hi'),
    nativeName: 'हिंदी',
    icon: '🇮🇳',
  );

  static const german = LocaleConfiguration(
    locale: Locale('de'),
    nativeName: 'Deutsch',
    icon: '🇩🇪',
  );
}
```

### 3. TranslationRegistration

Interface for features to register their translations.

```dart
class TranslationRegistration {
  /// Callback when locale changes (async to support deferred loading)
  final Future<void> Function(Locale locale) onLocaleChange;

  /// Provider widget to wrap the app
  final Widget Function(Widget child) provider;

  const TranslationRegistration({
    required this.onLocaleChange,
    required this.provider,
  });
}
```

**Purpose:**
- **onLocaleChange**: Called when user changes locale, updates feature's LocaleSettings
- **provider**: Wraps app with feature's TranslationProvider for context-based access

---

## Setting Up Slang

Slang is a Flutter internationalization framework that generates type-safe, compile-time checked translation code.

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
# slang.yaml
base_locale: en
input_directory: lib/i18n
output_directory: lib/generated
output_file_name: entity_translations.g.dart
fallback_strategy: base_locale
string_interpolation: double_braces
namespaces: true
translate_var: t
lazy: true
locale_handling: true
flutter_integration: true
key_case: camel
```

**Key Configuration Options:**

- `base_locale: en` - Primary language (fallback)
- `input_directory: lib/i18n` - Where JSON translation files live
- `output_directory: lib/generated` - Where generated Dart code goes
- `output_file_name: entity_translations.g.dart` - Generated file name
- `string_interpolation: double_braces` - Use `{placeholder}` syntax
- `lazy: true` - Enable deferred loading for non-base locales
- `locale_handling: true` - Generate LocaleSettings class
- `flutter_integration: true` - Generate TranslationProvider widget

### 3. Create Translation Files

Structure your translations in JSON files following the pattern `strings_<locale>.i18n.json`:

```
lib/
├── i18n/
│   ├── strings_en.i18n.json  # English (base)
│   ├── strings_hi.i18n.json  # Hindi
│   └── strings_de.i18n.json  # German
└── generated/
    └── entity_translations.g.dart  # Generated by slang
```

**Example Translation File** (`strings_en.i18n.json`):

```json
{
  "common": {
    "actions": {
      "create": "Create",
      "edit": "Edit",
      "delete": "Delete",
      "save": "Save",
      "cancel": "Cancel"
    },
    "labels": {
      "id": "ID",
      "name": "Name",
      "createdAt": "Created At",
      "updatedAt": "Updated At",
      "status": "Status"
    },
    "messages": {
      "loading": "Loading...",
      "noData": "No data available",
      "error": "An error occurred",
      "entityCreated": "{entity} successfully created!",
      "confirmDelete": "Are you sure you want to delete {count} item(s)?"
    }
  }
}
```

**String Interpolation:**
- Use `{placeholder}` syntax for dynamic values
- Replace at call site: `t.messages.entityCreated.replaceAll('{entity}', 'Equipment')`

### 4. Generate Translation Code

Run the Slang code generator:

```bash
dart run slang
```

This generates a Dart file with:
- Type-safe translation keys
- AppLocale enum for supported locales
- LocaleSettings for locale management
- TranslationProvider widget for context access
- Deferred loading support for non-base locales

**Generated Code Structure:**

```dart
// entity_translations.g.dart (simplified)

enum AppLocale {
  en(languageCode: 'en'),
  hi(languageCode: 'hi'),
  de(languageCode: 'de');
}

class LocaleSettings {
  static AppLocale currentLocale = AppLocale.en;

  static Future<void> setLocale(AppLocale locale) async {
    currentLocale = locale;
    // Trigger deferred loading if needed
    await locale.build();
  }
}

class TranslationProvider extends StatelessWidget {
  final Widget child;
  const TranslationProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return InheritedLocaleData<AppLocale, Translations>(
      locale: LocaleSettings.currentLocale,
      child: child,
    );
  }
}

// Access translations
Translations get t => LocaleSettings.instance.currentTranslations;
```

---

## Feature Registration

Features register their translations during initialization using the `TranslationRegistration` pattern.

### Complete Feature Setup

```dart
// lib/feature.dart
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'generated/entity_translations.g.dart' as entity_t;

final feature = FeatureDescriptor(
  name: 'entity_system',
  title: 'Vyuh Entity System',
  init: () async {
    // Get the LocalePlugin instance
    final localePlugin = vyuh.getPlugin<LocalePlugin>();

    if (localePlugin != null) {
      // Register this feature's translations
      localePlugin.registerTranslations(
        TranslationRegistration(
          // Called when locale changes
          onLocaleChange: (locale) async {
            final appLocale = _convertToEntityAppLocale(locale);
            await entity_t.LocaleSettings.setLocale(appLocale);
          },

          // Provider to wrap the app
          provider: (child) => entity_t.TranslationProvider(child: child),
        ),
      );
    }
  },
);

/// Convert Flutter Locale to feature's AppLocale enum
entity_t.AppLocale _convertToEntityAppLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return entity_t.AppLocale.en;
    case 'hi':
      return entity_t.AppLocale.hi;
    case 'de':
      return entity_t.AppLocale.de;
    default:
      return entity_t.AppLocale.en; // Fallback
  }
}
```

### What Happens During Registration?

1. **Feature init() called** - During app startup
2. **localePlugin.registerTranslations()** - Feature registers its translation configuration
3. **onLocaleChange stored** - LocalePlugin saves the callback
4. **provider stored** - LocalePlugin saves the provider function
5. **Provider nested** - LocalePlugin wraps app with all registered providers

---

## Locale Change Flow

When a user changes the application locale, here's the complete flow:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. User selects new locale in UI                            │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. localePlugin.changeLocale(newLocale) called              │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. Update MobX Observable                                    │
│    runInAction(() => _currentLocale.value = newLocale)      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. Notify all registered features (async)                   │
│    for (registration in _registrations) {                   │
│      await registration.onLocaleChange(newLocale);          │
│    }                                                         │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. Each feature updates its LocaleSettings                  │
│    Feature A: await LocaleSettings.setLocale(appLocale)     │
│    Feature B: await LocaleSettings.setLocale(appLocale)     │
│    Feature C: await LocaleSettings.setLocale(appLocale)     │
│    (Deferred libraries loaded if needed)                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. TranslationProviders rebuild                             │
│    InheritedWidget notifies dependent widgets               │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 7. All UI widgets using t.strings rebuild with new locale   │
│    Text(entity_t.t.strings.common.actions.save)             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 8. Persist locale to SharedPreferences                      │
│    await prefs.setString('locale', newLocale.languageCode)  │
└─────────────────────────────────────────────────────────────┘
```

### Why Async?

The locale change is **asynchronous** to support **deferred loading**:

```dart
// When locale changes to Hindi
await entity_t.LocaleSettings.setLocale(entity_t.AppLocale.hi);

// Internally triggers deferred loading:
await l_hi.loadLibrary();  // Load Hindi translations
return l_hi.TranslationsHi();
```

This reduces initial bundle size by loading translations on-demand.

---

## Best Practices

### 1. FieldMetadata Dual-Purpose Pattern

When registering field metadata for formatters, use **both** `displayName` and `displayNameResolver`:

```dart
FieldFormatterRegistry.registerGlobalField(
  'created_at',
  FieldMetadata(
    type: FieldType.dateTime,
    displayName: 'Created At',  // Static English for code readability
    displayNameResolver: () => entity_t.t.strings.common.labels.createdAt,  // Dynamic i18n
  ),
);
```

**Why both?**
- `displayName` - Provides immediate understanding in code and serves as fallback
- `displayNameResolver` - Ensures display name updates when locale changes

### 2. Translation Access Pattern

Access translations using the generated `t` variable:

```dart
import 'package:my_feature/generated/entity_translations.g.dart' as entity_t;

// Simple string
Text(entity_t.t.strings.common.actions.save)

// With interpolation
Text(
  entity_t.t.strings.common.messages.entityCreated
    .replaceAll('{entity}', 'Equipment')
)

// Multiple placeholders
Text(
  entity_t.t.strings.common.messages.confirmDelete
    .replaceAll('{count}', '5')
)
```

### 3. Avoid Hardcoded Strings

❌ **Bad:**
```dart
Text('Save')
Text('Created at: ${timestamp}')
showSnackBar(SnackBar(content: Text('Successfully created!')));
```

✅ **Good:**
```dart
Text(entity_t.t.strings.common.actions.save)
Text('${entity_t.t.strings.common.labels.createdAt}: ${timestamp}')
showSnackBar(
  SnackBar(
    content: Text(entity_t.t.strings.common.messages.createSuccess)
  )
);
```

### 4. Translation File Organization

Organize translations hierarchically for maintainability:

```json
{
  "common": {
    "actions": { ... },
    "labels": { ... },
    "messages": { ... }
  },
  "features": {
    "equipment": { ... },
    "users": { ... }
  },
  "errors": {
    "validation": { ... },
    "network": { ... }
  }
}
```

### 5. Consistent Naming Conventions

- **Actions**: Verbs (create, edit, delete, save, cancel)
- **Labels**: Nouns (id, name, status, createdAt)
- **Messages**: Complete sentences (loading, noData, successfullyCreated)
- **Keys**: camelCase (entityCreated, confirmDelete)

### 6. Handle Locale Conversion

Always provide a locale converter function:

```dart
MyFeatureAppLocale _convertToAppLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return MyFeatureAppLocale.en;
    case 'hi':
      return MyFeatureAppLocale.hi;
    case 'de':
      return MyFeatureAppLocale.de;
    default:
      return MyFeatureAppLocale.en; // Always provide fallback
  }
}
```

### 7. Testing Translations

Test that all locales are properly registered:

```dart
test('all locales have translations', () {
  for (final locale in [AppLocale.en, AppLocale.hi, AppLocale.de]) {
    final translations = locale.buildSync();
    expect(translations.strings.common.actions.save, isNotEmpty);
  }
});
```

---

## Complete Example

Here's a complete example of setting up internationalization for a new feature.

### Step 1: Create Translation Files

```
my_feature/
├── lib/
│   ├── i18n/
│   │   ├── strings_en.i18n.json
│   │   ├── strings_hi.i18n.json
│   │   └── strings_de.i18n.json
│   ├── generated/
│   └── feature.dart
├── slang.yaml
└── pubspec.yaml
```

**strings_en.i18n.json:**
```json
{
  "equipment": {
    "title": "Equipment",
    "subtitle": "Manage laboratory equipment",
    "actions": {
      "calibrate": "Calibrate",
      "retire": "Retire"
    },
    "fields": {
      "serialNumber": "Serial Number",
      "manufacturer": "Manufacturer",
      "model": "Model"
    },
    "messages": {
      "calibrationDue": "Calibration due in {days} days",
      "retireConfirm": "Are you sure you want to retire {name}?"
    }
  }
}
```

**strings_hi.i18n.json:**
```json
{
  "equipment": {
    "title": "उपकरण",
    "subtitle": "प्रयोगशाला उपकरण प्रबंधित करें",
    "actions": {
      "calibrate": "अंशांकन करें",
      "retire": "सेवानिवृत्त करें"
    },
    "fields": {
      "serialNumber": "क्रम संख्या",
      "manufacturer": "निर्माता",
      "model": "मॉडल"
    },
    "messages": {
      "calibrationDue": "{days} दिनों में अंशांकन आवश्यक",
      "retireConfirm": "क्या आप {name} को सेवानिवृत्त करना चाहते हैं?"
    }
  }
}
```

### Step 2: Create Slang Configuration

**slang.yaml:**
```yaml
base_locale: en
input_directory: lib/i18n
output_directory: lib/generated
output_file_name: my_feature_translations.g.dart
fallback_strategy: base_locale
string_interpolation: double_braces
namespaces: true
translate_var: t
lazy: true
locale_handling: true
flutter_integration: true
key_case: camel
```

### Step 3: Generate Translations

```bash
cd my_feature
dart run slang
```

### Step 4: Register Feature

**feature.dart:**
```dart
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'generated/my_feature_translations.g.dart' as my_t;

final feature = FeatureDescriptor(
  name: 'my_feature',
  title: 'My Feature',
  init: () async {
    // Register translations
    final localePlugin = vyuh.getPlugin<LocalePlugin>();
    if (localePlugin != null) {
      localePlugin.registerTranslations(
        TranslationRegistration(
          onLocaleChange: (locale) async {
            final appLocale = _convertToAppLocale(locale);
            await my_t.LocaleSettings.setLocale(appLocale);
          },
          provider: (child) => my_t.TranslationProvider(child: child),
        ),
      );
    }

    // Register field formatters with i18n
    FieldFormatterRegistry.registerGlobalField(
      'serial_number',
      FieldMetadata(
        type: FieldType.text,
        displayName: 'Serial Number',  // Static fallback
        displayNameResolver: () => my_t.t.strings.equipment.fields.serialNumber,
      ),
    );
  },
);

my_t.AppLocale _convertToAppLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return my_t.AppLocale.en;
    case 'hi':
      return my_t.AppLocale.hi;
    case 'de':
      return my_t.AppLocale.de;
    default:
      return my_t.AppLocale.en;
  }
}
```

### Step 5: Use in UI

**equipment_list.dart:**
```dart
import 'package:flutter/material.dart';
import '../generated/my_feature_translations.g.dart' as my_t;

class EquipmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(my_t.t.strings.equipment.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final equipment = equipmentList[index];
          return ListTile(
            title: Text(equipment.name),
            subtitle: Text(
              my_t.t.strings.equipment.messages.calibrationDue
                .replaceAll('{days}', '${equipment.daysUntilCalibration}'),
            ),
            trailing: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => _showCalibrateDialog(context, equipment),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createEquipment(context),
        child: Icon(Icons.add),
        tooltip: my_t.t.strings.equipment.actions.create,
      ),
    );
  }

  void _showCalibrateDialog(BuildContext context, Equipment equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(my_t.t.strings.equipment.actions.calibrate),
        content: Text(
          my_t.t.strings.equipment.messages.retireConfirm
            .replaceAll('{name}', equipment.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(my_t.t.strings.common.actions.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform calibration
              Navigator.pop(context);
            },
            child: Text(my_t.t.strings.equipment.actions.calibrate),
          ),
        ],
      ),
    );
  }
}
```

---

## Advanced Patterns

### 1. Dynamic Field Name Resolution

For system-generated fields that need dynamic translation:

```dart
class DynamicFieldFormatter {
  String formatFieldName(String fieldName) {
    final registry = FieldFormatterRegistry.global();
    return registry.formatName(fieldName);  // Uses displayNameResolver if available
  }
}
```

### 2. Context-Based Translation Access

Use context extension for cleaner code:

```dart
extension BuildContextTranslationsExtension on BuildContext {
  MyFeatureTranslations get t => my_t.TranslationProvider.of(this).translations;
}

// Usage in widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(context.t.equipment.title);  // Cleaner access
  }
}
```

### 3. Pluralization

While Slang supports pluralization, for simple cases use conditional logic:

```json
{
  "messages": {
    "itemCount": "{count} item(s)",
    "itemCountSingular": "1 item",
    "itemCountPlural": "{count} items"
  }
}
```

```dart
String getItemCountMessage(int count) {
  if (count == 1) {
    return my_t.t.strings.messages.itemCountSingular;
  }
  return my_t.t.strings.messages.itemCountPlural.replaceAll('{count}', '$count');
}
```

### 4. Error Message Localization

Create a structured error message system:

```json
{
  "errors": {
    "network": {
      "title": "Network Error",
      "message": "Unable to connect to server",
      "suggestion": "Please check your internet connection and try again"
    },
    "validation": {
      "required": "{field} is required",
      "invalid": "{field} is invalid",
      "tooShort": "{field} must be at least {min} characters"
    }
  }
}
```

```dart
void showError(BuildContext context, String errorType, {Map<String, String>? params}) {
  final errorConfig = my_t.t.strings.errors.validation;
  var message = errorConfig[errorType] ?? errorConfig.required;

  params?.forEach((key, value) {
    message = message.replaceAll('{$key}', value);
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
```

---

## Summary

The Vyuh internationalization system provides:

✅ **Type-safe translations** with compile-time checking
✅ **Reactive locale changes** via MobX observables
✅ **Deferred loading** for optimized bundle size
✅ **Feature isolation** with independent translation management
✅ **Provider nesting** for clean composition
✅ **String interpolation** for dynamic content
✅ **Dual-purpose metadata** for code readability and runtime i18n

By following this guide, you can implement robust multi-language support throughout your Vyuh application with minimal boilerplate and maximum maintainability.

---

## Resources

- [Slang Documentation](https://pub.dev/packages/slang)
- [Flutter Internationalization Guide](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [MobX State Management](https://pub.dev/packages/mobx)
- [Vyuh Framework](https://vyuh.tech)

---

**Last Updated:** 2025-10-13
**Vyuh Version:** 1.x
**Slang Version:** 3.31.0
