import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_plugin_storage_hive/vyuh_plugin_storage_hive.dart';

const _pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory documentsDir;

  setUp(() {
    // Hive.initFlutter() stores boxes in the app documents directory, which
    // comes from path_provider. Point it at a fresh temporary directory.
    documentsDir = Directory.systemTemp.createTempSync('vyuh_hive_test_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pathProviderChannel, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return documentsDir.path;
      }
      return null;
    });
  });

  tearDown(() async {
    await Hive.close();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pathProviderChannel, null);
    if (documentsDir.existsSync()) {
      documentsDir.deleteSync(recursive: true);
    }
  });

  test('describes itself as a storage plugin with a default box', () {
    final plugin = HiveStoragePlugin();

    expect(plugin, isA<StoragePlugin>());
    expect(plugin.name, 'vyuh.plugin.storage.hive');
    expect(plugin.title, 'Storage Plugin for Hive');
    expect(plugin.boxName, 'vyuh_storage');
    expect(HiveStoragePlugin(boxName: 'custom').boxName, 'custom');
  });

  test('init opens the named box in the documents directory', () async {
    final plugin = HiveStoragePlugin(boxName: 'settings');

    await plugin.init();

    expect(plugin.initialized, isTrue);
    expect(Hive.isBoxOpen('settings'), isTrue);
    expect(File('${documentsDir.path}/settings.hive').existsSync(), isTrue);

    await plugin.dispose();
  });

  test('write returns the value and read returns it back', () async {
    final plugin = HiveStoragePlugin();
    await plugin.init();

    expect(await plugin.write('name', 'vyuh'), 'vyuh');
    expect(await plugin.write('count', 42), 42);
    expect(await plugin.write('enabled', true), true);
    expect(await plugin.write('tags', ['a', 'b']), ['a', 'b']);
    expect(await plugin.write('map', {'k': 'v'}), {'k': 'v'});

    expect(await plugin.read('name'), 'vyuh');
    expect(await plugin.read('count'), 42);
    expect(await plugin.read('enabled'), true);
    expect(await plugin.read('tags'), ['a', 'b']);
    expect(await plugin.read('map'), {'k': 'v'});

    await plugin.dispose();
  });

  test('write overwrites an existing value', () async {
    final plugin = HiveStoragePlugin();
    await plugin.init();

    await plugin.write('key', 'first');
    await plugin.write('key', 'second');

    expect(await plugin.read('key'), 'second');

    await plugin.dispose();
  });

  test('missing keys read as null and are not present', () async {
    final plugin = HiveStoragePlugin();
    await plugin.init();

    expect(await plugin.read('missing'), isNull);
    expect(await plugin.has('missing'), isFalse);

    await plugin.dispose();
  });

  test('has reports keys that were written, including null values', () async {
    final plugin = HiveStoragePlugin();
    await plugin.init();

    await plugin.write('present', 'value');
    await plugin.write('nullable', null);

    expect(await plugin.has('present'), isTrue);
    expect(await plugin.has('nullable'), isTrue);
    expect(await plugin.read('nullable'), isNull);

    await plugin.dispose();
  });

  test('delete removes a key and reports false for missing keys', () async {
    final plugin = HiveStoragePlugin();
    await plugin.init();
    await plugin.write('key', 'value');

    expect(await plugin.delete('key'), isTrue);
    expect(await plugin.has('key'), isFalse);
    expect(await plugin.read('key'), isNull);

    expect(await plugin.delete('never-written'), isFalse);

    await plugin.dispose();
  });

  test('using the plugin before init or after dispose is a clear error',
      () async {
    final plugin = HiveStoragePlugin(boxName: 'lifecycle');
    expect(() => plugin.read('key'), throwsStateError);
    expect(() => plugin.write('key', 'value'), throwsStateError);
    expect(() => plugin.has('key'), throwsStateError);
    expect(() => plugin.delete('key'), throwsStateError);

    await plugin.init();
    await plugin.write('key', 'value');
    await plugin.dispose();

    expect(() => plugin.read('key'), throwsStateError);
  });

  test('plugins sharing a box name close it only when the last one stops',
      () async {
    final first = HiveStoragePlugin(boxName: 'shared');
    final second = HiveStoragePlugin(boxName: 'shared');
    await first.init();
    await second.init();

    await first.dispose();
    expect(Hive.isBoxOpen('shared'), isTrue);
    expect(await second.write('key', 'value'), 'value');

    await second.dispose();
    expect(Hive.isBoxOpen('shared'), isFalse);

    // Disposing again is harmless.
    await second.dispose();
  });

  test('dispose closes the box', () async {
    final plugin = HiveStoragePlugin(boxName: 'closing');
    await plugin.init();

    await plugin.dispose();

    expect(plugin.initialized, isFalse);
    expect(Hive.isBoxOpen('closing'), isFalse);
  });

  test('dispose before init is a no-op', () async {
    final plugin = HiveStoragePlugin();

    await plugin.dispose();

    expect(plugin.initialized, isFalse);
  });

  test('concurrent init calls share one box', () async {
    final plugin = HiveStoragePlugin();

    await Future.wait([plugin.init(), plugin.init()]);
    await plugin.write('key', 'value');

    expect(plugin.initialized, isTrue);
    expect(await plugin.read('key'), 'value');

    await plugin.dispose();
  });

  test('values persist on disk across a dispose and re-init', () async {
    final plugin = HiveStoragePlugin(boxName: 'persistent');
    await plugin.init();
    await plugin.write('key', 'value');
    await plugin.dispose();

    await plugin.init();

    expect(plugin.initialized, isTrue);
    expect(Hive.isBoxOpen('persistent'), isTrue);
    expect(await plugin.read('key'), 'value');
    expect(await plugin.has('key'), isTrue);

    await plugin.dispose();
  });

  test('a new plugin instance sees values written by an earlier one', () async {
    final first = HiveStoragePlugin(boxName: 'shared');
    await first.init();
    await first.write('key', 'value');
    await first.dispose();

    final second = HiveStoragePlugin(boxName: 'shared');
    await second.init();

    expect(await second.read('key'), 'value');

    await second.dispose();
  });

  test('plugins with different boxes keep separate data', () async {
    final a = HiveStoragePlugin(boxName: 'box_a');
    final b = HiveStoragePlugin(boxName: 'box_b');
    await a.init();
    await b.init();

    await a.write('key', 'from a');
    await b.write('key', 'from b');

    expect(await a.read('key'), 'from a');
    expect(await b.read('key'), 'from b');

    await a.delete('key');
    expect(await a.has('key'), isFalse);
    expect(await b.has('key'), isTrue);

    await a.dispose();
    await b.dispose();
  });
}
