---
title: Secure Storage Plugin
description: Configure the secure storage capability for your Flutter app.
---

# Secure storage

`FlutterSecureStoragePlugin` implements the core `SecureStoragePlugin` contract using flutter_secure_storage. Features can share this capability without depending on its platform adapter.

```mermaid
flowchart LR
  Feature["Feature requests"] --> Contract["SecureStoragePlugin"]
  Contract --> Plugin["FlutterSecureStoragePlugin"]
  Plugin --> Platform["Platform secure storage"]
```

## Configure the capability

This configuration fragment goes in your app's `vc.runApp` call:

```dart
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_plugin_storage_secure/vyuh_plugin_storage_secure.dart';

final plugins = vc.PluginDescriptor(
  secureStorage: FlutterSecureStoragePlugin(),
);
```

After platform initialization, retrieve the configured contract:

```dart
final storage = vc.vyuh.getPlugin<vc.SecureStoragePlugin>()!;
await storage.write('auth_token', 'example-token');
final token = await storage.read('auth_token');
final exists = await storage.has('auth_token');
await storage.delete('auth_token');
```

Reads return strings. Writes convert non-null values with `toString()`; writing null deletes the key. Encode structured data explicitly before storing it.

Platform requirements and options depend on the installed [flutter_secure_storage version](https://pub.dev/packages/flutter_secure_storage). Apply its setup instructions for each target before using the plugin.

[API reference](/api/vyuh-plugin-storage-secure) · [Package source](https://github.com/vyuh-tech/vyuh/tree/main/packages/plugins/vyuh_plugin_storage_secure)
