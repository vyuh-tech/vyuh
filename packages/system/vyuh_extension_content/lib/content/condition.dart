import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'condition.g.dart';

/// A conditional expression that can be evaluated at runtime.
/// 
/// Conditions are used to make dynamic decisions in the application based
/// on the current state or user input. They can be used for:
/// - Navigation guards
/// - Content visibility
/// - Feature flags
/// - A/B testing
/// 
/// Example CMS schema:
/// ```typescript
/// export const condition = defineType({
///   name: 'condition',
///   fields: [
///     {
///       name: 'configuration',
///       type: 'reference',
///       to: [{type: 'condition.config'}],
///     },
///   ],
/// });
/// ```
/// 
/// Example usage:
/// ```dart
/// final condition = Condition(
///   configuration: UserRoleCondition(
///     allowedRoles: ['admin', 'editor'],
///   ),
/// );
/// 
/// // Evaluate the condition
/// final result = await condition.execute(context);
/// if (result == null) {
///   // Condition passed
/// } else {
///   // Condition failed with error message
///   print('Access denied: $result');
/// }
/// ```
@JsonSerializable()
final class Condition {
  /// The configuration that defines the condition's logic.
  /// 
  /// Only one configuration is allowed per condition. The configuration
  /// determines how the condition is evaluated.
  @JsonKey(fromJson: typeFromFirstOfListJson<ConditionConfiguration>)
  final ConditionConfiguration? configuration;

  /// Creates a new condition with the given configuration.
  Condition({this.configuration});

  /// Evaluates the condition in the current context.
  /// 
  /// Returns:
  /// - null if the condition passes
  /// - an error message string if the condition fails
  Future<String?> execute(BuildContext context) async {
    return configuration?.execute(context);
  }

  /// Creates a condition from a JSON object.
  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);
}

/// Base class for all condition configurations.
/// 
/// Condition configurations define the evaluation logic for a condition.
/// Each type of configuration implements this class and provides its own
/// execution logic.
/// 
/// Common configuration types include:
/// - User role checks
/// - Feature flag checks
/// - Time-based conditions
/// - State-based conditions
/// 
/// Example implementation:
/// ```dart
/// @JsonSerializable()
/// class UserRoleCondition extends ConditionConfiguration {
///   static const schemaName = 'condition.user_role';
///   
///   final List<String> allowedRoles;
///   
///   UserRoleCondition({
///     required this.allowedRoles,
///     super.title,
///   }) : super(schemaType: schemaName);
///   
///   @override
///   Future<String?> execute(BuildContext context) async {
///     final user = vyuh.auth.currentUser;
///     if (user == null) {
///       return 'Not authenticated';
///     }
///     
///     if (!allowedRoles.contains(user.role)) {
///       return 'Insufficient permissions';
///     }
///     
///     return null; // Condition passed
///   }
/// }
/// ```
abstract class ConditionConfiguration implements SchemaItem {
  /// The schema type of this configuration.
  /// 
  /// Must match the type name defined in the CMS schema.
  @override
  final String schemaType;

  /// Optional title for this configuration.
  /// 
  /// Used for debugging and UI display purposes.
  final String? title;

  /// Creates a new condition configuration.
  ConditionConfiguration({
    required this.schemaType,
    this.title,
  });

  /// Evaluates this condition configuration.
  /// 
  /// The [context] parameter provides access to the widget tree.
  /// 
  /// Returns:
  /// - null if the condition passes
  /// - an error message string if the condition fails
  Future<String?> execute(BuildContext context);
}
