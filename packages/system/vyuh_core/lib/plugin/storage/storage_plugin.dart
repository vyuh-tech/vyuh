import 'package:vyuh_core/vyuh_core.dart';

/// A key-value storage capability shared by features.
///
/// The storage plugin provides key-value storage functionality for:
/// - Application settings
/// - User preferences
/// - Cache data
/// - Temporary state
///
/// The app selects an implementation. Persistence and supported value types
/// depend on that implementation; the default store retains values in memory.
/// Select an appropriate [SecureStoragePlugin] implementation for sensitive data.
abstract class StoragePlugin extends Plugin {
  StoragePlugin({required super.name, required super.title});

  /// Reads a value from storage by its key.
  ///
  /// Returns null if the key does not exist.
  Future<dynamic> read(String key);

  /// Writes a value to storage with the given key.
  ///
  /// Supported values and conversion rules depend on the selected implementation.
  Future<dynamic> write(String key, dynamic value);

  /// Checks if a key exists in storage.
  Future<bool> has(String key);

  /// Deletes a value from storage by its key.
  ///
  /// Returns true if the value was deleted, false if it didn't exist.
  Future<bool> delete(String key);
}

/// A storage contract for app-selected secure storage implementations.
///
/// Select a platform adapter appropriate for sensitive values such as tokens.
/// Encryption, persistence, and supported value types belong to the adapter.
/// The default in-memory implementation does not encrypt or persist data.
abstract class SecureStoragePlugin extends Plugin {
  SecureStoragePlugin({required super.name, required super.title});

  /// Reads a value from secure storage by its key.
  ///
  /// Returns null if the key does not exist.
  Future<dynamic> read(String key);

  /// Writes a value to secure storage with the given key.
  ///
  /// Supported values, conversion, and protection depend on the selected adapter.
  Future<dynamic> write(String key, dynamic value);

  /// Checks if a key exists in secure storage.
  Future<bool> has(String key);

  /// Deletes a value from secure storage by its key.
  ///
  /// Returns true if the value was deleted, false if it didn't exist.
  Future<bool> delete(String key);
}
