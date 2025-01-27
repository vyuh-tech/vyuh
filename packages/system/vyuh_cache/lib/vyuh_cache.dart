library;

import 'dart:async';
import 'dart:developer';

export 'memory_cache_storage.dart';

/// A cache storage interface that defines the methods for a cache storage.
///
abstract interface class CacheStorage<T> {
  /// Get a cache entry by its key.
  ///
  /// Returns null if the entry is not found or expired.
  Future<CacheEntry<T>?> get(String key);

  /// Set a cache entry by its key.
  ///
  Future<void> set(String key, CacheEntry<T> value);

  /// Delete a cache entry by its key.
  ///
  Future<void> delete(String key);

  /// Clear the cache.
  ///
  Future<void> clear();

  /// Get all keys in the cache.
  ///
  Future<List<String>> keys();
}

/// A configuration object for the cache.
///
class CacheConfig<V> {
  /// The cache storage to use.
  final CacheStorage<V> storage;

  /// The time to live for the cache.
  final Duration ttl;

  /// The cache config.
  ///
  CacheConfig({required this.storage, required this.ttl});
}

/// A function that builds a value for the cache.
///
typedef CacheValueBuilder<T> = Future<T> Function();

/// A cache implementation.
///
final class Cache<V> {
  /// The cache configuration.
  ///
  final CacheConfig<V> config;

  /// The cache implementation.
  ///
  Cache(this.config);

  /// Build a value for the cache.
  ///
  /// If the value is already in the cache and not expired, it will be returned.
  /// If the value is expired, it will be deleted from the cache.
  /// If the value is not in the cache, it will be generated and stored in the cache.
  ///
  /// If the value is not found in the cache and the generateValue function is provided,
  /// it will be used to generate the value.
  ///
  /// If the value is not found in the cache and the generateValue function is not provided,
  /// it will return null.
  ///
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
      rethrow;
    } finally {
      if (generatedValue != null) {
        set(key, generatedValue);
      }
    }

    return generatedValue;
  }

  /// Get a value from the cache.
  ///
  /// Returns null if the value is not found or expired.
  ///
  Future<V?> get(String key) async {
    final entry = await config.storage.get(key);
    return entry?.value;
  }

  /// Check if a value is in the cache.
  ///
  /// Returns false if the value is not found or expired.
  ///
  Future<bool> has(String key) async {
    final entry = await config.storage.get(key);
    if (entry == null) return false;

    if (entry.isExpired) {
      await remove(key);
      return false;
    }

    return true;
  }

  /// Set a value in the cache.
  ///
  Future<void> set(String key, V value) async {
    await config.storage.set(key, CacheEntry(value, config.ttl));
  }

  /// Remove a value from the cache.
  ///
  Future<void> remove(String key) {
    return config.storage.delete(key);
  }

  /// Clear the cache.
  ///
  Future<void> clear() {
    return config.storage.clear();
  }
}

/// A cache entry. It holds the value and the time to live for the cache entry.
/// It also holds the creation time of the cache entry.
/// The cache entry is considered expired if the current time is greater than
/// the creation time plus the time to live.
///
final class CacheEntry<V> {
  /// The value of the cache entry.
  final V value;

  /// The time to live for the cache entry.
  final Duration ttl;

  /// The creation time of the cache entry.
  final DateTime _creationTime;

  /// The cache entry.
  ///
  CacheEntry(this.value, this.ttl) : _creationTime = DateTime.now();

  /// Check if the cache entry is expired.
  ///
  /// Returns true if the cache entry is expired.
  ///
  bool get isExpired {
    return DateTime.now().difference(_creationTime) > ttl;
  }
}
