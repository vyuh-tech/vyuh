import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

part 'action.g.dart';

/// A composable action that can be executed in response to user interaction.
/// 
/// Actions are defined in the CMS and can contain multiple configurations
/// that are executed in sequence. Each configuration can be:
/// - Awaited or non-awaited
/// - Parameterized with arguments
/// - Customized with a title
/// 
/// Example CMS schema:
/// ```typescript
/// export const action = defineType({
///   name: 'action',
///   fields: [
///     {name: 'title', type: 'string'},
///     {name: 'configurations', type: 'array', of: [{type: 'action.config'}]},
///   ],
/// });
/// ```
/// 
/// Example usage:
/// ```dart
/// final action = Action(
///   title: 'Submit Form',
///   configurations: [
///     ValidateFormConfig(),
///     SaveDataConfig(isAwaited: true),
///     ShowToastConfig(message: 'Saved!'),
///   ],
/// );
/// 
/// // Execute the action
/// await action.execute(context, arguments: {'formData': data});
/// ```
@JsonSerializable()
final class Action {
  /// Optional title for the action.
  /// 
  /// Used for debugging and UI display purposes.
  final String? title;

  /// List of configurations to execute when the action is triggered.
  /// 
  /// Configurations are executed in sequence, with awaited configurations
  /// blocking until completion.
  @JsonKey(fromJson: Action.configurationList)
  final List<ActionConfiguration>? configurations;

  /// Converts a JSON array to a list of [ActionConfiguration] instances.
  static configurationList(dynamic json) =>
      listFromJson<ActionConfiguration>(json);

  /// Executes all configurations in sequence.
  /// 
  /// For each configuration:
  /// - If [isAwaited] is true, waits for completion before continuing
  /// - If [isAwaited] is false, executes asynchronously
  /// 
  /// The [arguments] map is passed to each configuration's execute method.
  FutureOr<void> execute(BuildContext context,
      {Map<String, dynamic>? arguments}) async {
    if (configurations == null) {
      return;
    }

    for (final config in configurations!) {
      if (config.isAwaited == true) {
        await config.execute(context, arguments: arguments);
      } else {
        config.execute(context, arguments: arguments);
      }
    }
  }

  /// Creates a new action with optional title and configurations.
  Action({this.title, this.configurations});

  /// Creates an action from a JSON object.
  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  /// Returns true if this action has no configurations.
  bool get isEmpty => configurations?.isEmpty ?? true;

  /// Returns true if this action has at least one configuration.
  bool get isNotEmpty => !isEmpty;
}

/// Base class for all action configurations.
/// 
/// Action configurations define the behavior of an action. Each type of
/// configuration implements this class and provides its own execution
/// logic.
/// 
/// Common configuration types include:
/// - Navigation (push, pop, replace)
/// - State management (update, reset)
/// - UI feedback (toast, dialog)
/// - Data operations (save, delete)
/// 
/// Example implementation:
/// ```dart
/// @JsonSerializable()
/// class ShowToastConfig extends ActionConfiguration {
///   static const schemaName = 'action.toast';
///   
///   final String message;
///   
///   ShowToastConfig({
///     required this.message,
///     super.title,
///     super.isAwaited,
///   }) : super(schemaType: schemaName);
///   
///   @override
///   Future<void> execute(BuildContext context, {
///     Map<String, dynamic>? arguments,
///   }) async {
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text(message)),
///     );
///   }
/// }
/// ```
abstract class ActionConfiguration implements SchemaItem {
  /// The schema type of this configuration.
  /// 
  /// Must match the type name defined in the CMS schema.
  @override
  final String schemaType;

  /// Optional title for this configuration.
  /// 
  /// Used for debugging and UI display purposes.
  final String? title;

  /// Whether to await this configuration's execution.
  /// 
  /// If true, the action will wait for this configuration to complete
  /// before executing the next one. Defaults to false.
  @JsonKey(defaultValue: false)
  final bool? isAwaited;

  /// Creates a new action configuration.
  ActionConfiguration({
    required this.schemaType,
    this.title,
    this.isAwaited,
  });

  /// Executes this configuration.
  /// 
  /// The [context] parameter provides access to the widget tree.
  /// The optional [arguments] map contains parameters for the execution.
  FutureOr<void> execute(BuildContext context, {
    Map<String, dynamic>? arguments,
  });
}
