library;

import 'dart:async';
import 'dart:developer';

export 'memory_cache_storage.dart';

/// A cache storage interface that defines the methods for a cache storage.
///
abstract interface class CacheStorage<T> {
  /// Get a cache entry by its key.
  ///
  /// Returns the stored entry, or null if it is not found.
  /// [Cache] checks expiration before returning its value.
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

/// A generic cache implementation that manages data of type [V].
/// Provides comprehensive cache management functionality including
/// configuration, storage operations (get, set, remove),and cache
/// maintenance (build, clear).
///
final class Cache<V> {
  final Map<String, Future<V?>> _pending = {};
  final Map<String, Object> _generationTokens = {};
  final Map<String, Future<void>> _storageTails = {};
  Future<void> _clearBarrier = Future.value();

  // Order each key independently; clear forms a barrier across all keys.
  Future<T> _withStorage<T>(String key, Future<T> Function() operation) {
    final predecessors = [
      _clearBarrier,
      if (_storageTails[key] != null) _storageTails[key]!
    ];
    final result = Future.wait(predecessors).then((_) => operation());
    final tail =
        result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    _storageTails[key] = tail;
    unawaited(tail.then((_) {
      if (identical(_storageTails[key], tail)) _storageTails.remove(key);
    }));
    return result;
  }

  Future<void> _clearStorage() {
    final result = Future.wait([_clearBarrier, ..._storageTails.values])
        .then((_) => config.storage.clear());
    _clearBarrier =
        result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return result;
  }

  /// The cache configuration.
  ///
  final CacheConfig<V> config;

  /// The cache implementation.
  ///
  Cache(this.config);

  /// Build a value for the cache.
  ///
  /// If the value is already in the cache and not expired, it will be returned.
  /// If the value is expired, it will be deleted from the cache. If the value
  /// is not in the cache, it will be generated and stored in the cache.
  ///
  /// If the value is not found in the cache and the generateValue function is
  /// provided, it will be used to generate the value.
  ///
  /// If the value is not found in the cache and the generateValue function is
  /// not provided, it will return null.
  ///
  Future<V?> build(String key, {CacheValueBuilder<V>? generateValue}) async {
    if (generateValue == null) return _read(key);
    final existing = _pending[key];
    if (existing != null) return existing;
    final token = Object();
    _generationTokens[key] = token;
    final pending = () async {
      final value = await _read(key);
      if (value != null) return value;
      return _generate(key, generateValue, token);
    }();
    _pending[key] = pending;
    try {
      return await pending;
    } finally {
      if (identical(_pending[key], pending)) {
        _pending.remove(key);
        _generationTokens.remove(key);
      }
    }
  }

  Future<V?> _read(String key) async {
    try {
      return await get(key);
    } catch (_) {
      log('Failed to fetch cache entry for key: $key');
      return null;
    }
  }

  Future<V?> _generate(
      String key, CacheValueBuilder<V> generateValue, Object token) async {
    final value = await generateValue();
    if (value != null) {
      try {
        await _withStorage(key, () async {
          if (identical(_generationTokens[key], token)) {
            await config.storage.set(key, CacheEntry(value, config.ttl));
          }
        });
      } catch (e) {
        log('Failed to store cache entry for key: $key');
      }
    }
    return value;
  }

  /// Get a value from the cache.
  ///
  /// Returns null if the value is not found or expired.
  ///
  Future<V?> get(String key) => _withStorage(key, () async {
        final entry = await config.storage.get(key);
        if (entry != null && entry.isExpired) {
          await config.storage.delete(key);
          return null;
        }
        return entry?.value;
      });

  /// Check if a value is in the cache.
  ///
  /// Returns false if the value is not found or expired.
  ///
  Future<bool> has(String key) => _withStorage(key, () async {
        final entry = await config.storage.get(key);
        if (entry == null) return false;
        if (!entry.isExpired) return true;
        await config.storage.delete(key);
        return false;
      });

  /// Set a value in the cache.
  ///
  Future<void> set(String key, V value) {
    _invalidate(key);
    return _withStorage(
        key, () => config.storage.set(key, CacheEntry(value, config.ttl)));
  }

  /// Remove a value from the cache.
  ///
  Future<void> remove(String key) {
    _invalidate(key);
    return _withStorage(key, () => config.storage.delete(key));
  }

  /// Clear the cache.
  ///
  Future<void> clear() {
    _pending.clear();
    _generationTokens.clear();
    return _clearStorage();
  }

  void _invalidate(String key) {
    _pending.remove(key);
    _generationTokens.remove(key);
  }
}

/// A cache entry that encapsulates a value with time-based expiration.
///
/// Each entry contains:
/// * A value of type [V]
/// * A time-to-live (TTL) duration
/// * An internal creation timestamp
///
/// An entry is considered expired when the elapsed time since creation exceeds
/// its TTL.
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
    return DateTime.now().difference(_creationTime) >= ttl;
  }
}
