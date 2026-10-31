import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class MockContentPlugin extends Mock implements ContentPlugin {}

class MockContentProvider extends Mock implements ContentProvider {}

class MockWidgetBuilder extends Mock implements PlatformWidgetBuilder {}

class MockExtensionBuilder extends Mock implements ExtensionBuilder {}

class _FakeBuildContext extends Fake implements BuildContext {}

(MockContentPlugin, MockContentProvider) setupMock() {
  final mockContentPlugin = MockContentPlugin();
  final mockContentProvider = MockContentProvider();

  registerFallbackValue(MockExtensionBuilder());
  registerFallbackValue(_FakeBuildContext());
  registerFallbackValue(Document());

  // Setup basic plugin behavior
  when(() => mockContentPlugin.provider).thenReturn(mockContentProvider);
  when(() => mockContentPlugin.dispose()).thenAnswer((_) async {});
  when<Future<void>>(() => mockContentPlugin.init()).thenAnswer((_) async {});
  when(() => mockContentPlugin.attach(any())).thenAnswer((_) async {});
  // Render content as its title, standing in for the real content builders.
  when(() => mockContentPlugin.buildContent<Document>(any(), any())).thenAnswer(
    (invocation) =>
        Text((invocation.positionalArguments[1] as Document).title ?? ''),
  );

  return (mockContentPlugin, mockContentProvider);
}

/// Lets the content fetch run, then renders the result.
///
/// The binding is initialized in `setUp`, outside the widget test's fake
/// async zone, so work chained on `VyuhBinding.instance.widgetReady` runs on
/// the real event loop. Give it a turn before pumping.
Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
}
