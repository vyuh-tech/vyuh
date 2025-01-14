import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'boolean.g.dart';

/// A simple boolean condition configuration with optional evaluation delay.
///
/// Features:
/// * Basic true/false evaluation
/// * Configurable evaluation delay
/// * String value conversion
/// * Asynchronous evaluation
///
/// Example:
/// ```dart
/// // Simple boolean condition
/// final condition = BooleanCondition(
///   value: true,
/// );
///
/// // With evaluation delay
/// final condition = BooleanCondition(
///   value: true,
///   evaluationDelayInSeconds: 2,
/// );
///
/// // In a conditional content
/// final conditional = Conditional(
///   condition: Condition(
///     configuration: BooleanCondition(value: true),
///   ),
///   cases: [
///     CaseItem(
///       value: 'true',
///       item: EnabledContent(),
///     ),
///     CaseItem(
///       value: 'false',
///       item: DisabledContent(),
///     ),
///   ],
///   defaultCase: 'false',
/// );
/// ```
///
/// The condition:
/// * Returns 'true' or 'false' as strings
/// * Can delay evaluation for testing/simulation
/// * Useful for simple toggles and flags
@JsonSerializable()
final class BooleanCondition extends ConditionConfiguration {
  static const schemaName = 'vyuh.condition.boolean';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Boolean Condition',
    fromJson: BooleanCondition.fromJson,
  );

  final bool value;

  final int evaluationDelayInSeconds;

  BooleanCondition({this.value = false, this.evaluationDelayInSeconds = 0})
      : super(schemaType: schemaName);

  factory BooleanCondition.fromJson(Map<String, dynamic> json) =>
      _$BooleanConditionFromJson(json);

  @override
  Future<String?> execute(BuildContext context) async {
    if (evaluationDelayInSeconds > 0) {
      await Future.delayed(Duration(seconds: evaluationDelayInSeconds));
    }

    return value.toString();
  }
}
