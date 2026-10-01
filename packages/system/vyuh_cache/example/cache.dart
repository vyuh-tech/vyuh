import 'package:vyuh_cache/vyuh_cache.dart';

Future<void> main() async {
  final cache = Cache<String>(CacheConfig(
    storage: MemoryCacheStorage<String>(),
    ttl: const Duration(minutes: 5),
  ));
  final greeting = await cache.build(
    'greeting',
    generateValue: () async => 'Hello, Vyuh.',
  );
  // ignore: avoid_print
  print(greeting);
  await cache.remove('greeting');
}
