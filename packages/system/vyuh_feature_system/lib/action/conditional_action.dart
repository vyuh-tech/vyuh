import 'package:collection/collection.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'conditional_action.g.dart';

/// An action configuration that executes different actions based on a condition.
///
/// Features:
/// * Dynamic action selection based on conditions
/// * Multiple case handling with default fallback
/// * Support for any action type in cases
/// * Asynchronous condition evaluation
///
/// Example:
/// ```dart
/// final action = ConditionalAction(
///   condition: Condition(
///     configuration: ScreenSize(),
///   ),
///   cases: [
///     ActionCase(
///       value: 'mobile',
///       action: Action(
///         configurations: [
///           NavigationAction(url: '/mobile-view'),
///         ],
///       ),
///     ),
///     ActionCase(
///       value: 'desktop',
///       action: Action(
///         configurations: [
///           NavigationAction(url: '/desktop-view'),
///         ],
///       ),
///     ),
///   ],
///   defaultCase: 'mobile',
/// );
/// ```
@JsonSerializable()
class ConditionalAction extends ActionConfiguration {
  static const schemaName = 'vyuh.action.conditional';

  static final typeDescriptor = TypeDescriptor(
    schemaType: ConditionalAction.schemaName,
    title: 'Conditional Action',
    fromJson: ConditionalAction.fromJson,
  );

  @JsonKey(defaultValue: [])
  final List<ActionCase>? cases;

  final String? defaultCase;
  final Condition? condition;

  ConditionalAction({
    this.cases,
    this.condition,
    this.defaultCase,
    super.isAwaited,
  }) : super(schemaType: ConditionalAction.schemaName);

  factory ConditionalAction.fromJson(Map<String, dynamic> json) =>
      _$ConditionalActionFromJson(json);

  @override
  Future<void> execute(flutter.BuildContext context,
      {Map<String, dynamic>? arguments}) async {
    final value = (await condition?.execute(context)) ?? defaultCase;

    if (context.mounted) {
      final caseAction =
          cases?.firstWhereOrNull((element) => element.value == value);

      caseAction?.action?.execute(context);
    }
  }
}

/// A case item that pairs a condition value with its corresponding action.
///
/// Used within [ConditionalAction] to define what action should be executed
/// for each condition value.
///
/// Example:
/// ```dart
/// final case = ActionCase(
///   value: 'mobile',
///   action: Action(
///     configurations: [
///       NavigationAction(url: '/mobile-view'),
///     ],
///   ),
/// );
/// ```
@JsonSerializable()
final class ActionCase {
  final String? value;

  final Action? action;

  ActionCase({this.value, this.action});

  factory ActionCase.fromJson(Map<String, dynamic> json) =>
      _$ActionCaseFromJson(json);
}
