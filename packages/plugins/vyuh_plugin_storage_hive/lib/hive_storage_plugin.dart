import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class HiveStoragePlugin extends StoragePlugin with InitOncePlugin {
  late final Box _box;
  final String boxName;

  /// Creates a new [HiveStoragePlugin] instance.
  ///
  /// The [boxName] parameter specifies the name of the Hive box to use for storage.
  /// If not provided, defaults to 'vyuh_storage'.
  HiveStoragePlugin({
    this.boxName = 'vyuh_storage',
  }) : super(
          name: 'vyuh.plugin.storage.hive',
          title: 'Storage Plugin for Hive',
        );

  @override
  Future<void> initOnce() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);
  }

  @override
  Future<void> disposeOnce() async {
    await _box.close();
  }

  @override

  /// Reads a value from the box with the given [key].
  ///
  /// Returns [null] if no value is associated with [key].
  Future<dynamic> read(String key) async {
    return _box.get(key);
  }

  @override
  Future<dynamic> write(String key, dynamic value) async {
    await _box.put(key, value);
    return value;
  }

  @override
  Future<bool> has(String key) async {
    return _box.containsKey(key);
  }

  @override
  Future<bool> delete(String key) async {
    await _box.delete(key);
    return true;
  }
}
