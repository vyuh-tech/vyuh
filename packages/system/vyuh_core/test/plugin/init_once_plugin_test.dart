import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class ResourcePlugin extends Plugin with InitOncePlugin {
  ResourcePlugin() : super(name: 'resource', title: 'Resource');
  int opens = 0;
  int closes = 0;
  bool fail = false;
  Completer<void>? opening;
  @override
  Future<void> initOnce() async {
    opens++;
    if (fail) throw StateError('Open failed');
    await opening?.future;
  }

  @override
  Future<void> disposeOnce() async {
    closes++;
  }
}

void main() {
  group('InitOncePlugin resource lifecycle', () {
    test('pre-init cleanup does not touch an unopened resource', () async {
      final plugin = ResourcePlugin();
      await plugin.dispose();
      expect(plugin.closes, 0);
      await plugin.init();
      await plugin.dispose();
      expect(plugin.closes, 1);
      expect(plugin.initialized, isFalse);
    });
    test(
      'concurrent initialization opens once and disposal closes once',
      () async {
        final plugin = ResourcePlugin()..opening = Completer<void>();
        final requests = List.generate(8, (_) => plugin.init());
        plugin.opening!.complete();
        await Future.wait(requests);
        expect(plugin.opens, 1);
        expect(plugin.initialized, isTrue);
        await Future.wait(List.generate(8, (_) => plugin.dispose()));
        expect(plugin.closes, 1);
      },
    );
    test('failed initialization can be retried', () async {
      final plugin = ResourcePlugin()..fail = true;
      await expectLater(plugin.init(), throwsStateError);
      expect(plugin.initialized, isFalse);
      plugin.fail = false;
      await plugin.init();
      expect(plugin.opens, 2);
      await plugin.dispose();
    });
    test(
      'disposal waits for an in-flight open and supports a new lifecycle',
      () async {
        final plugin = ResourcePlugin()..opening = Completer<void>();
        final init = plugin.init();
        final dispose = plugin.dispose();
        expect(plugin.closes, 0);
        plugin.opening!.complete();
        await init;
        await dispose;
        expect(plugin.closes, 1);
        await plugin.init();
        expect(plugin.opens, 2);
        await plugin.dispose();
        expect(plugin.closes, 2);
      },
    );
  });
}
