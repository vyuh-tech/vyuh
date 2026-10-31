---
title: vyuh_plugin_storage_shared_preferences API
description: Public declarations and contracts for vyuh_plugin_storage_shared_preferences.
outline: 2
---

# vyuh_plugin_storage_shared_preferences

SharedPreferencesStoragePlugin stores values as strings: write uses value.toString() and read uses getString. Choose this for simple string preferences rather than expecting arbitrary objects to round-trip.

```mermaid
flowchart LR
  Value["Preference value"] --> String["Convert to string"]
  String --> Preferences["SharedPreferences"]
  Preferences --> Read["Read string value"]
```

[Package source](https://github.com/vyuh-tech/vyuh/tree/main/packages/plugins/vyuh_plugin_storage_shared_preferences) · [Released API](https://pub.dev/documentation/vyuh_plugin_storage_shared_preferences/latest/)

## Choose a declaration

[SharedPreferencesStoragePlugin](#sharedpreferencesstorageplugin)

## SharedPreferencesStoragePlugin {#sharedpreferencesstorageplugin}

[Source](https://github.com/vyuh-tech/vyuh/blob/main/packages/plugins/vyuh_plugin_storage_shared_preferences/lib/vyuh_plugin_storage_shared_preferences.dart#L4)

Public declaration in this package.

```dart
final class SharedPreferencesStoragePlugin extends StoragePlugin with InitOncePlugin
```

Directly declared public members:

```dart
SharedPreferencesStoragePlugin();
```



```dart
Future<void> initOnce();
```



```dart
Future<void> disposeOnce();
```



```dart
Future<dynamic> read(String key);
```



```dart
Future<dynamic> write(String key, dynamic value);
```



```dart
Future<bool> has(String key);
```



```dart
Future<bool> delete(String key);
```
