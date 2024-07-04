import 'dart:async';

import 'package:vyuh_cache/vyuh_cache.dart';

/// A simple in-memory cache storage implementation
final class MemoryCacheStorage<T> implements CacheStorage<T> {
  final Map<String, CacheEntry<T>> _cache = {};

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
    return _cache[key];
  }

  @override
  Future<List<String>> keys() async {
    return _cache.keys.toList(growable: false);
  }

  @override
  Future<void> set(String key, CacheEntry<T> value) async {
    _cache[key] = value;
  }
}
