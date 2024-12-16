import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_test/vyuh_test.dart';

void main() {
  group(
    'VyuhPlatform',
    () {
      testWidgets('handles platform events', (tester) async {
        runApp(features: () => []);
        await vyuh.getReady(tester);

        var eventReceived = false;
        final unsub = vyuh.event.on<_TestEvent>((event) {
          eventReceived = true;
        });

        vyuh.event.emit(_TestEvent());

        // Since the EventBus is based on streams, we should wait
        // for the event queue to get flushed
        await tester.pumpAndSettle();
        expect(eventReceived, isTrue);

        eventReceived = false;
        unsub();

        // After cancellation, should not receive events
        vyuh.event.emit(_TestEvent());

        await tester.pumpAndSettle();
        expect(eventReceived, isFalse);
      });

      testWidgets('emits events in order during initialization',
          (tester) async {
        final events = <String>[];

        runApp(
          features: () => [
            FeatureDescriptor(
              name: 'test',
              title: 'Test',
              init: () async {
                events.add('feature init');

                vyuh.event.once<SystemReadyEvent>((event) {
                  events.add('platform ready');
                });
              },
              routes: () {
                events.add('routes init');
                return [];
              },
            ),
          ],
        );

        await vyuh.getReady(tester);

        expect(
            events,
            equals([
              'feature init',
              'routes init',
              'platform ready',
            ]));
      });
    },
  );
}

final class _TestEvent extends VyuhEvent {
  _TestEvent() : super(name: 'test.event');
}
