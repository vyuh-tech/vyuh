// ignore_for_file: avoid_print

import 'dart:async';

import 'package:vyuh_cache/vyuh_cache.dart';

// Simulating an API client
class ApiClient {
  Future<String> fetchUserData(String id) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    return 'User data for ID: $id';
  }

  Future<Map<String, dynamic>> fetchProductDetails(String productId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return {
      'id': productId,
      'name': 'Product $productId',
      'price': 99.99,
    };
  }
}

void main() async {
  // Initialize API client
  final apiClient = ApiClient();

  // Example 1: Basic String Cache
  print('\n=== Basic String Cache Example ===');
  final stringCache = Cache(
    CacheConfig(
      storage: MemoryCacheStorage<String>(),
      ttl: const Duration(minutes: 5),
    ),
  );

  // Store and retrieve a simple string
  await stringCache.set('greeting', 'Hello, World!');
  if (await stringCache.has('greeting')) {
    final greeting = await stringCache.get('greeting');
    print('Cached greeting: $greeting');
  }

  // Example 2: Caching User Data with Auto-Generation
  print('\n=== User Data Cache with Auto-Generation Example ===');
  final userCache = Cache(
    CacheConfig(
      storage: MemoryCacheStorage<String>(),
      ttl: const Duration(minutes: 10),
    ),
  );

  // Function to demonstrate multiple requests
  Future<void> getUserData(String userId) async {
    final userData = await userCache.build(
      'user-$userId',
      generateValue: () => apiClient.fetchUserData(userId),
    );
    print(
        'User data (${await userCache.has('user-$userId') ? 'from cache' : 'from API'}): $userData');
  }

  // First request - will fetch from API
  await getUserData('123');
  // Second request - will fetch from cache
  await getUserData('123');

  // Example 3: Complex Object Cache (Map)
  print('\n=== Complex Object Cache Example ===');
  final productCache = Cache(
    CacheConfig(
      storage: MemoryCacheStorage<Map<String, dynamic>>(),
      ttl: const Duration(minutes: 15),
    ),
  );

  // Fetch and cache product details
  final productId = 'PROD-001';
  final productDetails = await productCache.build(
    'product-$productId',
    generateValue: () => apiClient.fetchProductDetails(productId),
  );

  print('Product details: $productDetails');

  // Example 4: Cache Management
  print('\n=== Cache Management Example ===');

  // List all keys in string cache
  final keys = await stringCache.config.storage.keys();
  print('Current keys in string cache: $keys');

  // Remove specific entry
  await stringCache.remove('greeting');
  print(
      'After removing greeting - exists: ${await stringCache.has('greeting')}');

  // Clear entire cache
  await stringCache.clear();
  print(
      'After clearing - number of keys: ${(await stringCache.config.storage.keys()).length}');

  // Example 5: Error Handling
  print('\n=== Error Handling Example ===');
  try {
    await userCache.build(
      'error-user',
      generateValue: () => throw Exception('Failed to fetch user data'),
    );
  } catch (e) {
    print('Handled error: $e');
  }

  // Example 6: TTL Demonstration
  print('\n=== TTL Demonstration ===');
  final shortCache = Cache(
    CacheConfig(
      storage: MemoryCacheStorage<String>(),
      ttl: const Duration(seconds: 2), // Very short TTL for demonstration
    ),
  );

  await shortCache.set('quick-value', 'This will expire soon');
  print('Initial value exists: ${await shortCache.has('quick-value')}');

  await Future.delayed(const Duration(seconds: 3));
  print(
      'After TTL expired - value exists: ${await shortCache.has('quick-value')}');
}
