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

  @override
  Future<dynamic> read(String key) async {
    return _prefs?.getString(key);
  }

  @override
  Future<dynamic> write(String key, dynamic value) async {
    await _prefs?.setString(key, value.toString());
    return value;
  }

  @override
  Future<bool> has(String key) async {
    return _prefs?.containsKey(key) ?? false;
  }

  @override
  Future<bool> delete(String key) async {
    return await _prefs?.remove(key) ?? false;
  }
}
