import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'conditional.g.dart';

/// A content item that conditionally renders different content based on a condition.
///
/// Features:
/// * Dynamic content switching based on conditions
/// * Multiple case handling with default fallback
/// * Optional loading indicator during evaluation
/// * Support for any content type in cases
///
/// Example:
/// ```dart
/// final conditional = Conditional(
///   condition: Condition(
///     configuration: ScreenSize(),
///   ),
///   cases: [
///     CaseItem(
///       value: 'mobile',
///       item: Card(title: 'Mobile View'),
///     ),
///     CaseItem(
///       value: 'desktop',
///       item: Card(title: 'Desktop View'),
///     ),
///   ],
///   defaultCase: 'mobile',
///   showPending: true,
/// );
/// ```
@JsonSerializable()
class Conditional extends ContentItem {
  static const schemaName = 'vyuh.conditional';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Conditional',
    fromJson: Conditional.fromJson,
    preview: () => Conditional(
        showPending: true,
        condition: Condition(
          configuration:
              BooleanCondition(value: true, evaluationDelayInSeconds: 1),
        ),
        defaultCase: 'false',
        cases: [
          CaseItem(
              value: 'true',
              item: Card(title: 'True', description: 'true Card')),
          CaseItem(
              value: 'false',
              item: Card(title: 'False', description: 'false Card')),
        ]),
  );

  static final contentBuilder = ContentBuilder(
    content: Conditional.typeDescriptor,
    defaultLayout: DefaultConditionalLayout(),
    defaultLayoutDescriptor: DefaultConditionalLayout.typeDescriptor,
  );

  @JsonKey(defaultValue: [])
  final List<CaseItem>? cases;

  final String? defaultCase;
  final Condition? condition;
  final bool showPending;

  Conditional({
    this.cases,
    this.condition,
    this.defaultCase,
    this.showPending = false,
    super.layout,
    super.modifiers,
  }) : super(schemaType: Conditional.schemaName);

  factory Conditional.fromJson(Map<String, dynamic> json) =>
      _$ConditionalFromJson(json);

  Future<ContentItem?> execute(BuildContext context) async {
    final value = (await condition?.execute(context)) ?? defaultCase;

    final caseItem =
        cases?.firstWhereOrNull((element) => element.value == value);

    return caseItem?.item;
  }
}

/// A case item that pairs a condition value with its corresponding content.
///
/// Used within [Conditional] to define what content should be shown for each
/// condition value.
///
/// Example:
/// ```dart
/// final case = CaseItem(
///   value: 'mobile',
///   item: Card(title: 'Mobile View'),
/// );
/// ```
@JsonSerializable()
final class CaseItem<T extends SchemaItem> {
  final String? value;

  @JsonKey(fromJson: typeFromFirstOfListJson<ContentItem>)
  final ContentItem? item;

  CaseItem({this.value, this.item});

  factory CaseItem.fromJson(Map<String, dynamic> json) =>
      _$CaseItemFromJson(json);
}

/// Descriptor for configuring conditional content type in the system.
///
/// Allows configuring:
/// * Available layouts for conditional content
/// * Custom layouts for specific use cases
///
/// Example:
/// ```dart
/// final descriptor = ConditionalDescriptor(
///   layouts: [
///     DefaultConditionalLayout.typeDescriptor,
///   ],
/// );
/// ```
class ConditionalDescriptor extends ContentDescriptor {
  ConditionalDescriptor({super.layouts})
      : super(schemaType: Conditional.schemaName, title: 'Conditional');
}

/// Default layout for conditional content.
///
/// Features:
/// * Handles condition evaluation
/// * Shows loading state when configured
/// * Renders selected content
/// * Handles empty states
///
/// Example:
/// ```dart
/// final layout = DefaultConditionalLayout();
/// ```
final class DefaultConditionalLayout extends LayoutConfiguration<Conditional> {
  static const schemaName = '${Conditional.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default Conditional Layout',
    fromJson: DefaultConditionalLayout.fromJson,
    preview: () => DefaultConditionalLayout(),
  );

  DefaultConditionalLayout() : super(schemaType: schemaName);

  factory DefaultConditionalLayout.fromJson(Map<String, dynamic> json) =>
      DefaultConditionalLayout();

  @override
  Widget build(BuildContext context, Conditional content) =>
      _ConditionalBuilder(conditional: content);
}

class _ConditionalBuilder extends StatelessWidget {
  final Conditional conditional;

  const _ConditionalBuilder({required this.conditional});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: conditional.execute(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done || ConnectionState.active:
              final item = snapshot.data;
              return item == null
                  ? empty
                  : vyuh.content.buildContent(context, item);

            default:
              return conditional.showPending
                  ? vyuh.widgetBuilder.contentLoader(context)
                  : empty;
          }
        });
  }
}
