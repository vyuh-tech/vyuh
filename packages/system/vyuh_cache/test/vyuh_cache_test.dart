import 'dart:async';

import 'package:test/test.dart';
import 'package:vyuh_cache/vyuh_cache.dart';

void main() {
  invalidationTests();
  test('all reads reject expired values and remove their entries', () async {
    final storage = MemoryCacheStorage<String>();
    final cache = Cache(CacheConfig(storage: storage, ttl: Duration.zero));
    await cache.set('get', 'stale');
    await cache.set('has', 'stale');
    await cache.set('build', 'stale');
    expect(await cache.get('get'), isNull);
    expect(await cache.has('has'), isFalse);
    expect(await cache.build('build'), isNull);
    expect(await storage.keys(), isEmpty);
  });

  test('concurrent misses share one generator and cache the result', () async {
    final cache = Cache(CacheConfig(
        storage: MemoryCacheStorage<String>(),
        ttl: const Duration(minutes: 1)));
    final result = Completer<String>();
    var calls = 0;
    Future<String> generate() {
      calls++;
      return result.future;
    }

    final requests =
        List.generate(10, (_) => cache.build('key', generateValue: generate));
    await Future<void>.delayed(Duration.zero);
    expect(calls, 1);
    result.complete('fresh');
    expect(await Future.wait(requests), everyElement('fresh'));
    expect(await cache.get('key'), 'fresh');
  });

  test('a failed generator can be retried', () async {
    final cache = Cache(CacheConfig(
        storage: MemoryCacheStorage<String>(),
        ttl: const Duration(minutes: 1)));
    await expectLater(
        cache.build('key', generateValue: () async {
          throw StateError('network failed');
        }),
        throwsStateError);
    expect(
        await cache.build('key', generateValue: () async => 'retry'), 'retry');
  });

  test('storage failures do not prevent a fresh result', () async {
    final cache = Cache(CacheConfig(
        storage: _FailingStorage(), ttl: const Duration(minutes: 1)));
    expect(
        await cache.build('key', generateValue: () async => 'fresh'), 'fresh');
  });

  test('expiration cleanup completes before replacement is stored', () async {
    final storage = _DelayedDeleteStorage();
    await storage.set('key', CacheEntry('stale', Duration.zero));
    final cache =
        Cache(CacheConfig(storage: storage, ttl: const Duration(minutes: 1)));
    expect(
        await cache.build('key', generateValue: () async => 'fresh'), 'fresh');
    expect(await cache.get('key'), 'fresh');
  });
}

class _FailingStorage implements CacheStorage<String> {
  @override
  Future<CacheEntry<String>?> get(String key) async => throw StateError('read');
  @override
  Future<void> set(String key, CacheEntry<String> value) async =>
      throw StateError('write');
  @override
  Future<void> delete(String key) async {}
  @override
  Future<void> clear() async {}
  @override
  Future<List<String>> keys() async => [];
}

class _DelayedDeleteStorage implements CacheStorage<String> {
  final _storage = MemoryCacheStorage<String>();
  @override
  Future<CacheEntry<String>?> get(String key) => _storage.get(key);
  @override
  Future<void> set(String key, CacheEntry<String> value) =>
      _storage.set(key, value);
  @override
  Future<void> delete(String key) async {
    await Future<void>.delayed(Duration.zero);
    await _storage.delete(key);
  }

  @override
  Future<void> clear() => _storage.clear();
  @override
  Future<List<String>> keys() => _storage.keys();
}

void invalidationTests() {
  for (final clear in [false, true]) {
    test(
        '${clear ? "clear" : "remove"} prevents an old generator from repopulating',
        () async {
      final cache = Cache(CacheConfig(
          storage: MemoryCacheStorage<String>(),
          ttl: const Duration(minutes: 1)));
      final started = Completer<void>();
      final old = Completer<String>();
      final request = cache.build('key', generateValue: () {
        started.complete();
        return old.future;
      });
      await started.future;
      if (clear) {
        await cache.clear();
      } else {
        await cache.remove('key');
      }
      expect(await cache.build('key', generateValue: () async => 'new'), 'new');
      old.complete('old');
      expect(await request, 'old');
      expect(await cache.get('key'), 'new');
    });
  }
  test('explicit writes supersede pending generation', () async {
    final cache = Cache(CacheConfig(
        storage: MemoryCacheStorage<String>(),
        ttl: const Duration(minutes: 1)));
    final started = Completer<void>();
    final result = Completer<String>();
    final request = cache.build('key', generateValue: () {
      started.complete();
      return result.future;
    });
    await started.future;
    await cache.set('key', 'explicit');
    result.complete('old');
    await request;
    expect(await cache.get('key'), 'explicit');
  });
  test('bounded memory storage evicts least recently used entries', () async {
    final storage = MemoryCacheStorage<String>(maxEntries: 2);
    final cache =
        Cache(CacheConfig(storage: storage, ttl: const Duration(minutes: 1)));
    await cache.set('a', 'a');
    await cache.set('b', 'b');
    await cache.get('a');
    await cache.set('c', 'c');
    expect(await cache.get('b'), isNull);
    expect(await storage.keys(), ['a', 'c']);
    expect(
        () => MemoryCacheStorage<String>(maxEntries: 0), throwsArgumentError);
  });
}
