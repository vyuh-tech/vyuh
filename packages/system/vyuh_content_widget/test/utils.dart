import 'package:mocktail/mocktail.dart';
import 'package:vyuh_core/vyuh_core.dart';

class MockContentPlugin extends Mock implements ContentPlugin {}

class MockContentProvider extends Mock implements ContentProvider {}

class MockWidgetBuilder extends Mock implements PlatformWidgetBuilder {}

class MockExtensionBuilder extends Mock implements ExtensionBuilder {}

(MockContentPlugin, MockContentProvider) setupMock() {
  final mockContentPlugin = MockContentPlugin();
  final mockContentProvider = MockContentProvider();

  registerFallbackValue(MockExtensionBuilder());

  // Setup basic plugin behavior
  when(() => mockContentPlugin.provider).thenReturn(mockContentProvider);
  when(() => mockContentPlugin.dispose()).thenAnswer((_) async {});
  when<Future<void>>(() => mockContentPlugin.init()).thenAnswer((_) async {});
  when(() => mockContentPlugin.attach(any())).thenAnswer((_) async {});

  return (mockContentPlugin, mockContentProvider);
}
