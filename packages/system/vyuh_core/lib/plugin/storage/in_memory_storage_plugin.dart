import 'dart:async';

import 'package:vyuh_core/vyuh_core.dart';

/// A simple in-memory storage plugin that stores data in a Map.
///
/// This plugin is primarily intended for testing and development purposes.
/// Data is stored in memory and will be lost when the application is restarted.
/// Do not use this plugin for storing sensitive information in production.
final class InMemoryStoragePlugin extends StoragePlugin with InitOncePlugin {
  final Map<String, dynamic> _storage = {};

  InMemoryStoragePlugin()
      : super(
          name: 'vyuh.plugin.storage.memory',
          title: 'In-Memory Storage',
        );

  @override
  Future<dynamic> read(String key) async {
    return _storage[key];
  }

  @override
  Future<dynamic> write(String key, dynamic value) async {
    _storage[key] = value;
    return value;
  }

  @override
  Future<bool> has(String key) async {
    return _storage.containsKey(key);
  }

  @override
  Future<bool> delete(String key) async {
    return _storage.remove(key) != null;
  }

  /// Clears all data from the storage.
  ///
  /// This is useful for testing purposes to reset the storage state.
  Future<void> clear() async {
    _storage.clear();
  }

  @override
  Future<void> initOnce() async {
    // Initialize the storage map
    _storage.clear();
    return Future.value();
  }

  @override
  Future<void> disposeOnce() async {
    // Clear all data when disposing
    await clear();
    return Future.value();
  }
}
