import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// Extension to help with testing platform readiness
extension ReadyCheck on VyuhPlatform {
  /// Waits for the platform to be ready or in error state
  Future<void> getReady(WidgetTester tester) async {
    final completer = Completer<void>();
    when(
        (_) =>
            tracker.currentState.value == InitState.ready ||
            tracker.currentState.value == InitState.error, () {
      completer.complete();
    });

    await tester.pumpAndSettle();

    return completer.future;
  }
}
