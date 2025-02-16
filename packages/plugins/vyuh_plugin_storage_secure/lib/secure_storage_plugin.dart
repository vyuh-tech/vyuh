import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// A secure storage plugin implementation using flutter_secure_storage.
///
/// This plugin provides encrypted key-value storage for sensitive information using
/// platform-specific secure storage mechanisms:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences
/// - Web: LocalStorage with encryption
class FlutterSecureStoragePlugin extends SecureStoragePlugin
    with InitOncePlugin {
  late final FlutterSecureStorage _storage;

  final AndroidOptions? _androidOptions;
  final IOSOptions? _iOSOptions;
  final WebOptions? _webOptions;
  final MacOsOptions? _macOSOptions;
  final LinuxOptions? _linuxOptions;
  final WindowsOptions? _windowsOptions;

  /// Initialize the secure storage with custom options.
  ///
  /// [androidOptions] - Configure Android-specific encryption and storage options
  /// [iOSOptions] - Configure iOS-specific keychain accessibility and sharing
  /// [webOptions] - Configure web storage options
  /// [macOSOptions] - Configure macOS-specific keychain options
  /// [linuxOptions] - Configure Linux-specific storage options
  /// [windowsOptions] - Configure Windows-specific storage options
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

  @override
  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> write(String key, dynamic value) async {
    if (value == null) {
      await delete(key);
      return;
    }
    await _storage.write(key: key, value: value.toString());
  }

  @override
  Future<bool> has(String key) async {
    final containsKey = await _storage.containsKey(key: key);
    return containsKey;
  }

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
