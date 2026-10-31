import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class HiveStoragePlugin extends StoragePlugin with InitOncePlugin {
  Box? _box;
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
    _openCounts[boxName] = (_openCounts[boxName] ?? 0) + 1;
  }

  /// Hive returns the same box to every plugin that opens a name, so the
  /// box closes only when the last of them is disposed.
  static final Map<String, int> _openCounts = {};

  @override
  Future<void> disposeOnce() async {
    final box = _box;
    _box = null;
    if (box == null) return;
    final remaining = (_openCounts[boxName] ?? 1) - 1;
    if (remaining > 0) {
      _openCounts[boxName] = remaining;
      return;
    }
    _openCounts.remove(boxName);
    await box.close();
  }

  /// The open box, or a clear error when used before [init] or after
  /// [dispose].
  Box get _store =>
      _box ??
      (throw StateError(
        '$title is not initialized. Register it in PluginDescriptor, or call '
        'init() before using it.',
      ));

  @override

  /// Reads a value from the box with the given [key].
  ///
  /// Returns [null] if no value is associated with [key].
  Future<dynamic> read(String key) async {
    return _store.get(key);
  }

  @override
  Future<dynamic> write(String key, dynamic value) async {
    await _store.put(key, value);
    return value;
  }

  @override
  Future<bool> has(String key) async {
    return _store.containsKey(key);
  }

  /// Returns false when [key] did not exist, as [StoragePlugin.delete] says.
  @override
  Future<bool> delete(String key) async {
    final box = _store;
    if (!box.containsKey(key)) return false;
    await box.delete(key);
    return true;
  }
}
