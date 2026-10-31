---
title: Hive Storage Plugin
description: Package responsibilities and setup for vyuh_plugin_storage_hive.
---

# Hive Storage Plugin

HiveStoragePlugin persists general values in a Hive box. The boxName selects the store. This is general storage, not the SecureStoragePlugin contract.

```mermaid
flowchart LR
  Feature["Feature storage requests"] --> Plugin["HiveStoragePlugin"]
  Plugin --> Box["Named Hive box"]
```

[Browse every public declaration and member](/api/vyuh-plugin-storage-hive).



<PubBadge package="vyuh_plugin_storage_hive" />

The `vyuh_plugin_storage_hive` package provides a storage plugin implementation for the Vyuh Framework using [Hive](https://pub.dev/packages/hive_ce), a lightweight and fast key-value database for Flutter and Dart.

## Overview

This plugin implements the `StoragePlugin` interface from `vyuh_core`, providing persistent key-value storage for non-sensitive application data. It is suitable for caching user preferences, app state, and other data that does not require encryption.

## Usage

```dart
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_plugin_storage_hive/vyuh_plugin_storage_hive.dart';

void main() {
  vc.runApp(
    plugins: vc.PluginDescriptor(
      storage: HiveStoragePlugin(),
      // ... other plugins
    ),
    features: () => [
      // ... features
    ],
  );
}
```

Once configured, you can access storage through the Vyuh platform:

```dart
final storage = vc.vyuh.getPlugin<vc.StoragePlugin>()!;

// Write a value
await storage.write('key', 'value');

// Read a value
final value = await storage.read('key');

// Check if a key exists
final exists = await storage.has('key');

// Delete a value
await storage.delete('key');
```

## Links

- [pub.dev](https://pub.dev/packages/vyuh_plugin_storage_hive)
- [GitHub Source](https://github.com/vyuh-tech/vyuh/tree/main/packages/plugins/vyuh_plugin_storage_hive)

Supported values follow Hive storage rules; custom types require registered adapters.
