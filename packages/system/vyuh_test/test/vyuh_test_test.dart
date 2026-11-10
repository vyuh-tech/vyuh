import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

void main() {
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });

  testWidgets('getReady waits until the platform is ready', (tester) async {
    vc.runApp(
      features: () => [
        vc.FeatureDescriptor(name: 'home', title: 'Home'),
      ],
    );
    await vc.vyuh.getReady(tester);

    expect(vc.vyuh.tracker.currentState.value, vc.InitState.ready);
  });

  testWidgets('getReady also returns when the platform fails', (tester) async {
    vc.runApp(
      features: () => [
        vc.FeatureDescriptor(
          name: 'broken',
          title: 'Broken',
          init: () async => throw StateError('boom'),
        ),
      ],
    );
    await vc.vyuh.getReady(tester);

    expect(vc.vyuh.tracker.currentState.value, vc.InitState.error);
  });

  test('TestBuildContext stands in for a BuildContext', () {
    expect(TestBuildContext(), isA<BuildContext>());
  });
}
