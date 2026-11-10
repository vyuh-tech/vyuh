import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// Runs in its own file so `vyuh` is still the uninitialized platform.
void main() {
  final notRunning = throwsA(
    isA<StateError>().having(
      (e) => e.message,
      'message',
      contains('call runApp()'),
    ),
  );

  test('every member of the uninitialized platform asks for runApp()', () {
    final trace = NoOpTrace();
    expect(() => vyuh.featureReady('x'), notRunning);
    expect(() => vyuh.features, notRunning);
    expect(() => vyuh.getPlugin<EventPlugin>(), notRunning);
    expect(() => vyuh.initFeatures(trace), notRunning);
    expect(() => vyuh.initPlugins(trace), notRunning);
    expect(() => vyuh.plugins, notRunning);
    expect(() => vyuh.extensionBuilder<ExtensionDescriptor>(), notRunning);
    expect(() => vyuh.rootNavigatorKey, notRunning);
    expect(() => vyuh.run(), notRunning);
    expect(() => vyuh.dispose(), notRunning);
    expect(() => vyuh.tracker, notRunning);
    expect(() => vyuh.widgetBuilder, notRunning);
    expect(() => vyuh.isFeatureLoaded('x'), notRunning);
    expect(() => vyuh.loadFeature('x'), notRunning);
  });

  test('framework strings fall back to the defaults without an app', () {
    expect(VyuhStrings.current.tryAgain, 'Try again');
  });

  testWidgets('BuildFailureView is a quiet placeholder, even without an app '
      'or a Directionality', (tester) async {
    final details = FlutterErrorDetails(exception: StateError('broken'));
    await tester.pumpWidget(BuildFailureView(details: details));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.semanticLabel, 'Content unavailable');
  });
}
