import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'utils.dart';

void main() {
  group('VyuhContentWidget Builders', () {
    late MockContentPlugin mockContentPlugin;
    late MockContentProvider mockContentProvider;

    setUp(() async {
      final mock = setupMock();
      mockContentPlugin = mock.$1;
      mockContentProvider = mock.$2;

      // Set up default mock behavior
      when(
        () => mockContentProvider.fetchSingle<Document>(
          any(),
          fromJson: any(named: 'fromJson'),
          queryParams: any(named: 'queryParams'),
        ),
      ).thenAnswer((_) async => Document(title: 'Mock Document'));

      VyuhContentBinding.init(
        plugins: PluginDescriptor(others: [mockContentPlugin]),
        descriptors: [],
      );

      await VyuhBinding.instance.widgetReady;
    });

    tearDown(() async {
      await VyuhBinding.instance.dispose();
    });

    testWidgets('fromDocument uses default builder when none provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: VyuhContentWidget.fromDocument(identifier: 'test')),
      );

      await settle(tester);

      // Verify mock was called with correct parameters
      verify(
        () => mockContentProvider.fetchSingle<Document>(
          any(that: contains('vyuh.document')),
          fromJson: Document.fromJson,
          queryParams: any(
            named: 'queryParams',
            that: containsPair('identifier', 'test'),
          ),
        ),
      ).called(1);

      // Verify that content is built using VyuhContentBinding
      expect(find.text('Mock Document'), findsOneWidget);
    });

    testWidgets('fromDocument uses custom builder when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VyuhContentWidget.fromDocument(
            identifier: 'test',
            builder: (context, doc) => Text(doc.title ?? ''),
          ),
        ),
      );

      await settle(tester);

      // Verify mock was called with correct parameters
      verify(
        () => mockContentProvider.fetchSingle<Document>(
          any(that: contains('vyuh.document')),
          fromJson: Document.fromJson,
          queryParams: any(
            named: 'queryParams',
            that: containsPair('identifier', 'test'),
          ),
        ),
      ).called(1);

      expect(find.text('Mock Document'), findsOneWidget);
    });

    testWidgets('fromDocument uses correct query parameters', (tester) async {
      const testId = 'test-doc';

      await tester.pumpWidget(
        MaterialApp(home: VyuhContentWidget.fromDocument(identifier: testId)),
      );

      await settle(tester);

      // Verify mock was called with correct parameters
      verify(
        () => mockContentProvider.fetchSingle<Document>(
          any(that: contains('vyuh.document')),
          fromJson: Document.fromJson,
          queryParams: any(
            named: 'queryParams',
            that: containsPair('identifier', testId),
          ),
        ),
      ).called(1);
    });

    testWidgets('fromDocument does not refetch when its parent rebuilds', (
      tester,
    ) async {
      late StateSetter rebuild;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              // A new queryParams map on every build, with the same entries.
              return VyuhContentWidget.fromDocument(
                identifier: 'test',
                builder: (context, doc) => Text(doc.title ?? ''),
              );
            },
          ),
        ),
      );
      await settle(tester);

      rebuild(() {});
      await settle(tester);

      verify(
        () => mockContentProvider.fetchSingle<Document>(
          any(),
          fromJson: any(named: 'fromJson'),
          queryParams: any(named: 'queryParams'),
        ),
      ).called(1);
    });
  });
}
