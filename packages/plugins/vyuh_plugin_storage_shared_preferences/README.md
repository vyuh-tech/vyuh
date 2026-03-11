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

# Vyuh SharedPreferences Storage Plugin

[![vyuh_plugin_storage_shared_preferences](https://img.shields.io/pub/v/vyuh_plugin_storage_shared_preferences.svg?label=vyuh_plugin_storage_shared_preferences&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_plugin_storage_shared_preferences)

A storage plugin for Vyuh using SharedPreferences as the backend. This plugin
provides a lightweight key-value storage solution that integrates seamlessly
with the Vyuh framework, using the platform's native preferences system.

## Features

- **Key-value Storage**: Simple string-based storage using SharedPreferences
- **Cross-platform**: Uses NSUserDefaults (iOS/macOS), SharedPreferences
  (Android), localStorage (Web)
- **Auto-initialization**: Automatic setup and cleanup
- **No Entitlements Required**: Works on all platforms without signing or
  entitlements (unlike Keychain-based solutions)
- **Persistence**: Data persists across app restarts

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_plugin_storage_shared_preferences: any
```

## Usage

### Plugin Registration

Register the storage plugin with your Vyuh application:

```dart
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_plugin_storage_shared_preferences/shared_preferences_storage_plugin.dart';

void main() {
  vc.runApp(
    plugins: PluginDescriptor(
      // ... other plugins
      storage: SharedPreferencesStoragePlugin(),
    ),
    features: () => [
      // your features
    ],
  );
}
```

### Storage Operations

Access and manipulate stored data:

```dart
// Get the storage plugin
final storage = vyuh.getPlugin<StoragePlugin>();

// Write data
await storage.write('key', 'value');

// Read data
final value = await storage.read('key');

// Check if key exists
final exists = await storage.has('key');

// Delete data
await storage.delete('key');
```

## Implementation Details

- **SharedPreferences Backend**: Uses Flutter's `shared_preferences` plugin for
  cross-platform key-value storage
- **String Storage**: All values are stored as strings via `setString()` /
  `getString()`
- **Platform Backends**:
  - iOS/macOS: `NSUserDefaults`
  - Android: `SharedPreferences`
  - Web: `localStorage`
  - Linux: `XDG` directories
  - Windows: `RoamingAppData`
- **Resource Management**: Proper cleanup on plugin disposal

## When to Use

Use this plugin for non-sensitive application data such as:

- User preferences (theme, locale, persona)
- Cached permission lists
- Session tokens in trusted environments
- Onboarding state

For sensitive data requiring encryption, consider `vyuh_plugin_storage_secure`
instead.

---

<p align="center">Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a></p>
