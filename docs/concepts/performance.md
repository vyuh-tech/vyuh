---
title: Performance and correctness
---

# Performance and correctness

Good boundaries make performance work easier to locate. Measure the capability doing the work, then check the feature and app behavior that depends on it.

## Cache expensive fetches

`vyuh_cache` provides `Cache`, `CacheConfig`, and pluggable `CacheStorage`. A configured TTL determines whether a stored value is usable. Expired reads return `null`; `build` can generate a replacement. Concurrent misses for the same key share generation.

```dart
import 'package:vyuh_cache/vyuh_cache.dart';

Future<void> main() async {
  final cache = Cache<String>(CacheConfig(
    storage: MemoryCacheStorage<String>(),
    ttl: const Duration(minutes: 5),
  ));
  final value = await cache.build('greeting', generateValue: () async => 'Hello');
  print(value);
}
```

Use `remove` or `clear` when the underlying data changes. The in-memory storage has no capacity limit and expires entries when accessed; choose a bounded storage implementation if your workload needs an eviction policy. Cache invalidation does not cancel a generator already in flight.

## Keep initialization dependencies explicit

Independent features can initialize concurrently. A dependent feature must wait until its prerequisites are ready. Removing that wait can look faster while producing intermittent failures. Measure time to app readiness separately from time to the first useful screen.

## Split work at real boundaries

Use lazy features for infrequently visited areas. Use fine-grained observers for state that changes independently. Keep shared network, storage, and telemetry behavior inside plugin implementations so every feature benefits from improvements there.

## Verify accuracy

Test expiration boundaries, concurrent calls, failed initialization, and dependency ordering. Keep public examples aligned with the source signatures and package versions they demonstrate.

See [cache APIs](/api/vyuh-cache), [startup and lifecycle](runtime-lifecycle).
