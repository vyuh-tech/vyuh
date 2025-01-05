# Vyuh Cache

A lightweight, flexible caching solution for Vyuh-framework applications. Provides time-based caching with pluggable storage backends. Perfect for reducing API calls, improving app performance, and managing temporary data.

## Features ✨

- **Time-based Caching**: Automatic expiration with TTL (Time To Live) ⏱️
- **Type Safety**: Generic implementation for type-safe caching 🛡️
- **Pluggable Storage**: Built-in memory storage with extensible storage interface 💾
- **Async API**: Full async support for all operations ⚡
- **Value Generation**: Built-in support for generating missing cache values 🔄
- **Expiration Handling**: Automatic cleanup of expired entries 🧹

## Installation 📦

Add this to your package's `pubspec.yaml`:

```yaml
dependencies:
  vyuh_cache: any
```

## Usage 💡

### Basic Usage

```dart
// Create a cache instance with memory storage
final cache = Cache(
  CacheConfig(
    storage: MemoryCacheStorage<String>(),
    ttl: Duration(minutes: 5),
  ),
);

// Store a value
await cache.set('greeting', 'Hello, World!');

// Check if key exists
if (await cache.has('greeting')) {
  // Retrieve the value
  final value = await cache.get('greeting');
  print(value); // Hello, World!
}
```

### Value Generation

```dart
// Get value with automatic generation if missing
final value = await cache.build(
  'user-123',
  generateValue: () async {
    // Expensive operation (e.g., API call)
    return await fetchUserFromApi('123');
  },
);
```

### Cache Management

```dart
// Remove a specific entry
await cache.remove('old-key');

// Clear all entries
await cache.clear();
```

### Custom Storage

Implement `CacheStorage` interface for custom storage backends:

```dart
class RedisStorage<T> implements CacheStorage<T> {
  @override
  Future<CacheEntry<T>?> get(String key) async {
    // Implement Redis get
  }

  @override
  Future<void> set(String key, CacheEntry<T> value) async {
    // Implement Redis set
  }

  // ... implement other methods
}
```

## Best Practices 🎯

1. **Choose Appropriate TTL**: Set TTL based on data volatility
2. **Handle Errors**: Always handle potential cache misses
3. **Type Safety**: Use specific types instead of dynamic
4. **Memory Management**: Clear unused cache entries
5. **Storage Selection**: Use appropriate storage for your use case

## Learn More 📚

- Visit [docs.vyuh.tech](https://docs.vyuh.tech) for detailed documentation
- Check out the [GitHub repository](https://github.com/vyuh-tech/vyuh)
- Report issues on the [issue tracker](https://github.com/vyuh-tech/vyuh/issues)

## License 📄

This project is licensed under the terms specified in the LICENSE file.
