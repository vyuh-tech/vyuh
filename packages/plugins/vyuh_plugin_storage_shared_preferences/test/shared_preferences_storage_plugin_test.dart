import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_plugin_storage_shared_preferences/vyuh_plugin_storage_shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('describes itself as a storage plugin', () {
    final plugin = SharedPreferencesStoragePlugin();

    expect(plugin, isA<StoragePlugin>());
    expect(plugin.name, 'vyuh.plugin.storage.shared_preferences');
    expect(plugin.title, 'Storage Plugin for SharedPreferences');
  });

  test('write returns the value and read returns it back', () async {
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();

    expect(await plugin.write('name', 'vyuh'), 'vyuh');
    expect(await plugin.read('name'), 'vyuh');

    await plugin.dispose();
  });

  test('writing null deletes the key', () async {
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();

    await plugin.write('gone', 'value');
    expect(await plugin.write('gone', null), isNull);
    expect(await plugin.has('gone'), isFalse);
    await plugin.dispose();
  });

  test('non-string values are stored as their string form', () async {
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();

    // write returns what it stored: the value's toString().
    expect(await plugin.write('count', 42), '42');
    expect(await plugin.write('enabled', true), 'true');
    expect(await plugin.write('ratio', 1.5), '1.5');

    expect(await plugin.read('count'), '42');
    expect(await plugin.read('enabled'), 'true');
    expect(await plugin.read('ratio'), '1.5');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('count'), '42');

    await plugin.dispose();
  });

  test('write overwrites an existing value', () async {
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();

    await plugin.write('key', 'first');
    await plugin.write('key', 'second');

    expect(await plugin.read('key'), 'second');

    await plugin.dispose();
  });

  test('missing keys read as null and are not present', () async {
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();

    expect(await plugin.read('missing'), isNull);
    expect(await plugin.has('missing'), isFalse);

    await plugin.dispose();
  });

  test('has reports keys that were written', () async {
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();

    await plugin.write('present', 'value');

    expect(await plugin.has('present'), isTrue);

    await plugin.dispose();
  });

  test('delete removes a key and reports success', () async {
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();
    await plugin.write('key', 'value');

    expect(await plugin.delete('key'), isTrue);
    expect(await plugin.has('key'), isFalse);
    expect(await plugin.read('key'), isNull);

    await plugin.dispose();
  });

  test('reads values already present in shared preferences', () async {
    SharedPreferences.setMockInitialValues({'existing': 'stored earlier'});
    final plugin = SharedPreferencesStoragePlugin();

    await plugin.init();

    expect(await plugin.has('existing'), isTrue);
    expect(await plugin.read('existing'), 'stored earlier');

    await plugin.dispose();
  });

  test('using the plugin before init is a clear error', () async {
    SharedPreferences.setMockInitialValues({'existing': 'value'});
    final plugin = SharedPreferencesStoragePlugin();

    expect(plugin.initialized, isFalse);
    expect(() => plugin.read('existing'), throwsStateError);
    expect(() => plugin.write('key', 'value'), throwsStateError);
    expect(() => plugin.has('existing'), throwsStateError);
    expect(() => plugin.delete('existing'), throwsStateError);
  });

  test('reads values of any type stored by other code', () async {
    SharedPreferences.setMockInitialValues({'count': 3, 'flag': true});
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();

    expect(await plugin.read('count'), 3);
    expect(await plugin.read('flag'), isTrue);

    await plugin.dispose();
  });

  test('delete reports false for a missing key', () async {
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();

    expect(await plugin.delete('never-written'), isFalse);

    await plugin.dispose();
  });

  test('after dispose, the plugin releases its preferences', () async {
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();
    await plugin.write('key', 'value');

    await plugin.dispose();

    expect(plugin.initialized, isFalse);
    expect(() => plugin.read('key'), throwsStateError);

    // The value itself is still persisted in shared preferences.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('key'), 'value');
  });

  test('values survive a dispose and re-init', () async {
    final plugin = SharedPreferencesStoragePlugin();
    await plugin.init();
    await plugin.write('key', 'value');
    await plugin.dispose();

    await plugin.init();

    expect(plugin.initialized, isTrue);
    expect(await plugin.read('key'), 'value');
    expect(await plugin.has('key'), isTrue);
    expect(await plugin.delete('key'), isTrue);
    expect(await plugin.has('key'), isFalse);

    await plugin.dispose();
  });

  test('concurrent init calls share one initialization', () async {
    final plugin = SharedPreferencesStoragePlugin();

    await Future.wait([plugin.init(), plugin.init()]);

    expect(plugin.initialized, isTrue);
    await plugin.write('key', 'value');
    expect(await plugin.read('key'), 'value');

    await plugin.dispose();
  });
}
