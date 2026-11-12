---
title: vyuh_plugin_storage_secure API
description: Public declarations and contracts for vyuh_plugin_storage_secure.
outline: 2
---

# vyuh_plugin_storage_secure

FlutterSecureStoragePlugin implements string persistence through flutter_secure_storage. Use the secureStorage slot in PluginDescriptor and consult the package setup for each target platform.

```mermaid
flowchart LR
  Feature["String values"] --> Plugin["FlutterSecureStoragePlugin"]
  Plugin --> Platform["Platform secure storage"]
```

[Package source](https://github.com/vyuh-tech/vyuh/tree/main/packages/plugins/vyuh_plugin_storage_secure) · [Released API](https://pub.dev/documentation/vyuh_plugin_storage_secure/latest/)

## Choose a declaration

[FlutterSecureStoragePlugin](#fluttersecurestorageplugin)

## FlutterSecureStoragePlugin {#fluttersecurestorageplugin}

[Source](https://github.com/vyuh-tech/vyuh/blob/main/packages/plugins/vyuh_plugin_storage_secure/lib/secure_storage_plugin.dart#L4)

A secure storage plugin implementation using flutter_secure_storage.

```dart
class FlutterSecureStoragePlugin extends SecureStoragePlugin with InitOncePlugin
```

Directly declared public members:

```dart
FlutterSecureStoragePlugin({this._androidOptions, this._iOSOptions, this._webOptions, this._macOSOptions, this._linuxOptions, this._windowsOptions});
```

Creates a new instance of `FlutterSecureStoragePlugin` with optional platform-specific options from `flutter_secure_storage`, which this package re-exports. Platforms without options use the package defaults.

```dart
Future<void> initOnce();
```



```dart
Future<String?> read(String key);
```

Reads a value from secure storage.

```dart
Future<String?> write(String key, dynamic value);
```

Writes a value to secure storage.

```dart
Future<bool> has(String key);
```

Checks if a key exists in secure storage.

```dart
Future<bool> delete(String key);
```

Deletes a value from secure storage.

```dart
Future<void> disposeOnce();
```

Releases the plugin. Stored values stay on the device; using the plugin again needs another `init`.
