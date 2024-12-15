import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

class MockContentProvider extends Mock implements ContentProvider {
  @override
  String get title => 'Mock Provider';

  @override
  String schemaType(Map<String, dynamic> json) {
    return json['type'] as String;
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<RouteBase?> fetchRoute({String? path, String? routeId}) async {
    return MockRoute(path: path ?? '/');
  }
}

class TestContentItem extends ContentItem {
  static const schemaName = 'test_item';

  final String id;
  final String title;

  static final typeDescriptor = TypeDescriptor<TestContentItem>(
    schemaType: schemaName,
    title: 'Test Item',
    fromJson: TestContentItem.fromJson,
  );

  static final contentBuilder = ContentBuilder<TestContentItem>(
    content: typeDescriptor,
    defaultLayout: TestLayoutConfiguration(padding: 0),
    defaultLayoutDescriptor: TestLayoutConfiguration.typeDescriptor,
  );

  TestContentItem({
    required this.id,
    required this.title,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory TestContentItem.fromJson(Map<String, dynamic> json) {
    return TestContentItem(
      id: json['id'] as String,
      title: json['title'] as String,
      layout: typeFromFirstOfListJson<LayoutConfiguration<TestContentItem>>(
          json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );
  }
}

class TestLayoutConfiguration extends LayoutConfiguration<TestContentItem> {
  static const schemaName = 'test_layout';

  static final typeDescriptor =
      TypeDescriptor<LayoutConfiguration<TestContentItem>>(
    schemaType: schemaName,
    title: 'Test Layout',
    fromJson: TestLayoutConfiguration.fromJson,
  );

  final double padding;

  TestLayoutConfiguration({
    required this.padding,
  }) : super(schemaType: schemaName);

  factory TestLayoutConfiguration.fromJson(Map<String, dynamic> json) {
    return TestLayoutConfiguration(
      padding: (json['padding'] as num).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context, TestContentItem content) {
    return Container();
  }
}

class TestContentDescriptor extends ContentDescriptor {
  TestContentDescriptor({
    super.layouts,
  }) : super(
          schemaType: TestContentItem.schemaName,
          title: 'Test Content Item',
        );
}

class TestModifier extends ContentModifierConfiguration {
  static const schemaName = 'test_modifier';

  static final typeDescriptor = TypeDescriptor<ContentModifierConfiguration>(
    schemaType: schemaName,
    title: 'Test Modifier',
    fromJson: TestModifier.fromJson,
  );

  final bool enabled;

  TestModifier({
    required this.enabled,
  }) : super(schemaType: schemaName);

  factory TestModifier.fromJson(Map<String, dynamic> json) {
    return TestModifier(
      enabled: json['enabled'] as bool,
    );
  }

  @override
  Widget build(BuildContext context, Widget child, ContentItem content) {
    return enabled ? child : Container();
  }
}

final class MockRoute extends RouteBase {
  static const schemaName = 'mock.route';

  MockRoute({
    required super.path,
    super.layout,
    super.modifiers,
    super.category,
  }) : super(
          schemaType: schemaName,
          title: 'Mock Route',
          id: 'mock.route',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

  @override
  String get schemaType => 'mock.route';

  static final typeDescriptor = TypeDescriptor(
      schemaType: schemaName,
      fromJson: MockRoute.fromJson,
      title: 'Mock Route');

  static final contentBuilder = ContentBuilder(
    content: MockRoute.typeDescriptor,
    defaultLayout: MockLayoutConfiguration(),
    defaultLayoutDescriptor: MockLayoutConfiguration.typeDescriptor,
  );

  factory MockRoute.fromJson(Map<String, dynamic> json) {
    return MockRoute(path: json['path'] ?? '/');
  }

  @override
  Future<RouteBase?> init() async {
    return this;
  }

  @override
  Future<void> dispose() async {}
}

class MockLayoutConfiguration extends LayoutConfiguration<MockRoute> {
  static const schemaName = 'mock.layout';

  static final typeDescriptor = TypeDescriptor(
      schemaType: schemaName,
      fromJson: MockLayoutConfiguration.fromJson,
      title: 'Mock Layout');

  MockLayoutConfiguration() : super(schemaType: schemaName);

  factory MockLayoutConfiguration.fromJson(Map<String, dynamic> json) {
    return MockLayoutConfiguration();
  }

  @override
  Widget build(BuildContext context, MockRoute content) {
    return Container();
  }
}

class MockRouteDescriptor extends ContentDescriptor {
  MockRouteDescriptor({
    super.layouts,
  }) : super(
          schemaType: MockRoute.schemaName,
          title: 'Mock Route',
        );
}

class TestAction extends ActionConfiguration {
  static const schemaName = 'test_action';

  static final typeDescriptor = TypeDescriptor<ActionConfiguration>(
    schemaType: schemaName,
    title: 'Test Action',
    fromJson: TestAction.fromJson,
  );

  final String actionType;

  TestAction({
    required this.actionType,
    super.isAwaited,
  }) : super(schemaType: schemaName);

  factory TestAction.fromJson(Map<String, dynamic> json) {
    return TestAction(
      actionType: json['actionType'] as String,
    );
  }

  @override
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) async {
    // Mock action execution
  }
}

class TestCondition extends ConditionConfiguration {
  static const schemaName = 'test_condition';

  static final typeDescriptor = TypeDescriptor<ConditionConfiguration>(
    schemaType: schemaName,
    title: 'Test Condition',
    fromJson: TestCondition.fromJson,
  );

  final bool condition;

  TestCondition({
    required this.condition,
  }) : super(schemaType: schemaName);

  factory TestCondition.fromJson(Map<String, dynamic> json) {
    return TestCondition(
      condition: json['condition'] as bool,
    );
  }

  @override
  Future<String?> execute(BuildContext context) async {
    return condition ? 'true' : null;
  }
}
