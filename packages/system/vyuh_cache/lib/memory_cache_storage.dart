import 'dart:async';

import 'package:vyuh_cache/vyuh_cache.dart';

/// A simple in-memory cache storage implementation
final class MemoryCacheStorage<T> implements CacheStorage<T> {
  final Map<String, CacheEntry<T>> _cache = {};

  /// Optional maximum entry count, evicting the least recently used entry.
  final int? maxEntries;

  MemoryCacheStorage({this.maxEntries}) {
    if (maxEntries != null && maxEntries! <= 0) {
      throw ArgumentError.value(maxEntries, 'maxEntries', 'Must be positive');
    }
  }

  @override
  Future<void> clear() async {
    _cache.clear();
  }

  @override
  Future<void> delete(String key) async {
    _cache.remove(key);
  }

  @override
  Future<CacheEntry<T>?> get(String key) async {
    final entry = _cache.remove(key);
    if (entry != null) _cache[key] = entry;
    return entry;
  }

  @override
  Future<List<String>> keys() async {
    return _cache.keys.toList(growable: false);
  }

  @override
  Future<void> set(String key, CacheEntry<T> value) async {
    _cache.remove(key);
    _cache[key] = value;
    if (maxEntries != null && _cache.length > maxEntries!) {
      _cache.remove(_cache.keys.first);
    }
  }
}
