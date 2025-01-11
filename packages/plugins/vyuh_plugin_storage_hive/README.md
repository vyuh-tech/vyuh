# Vyuh Hive Storage Plugin 📦

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

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh) for
  source code
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

## License 📄

This project is licensed under the terms specified in the LICENSE file.
