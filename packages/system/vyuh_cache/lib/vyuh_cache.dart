library;

import 'dart:async';
import 'dart:developer';

export 'memory_cache_storage.dart';

abstract interface class CacheStorage<T> {
  Future<CacheEntry<T>?> get(String key);
  Future<void> set(String key, CacheEntry<T> value);
  Future<void> delete(String key);
  Future<void> clear();
  Future<List<String>> keys();
}

class CacheConfig<V> {
  final CacheStorage<V> storage;
  final Duration ttl;

  CacheConfig({required this.storage, required this.ttl});
}

typedef CacheValueBuilder<T> = Future<T> Function();

final class Cache<V> {
  final CacheConfig<V> config;

  Cache(this.config);

  Future<V?> build(String key, {CacheValueBuilder<V>? generateValue}) async {
    try {
      final entry = await config.storage.get(key);

      if (entry != null) {
        if (!entry.isExpired) {
          log('<< Responding from cache >>');
          return entry.value;
        } else {
          config.storage.delete(key);
        }
      }
    } catch (e) {
      log('Failed to fetch cache entry for key: $key');
      return null;
    }

    if (generateValue == null) {
      return null;
    }

    V? generatedValue;
    try {
      generatedValue = await generateValue();
    } catch (e) {
      log('Failed to generate value for key: $key');
      generateValue = null;
    } finally {
      if (generatedValue != null) {
        set(key, generatedValue);
      }
    }

    return generatedValue;
  }

  Future<V?> get(String key) async {
    final entry = await config.storage.get(key);
    return entry?.value;
  }

  Future<void> set(String key, V value) async {
    await config.storage.set(key, CacheEntry(value, config.ttl));
  }

  void remove(String key) {
    config.storage.delete(key);
  }

  void clear() {
    config.storage.clear();
  }
}

final class CacheEntry<V> {
  final V value;
  final Duration ttl;

  final DateTime _creationTime;

  CacheEntry(this.value, this.ttl) : _creationTime = DateTime.now();

  bool get isExpired {
    return DateTime.now().difference(_creationTime) > ttl;
  }
}
