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

# Vyuh Hive Storage Plugin 📦

[![vyuh_plugin_storage_hive](https://img.shields.io/pub/v/vyuh_plugin_storage_hive.svg?label=vyuh_plugin_storage_hive&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_plugin_storage_hive)

A storage plugin for Vyuh using Hive as the backend. This plugin provides a
simple yet powerful key-value storage solution that integrates seamlessly with
the Vyuh framework.

## Features ✨

- **Key-value Storage** 🔑: Simple and fast storage using Hive
- **Configurable Box Name** 📝: Customize storage location for different use
  cases
- **Auto-initialization** 🚀: Automatic setup and cleanup
- **Type Safety** 🛡️: Full type safety for stored values
- **Persistence** 💾: Data persists across app restarts

## Installation 📦

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vyuh_plugin_storage_hive: any
```

## Usage 💡

### Plugin Registration 🔌

Register the storage plugin with your Vyuh application:

```dart
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_plugin_storage_hive/vyuh_plugin_storage_hive.dart';

void main() {
  vc.runApp(
    plugins: PluginDescriptor(
      // ... other plugins
      storage: HiveStoragePlugin(), // default box name
      // OR
      storage: HiveStoragePlugin(boxName: 'my_custom_box'),
    ),
    features: () => [
      // your features
    ],
  );
}
```

### Storage Operations 🔄

Access and manipulate stored data:

```dart
// Get the storage plugin
final storage = vyuh.getPlugin<StoragePlugin>();

// Write data ✍️
await storage.write('key', 'value');

// Read data 📖
final value = await storage.read('key');

// Check if key exists 🔍
final exists = await storage.has('key');

// Delete data 🗑️
await storage.delete('key');
```

## Implementation Details 🛠️

- **Hive Backend** 📊: Uses Hive's `Box` for efficient storage
- **Custom Storage** 🗄️: Data stored in configurable box (defaults to
  'vyuh_storage')
- **Flutter Support** 📱: Automatic Hive initialization for Flutter
- **Resource Management** 🧹: Proper cleanup on plugin disposal

## Configuration ⚙️

### Box Name Configuration 📝

Customize the storage location by specifying a box name:

```dart
vc.runApp(
  plugins: PluginDescriptor(
    storage: HiveStoragePlugin(boxName: 'my_custom_box'),
  ),
  // ...
);
```

This configuration enables:

- 🔀 Multiple storage boxes for different purposes
- 🔒 Data isolation between features
- 🤝 Data sharing across app components

---

<p align="center">Made with ❤️ by <a href="https://vyuh.tech">Vyuh</a></p>
