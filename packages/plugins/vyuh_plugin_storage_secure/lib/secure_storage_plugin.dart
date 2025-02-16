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
/// final storage = vyuh.platform.getPlugin<StoragePlugin>();
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
  late final FlutterSecureStorage _storage;

  final AndroidOptions? _androidOptions;
  final IOSOptions? _iOSOptions;
  final WebOptions? _webOptions;
  final MacOsOptions? _macOSOptions;
  final LinuxOptions? _linuxOptions;
  final WindowsOptions? _windowsOptions;

  /// Creates a new instance of [FlutterSecureStoragePlugin] with platform-specific options.
  ///
  /// Each platform can be configured with its own set of options:
  ///
  /// * [androidOptions] - Android configuration:
  ///   - `encryptedSharedPreferences`: Use EncryptedSharedPreferences (recommended)
  ///   - `sharedPreferencesName`: Custom name for preferences file
  ///   - `preferencesKeyPrefix`: Prefix for all stored keys
  ///
  /// * [iOSOptions] - iOS configuration:
  ///   - `accessibility`: When the keychain item should be accessible
  ///   - `synchronizable`: Enable iCloud keychain sync
  ///   - `groupId`: App Group ID for shared access
  ///
  /// * [macOSOptions] - macOS configuration:
  ///   - Similar to iOS options
  ///   - Supports keychain sharing and accessibility
  ///
  /// * [webOptions] - Web configuration:
  ///   - `dbName`: Name for IndexedDB database
  ///   - `publicKey`: Optional encryption key
  ///
  /// * [linuxOptions] - Linux configuration:
  ///   - Uses Secret Service API
  ///   - Requires running D-Bus session
  ///
  /// * [windowsOptions] - Windows configuration:
  ///   - Uses Windows DPAPI
  ///   - Data is tied to current user account
  ///
  /// Example:
  /// ```dart
  /// final plugin = FlutterSecureStoragePlugin(
  ///   androidOptions: const AndroidOptions(
  ///     encryptedSharedPreferences: true,
  ///   ),
  ///   iOSOptions: const IOSOptions(
  ///     accessibility: KeychainAccessibility.first_unlock,
  ///   ),
  /// );
  /// ```
  FlutterSecureStoragePlugin({
    AndroidOptions? androidOptions,
    IOSOptions? iOSOptions,
    WebOptions? webOptions,
    MacOsOptions? macOSOptions,
    LinuxOptions? linuxOptions,
    WindowsOptions? windowsOptions,
  })  : _androidOptions = androidOptions,
        _iOSOptions = iOSOptions,
        _webOptions = webOptions,
        _macOSOptions = macOSOptions,
        _linuxOptions = linuxOptions,
        _windowsOptions = windowsOptions,
        super(
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
    return _storage.read(key: key);
  }

  /// Writes a value to secure storage.
  ///
  /// The [value] is converted to a string before storage. If [value] is null,
  /// the [key] will be deleted from storage.
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
  Future<void> write(String key, dynamic value) async {
    if (value == null) {
      await delete(key);
      return;
    }
    await _storage.write(key: key, value: value.toString());
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
    final containsKey = await _storage.containsKey(key: key);
    return containsKey;
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
    final exists = await has(key);
    if (!exists) return false;

    await _storage.delete(key: key);
    return true;
  }

  @override
  Future<void> disposeOnce() async {}
}
