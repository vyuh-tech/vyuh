import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_test/vyuh_test.dart';

import '../example/composed_app.dart' as example;

void main() {
  tearDown(() async {
    if (vc.VyuhBinding.instance.initialized) await vc.vyuh.dispose();
  });

  testWidgets('two features share edits through the app-selected plugin', (
    tester,
  ) async {
    example.main();
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Learn feature composition');
    await tester.tap(find.text('Save bookmark'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Insights'));
    await tester.pumpAndSettle();
    expect(find.text('1 saved bookmarks'), findsOneWidget);

    await tester.tap(find.text('Bookmarks'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remove bookmark'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Insights'));
    await tester.pumpAndSettle();
    expect(find.text('0 saved bookmarks'), findsOneWidget);
  });

  testWidgets('Insights runs without its companion feature', (tester) async {
    vc.runApp(
      initialLocation: '/insights',
      plugins: vc.PluginDescriptor(others: [example.MemoryBookmarksPlugin()]),
      platformWidgetBuilder: example.platformWidgets,
      features: () => [example.insightsFeature()],
    );
    await vc.vyuh.getReady(tester);
    await tester.pumpAndSettle();
    expect(find.text('0 saved bookmarks'), findsOneWidget);
    expect(find.text('Bookmarks'), findsNothing);
    expect(vc.vyuh.features.map((feature) => feature.name), ['insights']);
  });
}
