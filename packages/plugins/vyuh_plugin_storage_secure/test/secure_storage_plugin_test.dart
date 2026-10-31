import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_plugin_storage_secure/vyuh_plugin_storage_secure.dart';

/// An in-memory platform that also records the options of every call.
class _RecordingPlatform extends TestFlutterSecureStoragePlatform {
  _RecordingPlatform(super.data);

  final List<Map<String, String>> options = [];
  int deletes = 0;

  @override
  Future<String?> read({
    required String key,
    required Map<String, String> options,
  }) {
    this.options.add(options);
    return super.read(key: key, options: options);
  }

  @override
  Future<void> write({
    required String key,
    required String value,
    required Map<String, String> options,
  }) {
    this.options.add(options);
    return super.write(key: key, value: value, options: options);
  }

  @override
  Future<bool> containsKey({
    required String key,
    required Map<String, String> options,
  }) {
    this.options.add(options);
    return super.containsKey(key: key, options: options);
  }

  @override
  Future<void> delete({
    required String key,
    required Map<String, String> options,
  }) {
    deletes++;
    this.options.add(options);
    return super.delete(key: key, options: options);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Map<String, String> data;
  late _RecordingPlatform platform;

  setUp(() {
    data = {};
    platform = _RecordingPlatform(data);
    FlutterSecureStoragePlatform.instance = platform;
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  test('using the plugin before init or after dispose is a clear error',
      () async {
    final plugin = FlutterSecureStoragePlugin();
    expect(() => plugin.read('key'), throwsStateError);
    expect(() => plugin.write('key', 'v'), throwsStateError);
    expect(() => plugin.has('key'), throwsStateError);
    expect(() => plugin.delete('key'), throwsStateError);

    await plugin.init();
    expect(await plugin.write('key', 42), '42');
    await plugin.dispose();
    expect(() => plugin.read('key'), throwsStateError);
  });

  test('describes itself as a secure storage plugin', () {
    final plugin = FlutterSecureStoragePlugin();

    expect(plugin, isA<SecureStoragePlugin>());
    expect(plugin.name, 'vyuh.plugin.storage.secure');
    expect(plugin.title, 'Secure Storage Plugin');
  });

  group('storage', () {
    late FlutterSecureStoragePlugin plugin;

    setUp(() async {
      plugin = FlutterSecureStoragePlugin();
      await plugin.init();
    });

    tearDown(() => plugin.dispose());

    test('write then read round-trips a string', () async {
      await plugin.write('auth.token', 'secret');

      expect(await plugin.read('auth.token'), 'secret');
      expect(data, {'auth.token': 'secret'});
    });

    test('non-string values are stored as their string form', () async {
      await plugin.write('count', 42);
      await plugin.write('enabled', true);
      await plugin.write('ratio', 2.1);

      expect(await plugin.read('count'), '42');
      expect(await plugin.read('enabled'), 'true');
      expect(await plugin.read('ratio'), '2.1');
    });

    test('write overwrites an existing value', () async {
      await plugin.write('key', 'first');
      await plugin.write('key', 'second');

      expect(await plugin.read('key'), 'second');
    });

    test('missing keys read as null and are not present', () async {
      expect(await plugin.read('missing'), isNull);
      expect(await plugin.has('missing'), isFalse);
    });

    test('has reports keys that were written', () async {
      await plugin.write('present', 'value');

      expect(await plugin.has('present'), isTrue);
    });

    test('reads values already in secure storage', () async {
      data['existing'] = 'stored earlier';

      expect(await plugin.has('existing'), isTrue);
      expect(await plugin.read('existing'), 'stored earlier');
    });

    test('delete removes an existing key and returns true', () async {
      await plugin.write('key', 'value');

      expect(await plugin.delete('key'), isTrue);
      expect(await plugin.has('key'), isFalse);
      expect(await plugin.read('key'), isNull);
      expect(platform.deletes, 1);
    });

    test('delete returns false for a missing key without deleting', () async {
      expect(await plugin.delete('missing'), isFalse);
      expect(platform.deletes, 0);
    });

    test('writing null deletes the key', () async {
      await plugin.write('key', 'value');

      await plugin.write('key', null);

      expect(await plugin.has('key'), isFalse);
      expect(data, isEmpty);
      expect(platform.deletes, 1);
    });

    test('writing null for a missing key is a no-op', () async {
      await plugin.write('missing', null);

      expect(data, isEmpty);
      expect(platform.deletes, 0);
    });
  });

  group('lifecycle', () {
    test('values survive a dispose and re-init', () async {
      final plugin = FlutterSecureStoragePlugin();
      await plugin.init();
      await plugin.write('key', 'value');
      await plugin.dispose();
      expect(plugin.initialized, isFalse);

      await plugin.init();

      expect(plugin.initialized, isTrue);
      expect(await plugin.read('key'), 'value');
      await plugin.dispose();
    });

    test('a new plugin instance sees values written by an earlier one',
        () async {
      final first = FlutterSecureStoragePlugin();
      await first.init();
      await first.write('key', 'value');
      await first.dispose();

      final second = FlutterSecureStoragePlugin();
      await second.init();

      expect(await second.read('key'), 'value');
      await second.dispose();
    });

    test('works with the package mock values helper', () async {
      FlutterSecureStorage.setMockInitialValues({'seeded': 'value'});
      final plugin = FlutterSecureStoragePlugin();
      await plugin.init();

      expect(await plugin.read('seeded'), 'value');
      await plugin.write('other', 'x');
      expect(await plugin.has('other'), isTrue);
      expect(await plugin.delete('seeded'), isTrue);
      expect(await plugin.has('seeded'), isFalse);

      await plugin.dispose();
    });
  });

  group('platform options', () {
    Future<Map<String, String>> optionsFor(
      TargetPlatform target,
      FlutterSecureStoragePlugin plugin,
    ) async {
      debugDefaultTargetPlatformOverride = target;
      await plugin.init();
      platform.options.clear();
      await plugin.read('key');
      await plugin.dispose();
      return platform.options.single;
    }

    test('defaults are used when no options are given', () async {
      final defaults = {
        TargetPlatform.android: const AndroidOptions().params,
        TargetPlatform.iOS: const IOSOptions().params,
        TargetPlatform.macOS: const MacOsOptions().params,
        TargetPlatform.linux: const LinuxOptions().params,
        TargetPlatform.windows: const WindowsOptions().params,
      };

      for (final MapEntry(key: target, value: expected) in defaults.entries) {
        expect(
          await optionsFor(target, FlutterSecureStoragePlugin()),
          expected,
          reason: '$target',
        );
      }
    });

    test('custom options reach the platform for each target', () async {
      const android = AndroidOptions(preferencesKeyPrefix: 'vyuh_android');
      const ios = IOSOptions(accountName: 'vyuh_ios');
      const macOS = MacOsOptions(accountName: 'vyuh_macos');
      const windows = WindowsOptions(useBackwardCompatibility: true);
      const linux = LinuxOptions();
      const web = WebOptions(dbName: 'vyuh_web');

      FlutterSecureStoragePlugin plugin() => FlutterSecureStoragePlugin(
            androidOptions: android,
            iOSOptions: ios,
            macOSOptions: macOS,
            windowsOptions: windows,
            linuxOptions: linux,
            webOptions: web,
          );

      final androidParams = await optionsFor(TargetPlatform.android, plugin());
      expect(androidParams['preferencesKeyPrefix'], 'vyuh_android');

      final iosParams = await optionsFor(TargetPlatform.iOS, plugin());
      expect(iosParams['accountName'], 'vyuh_ios');

      final macOSParams = await optionsFor(TargetPlatform.macOS, plugin());
      expect(macOSParams['accountName'], 'vyuh_macos');

      final windowsParams = await optionsFor(TargetPlatform.windows, plugin());
      expect(windowsParams['useBackwardCompatibility'], 'true');

      expect(
        await optionsFor(TargetPlatform.linux, plugin()),
        linux.params,
      );
    });
  });
}
