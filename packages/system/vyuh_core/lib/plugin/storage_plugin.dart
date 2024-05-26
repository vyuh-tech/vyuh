import 'package:vyuh_core/vyuh_core.dart';

abstract class StoragePlugin extends Plugin {
  StoragePlugin({required super.name, required super.title})
      : super(pluginType: PluginType.storage);

  Future<dynamic> read(String key);
  Future<dynamic> write(String key, dynamic value);
  Future<bool> has(String key);
  Future<bool> delete(String key);
}

abstract class SecureStoragePlugin extends Plugin {
  SecureStoragePlugin({required super.name, required super.title})
      : super(pluginType: PluginType.secureStorage);

  Future<dynamic> read(String key);
  Future<dynamic> write(String key, dynamic value);
  Future<bool> has(String key);
  Future<bool> delete(String key);
}
