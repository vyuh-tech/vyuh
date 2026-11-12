import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A secure storage plugin implementation using flutter_secure_storage.
///
/// This plugin provides encrypted key-value storage for sensitive information using
/// platform-specific secure storage mechanisms:
/// - iOS: Keychain Services
/// - Android: EncryptedSharedPreferences
/// - macOS: Keychain Services
/// - Linux: Secret Service API
/// - Windows: Data Protection API (DPAPI)
/// - Web: LocalStorage with encryption
///
/// Example usage:
/// ```dart
/// final storage = vyuh.getPlugin<SecureStoragePlugin>()!;
///
/// // Store a value
/// await storage.write('auth.token', 'my-secure-token');
///
/// // Read a value
/// final token = await storage.read('auth.token');
///
/// // Check if exists
/// if (await storage.has('auth.token')) {
///   // Key exists
/// }
///
/// // Delete a value
/// final wasDeleted = await storage.delete('auth.token');
/// ```
///
/// See also:
/// * [SecureStoragePlugin] - The base plugin interface
/// * [InitOncePlugin] - Mixin for plugin initialization
class FlutterSecureStoragePlugin extends SecureStoragePlugin
    with InitOncePlugin {
  FlutterSecureStorage? _storage;

  FlutterSecureStorage get _store =>
      _storage ??
      (throw StateError(
        'FlutterSecureStoragePlugin is not initialized. '
        'Call init() before using it, and do not use it after dispose().',
      ));

  final AndroidOptions? _androidOptions;
  final IOSOptions? _iOSOptions;
  final WebOptions? _webOptions;
  final MacOsOptions? _macOSOptions;
  final LinuxOptions? _linuxOptions;
  final WindowsOptions? _windowsOptions;

  /// Creates a new instance of [FlutterSecureStoragePlugin] with optional
  /// platform-specific options from `flutter_secure_storage`, which this
  /// package re-exports. Platforms without options use the package defaults.
  ///
  /// Example:
  /// ```dart
  /// final plugin = FlutterSecureStoragePlugin(
  ///   androidOptions: const AndroidOptions(storageNamespace: 'my_app'),
  ///   iOSOptions: const IOSOptions(
  ///     accessibility: KeychainAccessibility.first_unlock,
  ///   ),
  /// );
  /// ```
  FlutterSecureStoragePlugin({
    this._androidOptions,
    this._iOSOptions,
    this._webOptions,
    this._macOSOptions,
    this._linuxOptions,
    this._windowsOptions,
  }) : super(
         name: 'vyuh.plugin.storage.secure',
         title: 'Secure Storage Plugin',
       );

  @override
  Future<void> initOnce() async {
    _storage = FlutterSecureStorage(
      aOptions: _androidOptions ?? const AndroidOptions(),
      iOptions: _iOSOptions ?? const IOSOptions(),
      webOptions: _webOptions ?? const WebOptions(),
      mOptions: _macOSOptions ?? const MacOsOptions(),
      lOptions: _linuxOptions ?? const LinuxOptions(),
      wOptions: _windowsOptions ?? const WindowsOptions(),
    );
  }

  /// Reads a value from secure storage.
  ///
  /// Returns the value associated with [key] if it exists, null otherwise.
  /// The value is returned as a String, regardless of the original type.
  ///
  /// Example:
  /// ```dart
  /// final value = await storage.read('settings.theme');
  /// if (value != null) {
  ///   print('Theme setting: $value');
  /// }
  /// ```
  ///
  /// See also:
  /// * [write] - Store a value
  /// * [has] - Check if a key exists
  @override
  Future<String?> read(String key) async {
    return _store.read(key: key);
  }

  /// Writes a value to secure storage.
  ///
  /// The [value] is converted to a string before storage, and that string is
  /// returned. If [value] is null, the [key] is deleted and null is returned.
  ///
  /// Example:
  /// ```dart
  /// // Store a string
  /// await storage.write('user.name', 'John Doe');
  ///
  /// // Store a number
  /// await storage.write('app.version', 2.1);
  ///
  /// // Store JSON
  /// await storage.write('user.preferences', jsonEncode(prefs));
  ///
  /// // Delete by writing null
  /// await storage.write('temp.key', null);
  /// ```
  ///
  /// See also:
  /// * [read] - Read a stored value
  /// * [delete] - Delete a stored value
  @override
  Future<String?> write(String key, dynamic value) async {
    if (value == null) {
      await delete(key);
      return null;
    }
    final text = value.toString();
    await _store.write(key: key, value: text);
    return text;
  }

  /// Checks if a key exists in secure storage.
  ///
  /// Returns true if the [key] exists in storage, false otherwise.
  /// This is useful for checking if a value exists before attempting to read it.
  ///
  /// Example:
  /// ```dart
  /// if (await storage.has('auth.token')) {
  ///   final token = await storage.read('auth.token');
  ///   // Use token...
  /// } else {
  ///   // Handle missing token...
  /// }
  /// ```
  ///
  /// See also:
  /// * [read] - Read a stored value
  /// * [delete] - Delete a stored value
  @override
  Future<bool> has(String key) async {
    return _store.containsKey(key: key);
  }

  /// Deletes a value from secure storage.
  ///
  /// Returns true if the [key] was deleted, false if it didn't exist.
  /// This operation is idempotent - calling it multiple times on the same key
  /// will not cause an error.
  ///
  /// Example:
  /// ```dart
  /// final wasDeleted = await storage.delete('session.token');
  /// if (wasDeleted) {
  ///   print('Token was deleted');
  /// } else {
  ///   print('Token did not exist');
  /// }
  /// ```
  ///
  /// See also:
  /// * [write] - Store a value
  /// * [has] - Check if a key exists
  @override
  Future<bool> delete(String key) async {
    final store = _store;
    if (!await store.containsKey(key: key)) return false;

    await store.delete(key: key);
    return true;
  }

  /// Releases the plugin. Stored values stay on the device; using the plugin
  /// again needs another [init].
  @override
  Future<void> disposeOnce() async {
    _storage = null;
  }
}
