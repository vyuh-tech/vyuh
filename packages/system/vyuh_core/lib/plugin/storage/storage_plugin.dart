import 'package:vyuh_core/vyuh_core.dart';

/// Base class for implementing persistent storage in Vyuh applications.
/// 
/// The storage plugin provides key-value storage functionality for:
/// - Application settings
/// - User preferences
/// - Cache data
/// - Temporary state
/// 
/// Data is stored in a non-secure manner and should not be used for
/// sensitive information. Use [SecureStoragePlugin] for sensitive data.
abstract class StoragePlugin extends Plugin {
  StoragePlugin({required super.name, required super.title});

  /// Reads a value from storage by its key.
  /// 
  /// Returns null if the key does not exist.
  Future<dynamic> read(String key);

  /// Writes a value to storage with the given key.
  /// 
  /// The value must be JSON-serializable.
  Future<dynamic> write(String key, dynamic value);

  /// Checks if a key exists in storage.
  Future<bool> has(String key);

  /// Deletes a value from storage by its key.
  /// 
  /// Returns true if the value was deleted, false if it didn't exist.
  Future<bool> delete(String key);
}

/// Base class for implementing secure storage in Vyuh applications.
/// 
/// The secure storage plugin provides encrypted key-value storage for
/// sensitive information such as:
/// - Authentication tokens
/// - API keys
/// - User credentials
/// - Personal data
/// 
/// Data is stored in a secure, encrypted manner using platform-specific
/// secure storage mechanisms:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences
/// - Web: LocalStorage with encryption
abstract class SecureStoragePlugin extends Plugin {
  SecureStoragePlugin({required super.name, required super.title});

  /// Reads a value from secure storage by its key.
  /// 
  /// Returns null if the key does not exist.
  Future<dynamic> read(String key);

  /// Writes a value to secure storage with the given key.
  /// 
  /// The value must be JSON-serializable. The data will be
  /// encrypted before storage.
  Future<dynamic> write(String key, dynamic value);

  /// Checks if a key exists in secure storage.
  Future<bool> has(String key);

  /// Deletes a value from secure storage by its key.
  /// 
  /// Returns true if the value was deleted, false if it didn't exist.
  Future<bool> delete(String key);
}
