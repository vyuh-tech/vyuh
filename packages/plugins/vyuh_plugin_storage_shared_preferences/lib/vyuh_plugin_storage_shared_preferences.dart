import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class SharedPreferencesStoragePlugin extends StoragePlugin
    with InitOncePlugin {
  SharedPreferences? _prefs;

  SharedPreferencesStoragePlugin()
      : super(
          name: 'vyuh.plugin.storage.shared_preferences',
          title: 'Storage Plugin for SharedPreferences',
        );

  @override
  Future<void> initOnce() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> disposeOnce() async {
    _prefs = null;
  }

  /// The preferences, or a clear error when used before [init] or after
  /// [dispose] instead of silently dropping the operation.
  SharedPreferences get _store =>
      _prefs ??
      (throw StateError(
        '$title is not initialized. Register it in PluginDescriptor, or call '
        'init() before using it.',
      ));

  /// Returns the stored value of any type (values written by this plugin
  /// are strings), or null when [key] is missing.
  @override
  Future<dynamic> read(String key) async {
    return _store.get(key);
  }

  @override
  Future<dynamic> write(String key, dynamic value) async {
    await _store.setString(key, value.toString());
    return value;
  }

  @override
  Future<bool> has(String key) async {
    return _store.containsKey(key);
  }

  /// Returns false when [key] did not exist, as [StoragePlugin.delete] says.
  @override
  Future<bool> delete(String key) async {
    final store = _store;
    if (!store.containsKey(key)) return false;
    return store.remove(key);
  }
}
