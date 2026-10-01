import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:vyuh_core/vyuh_core.dart' as core;
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/action/navigation.dart';
import 'package:vyuh_feature_system/action/route_refresh.dart';

class _Provider implements core.ContentProvider {
  late final result = Completer<core.RouteBase?>();

  @override
  Future<core.RouteBase?> fetchRoute({
    String? path,
    String? routeId,
    bool useCache = true,
  }) => result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Content extends core.ContentPlugin {
  _Content(core.ContentProvider provider)
    : super(provider: provider, name: 'test', title: 'Test');

  @override
  Future<void> init() async {}
  @override
  Future<void> dispose() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Route implements core.RouteBase {
  @override
  String get path => '/destination';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Navigation extends core.NavigationPlugin {
  _Navigation() : super(name: 'test.navigation', title: 'Test Navigation');
  String? destination;

  @override
  void go(String location, {Object? extra}) {
    destination = location;
  }

  @override
  Future<void> init() async {}
  @override
  Future<void> dispose() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _Provider provider;
  late _Navigation navigation;
  setUp(() async {
    provider = _Provider();
    navigation = _Navigation();
    core.runApp(
      features: () => [],
      appRunner: (_) {},
      plugins: core.PluginDescriptor(
        content: _Content(provider),
        navigation: navigation,
      ),
    );
    while (!core.VyuhBinding.instance.initialized) {
      await Future<void>.delayed(Duration.zero);
    }
  });
  tearDown(() => core.VyuhBinding.instance.dispose());

  testWidgets('navigation completes after resolving the route', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );
    final action = NavigationAction(
      linkType: LinkType.route,
      route: core.ObjectReference(type: 'reference', ref: 'target'),
      navigationType: NavigationType.go,
    );
    var completed = false;
    final pending = action.execute(context).then((_) {
      completed = true;
    });
    await tester.pump();
    expect(completed, isFalse);
    expect(navigation.destination, isNull);
    provider.result.complete(_Route());
    await tester.pump();
    await pending;
    expect(completed, isTrue);
    expect(navigation.destination, '/destination');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('invalid destination is rejected for its selected link type', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      Builder(
        builder: (value) {
          context = value;
          return const SizedBox();
        },
      ),
    );
    await expectLater(
      NavigationAction(
        linkType: LinkType.route,
        url: '/other',
      ).execute(context),
      throwsArgumentError,
    );
    await expectLater(
      NavigationAction(
        linkType: LinkType.url,
        route: core.ObjectReference(type: 'reference', ref: 'other'),
      ).execute(context),
      throwsArgumentError,
    );
  });

  testWidgets('refresh action completes after the refresh callback', (
    tester,
  ) async {
    final refresh = Completer<void>();
    late BuildContext context;
    await tester.pumpWidget(
      RouteBuilderProxy(
        onRefresh: () => refresh.future,
        child: Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );
    var completed = false;
    final pending = RouteRefreshAction().execute(context).then((_) {
      completed = true;
    });
    await tester.pump();
    expect(completed, isFalse);
    refresh.complete();
    await tester.pump();
    await pending;
    expect(completed, isTrue);
  });
}
