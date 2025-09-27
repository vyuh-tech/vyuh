import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// Unknown placeholder types for handling missing type registrations gracefully.
/// These placeholders allow the system to continue working while providing
/// proper error feedback through the unknown content builder system.

/// Unknown action configuration placeholder.
///
/// Used when an ActionConfiguration type cannot be resolved during deserialization.
final class UnknownActionConfiguration extends ActionConfiguration {
  static const schemaName = 'vyuh.unknown.action';

  final String missingSchemaType;
  final Map<String, dynamic> jsonPayload;

  UnknownActionConfiguration({
    required this.missingSchemaType,
    required this.jsonPayload,
  }) : super(schemaType: schemaName);

  @override
  Future<void> execute(BuildContext context, {Map<String, dynamic>? arguments}) async {
    // No-op execution - the visual feedback is already shown during deserialization
    // This prevents the action from actually doing anything harmful
  }
}

/// Unknown condition configuration placeholder.
///
/// Used when a ConditionConfiguration type cannot be resolved during deserialization.
final class UnknownConditionConfiguration extends ConditionConfiguration {
  static const schemaName = 'vyuh.unknown.condition';

  final String missingSchemaType;
  final Map<String, dynamic> jsonPayload;

  UnknownConditionConfiguration({
    required this.missingSchemaType,
    required this.jsonPayload,
  }) : super(schemaType: schemaName);

  @override
  Future<String?> execute(BuildContext context) async {
    // Return error message that causes condition to fail
    // The visual feedback is already shown during deserialization
    return 'Missing condition: $missingSchemaType';
  }
}

/// Unknown layout configuration placeholder.
///
/// Used when a LayoutConfiguration type cannot be resolved during deserialization.
final class UnknownLayoutConfiguration<T extends ContentItem> extends LayoutConfiguration<T> {
  static const schemaName = 'vyuh.unknown.layout';

  final String missingSchemaType;
  final Map<String, dynamic> jsonPayload;

  UnknownLayoutConfiguration({
    required this.missingSchemaType,
    required this.jsonPayload,
  }) : super(schemaType: schemaName);

  @override
  Widget build(BuildContext context, T content) {
    final failure = LayoutFailure(
      schemaType: missingSchemaType,
      contentSchemaType: content.schemaType,
      jsonPayload: jsonPayload,
      description: 'Unknown layout configuration: $missingSchemaType',
      suggestions: [
        'Register a TypeDescriptor for $missingSchemaType',
        'Check if the layout type is properly exported',
      ],
    );

    return VyuhBinding.instance.widgetBuilder.unknown(context, failure);
  }
}

/// Unknown content modifier configuration placeholder.
///
/// Used when a ContentModifierConfiguration type cannot be resolved during deserialization.
final class UnknownContentModifierConfiguration extends ContentModifierConfiguration {
  static const schemaName = 'vyuh.unknown.modifier';

  final String missingSchemaType;
  final Map<String, dynamic> jsonPayload;

  UnknownContentModifierConfiguration({
    required this.missingSchemaType,
    required this.jsonPayload,
  }) : super(schemaType: schemaName);

  @override
  Widget build(BuildContext context, Widget child, ContentItem content) {
    final failure = ModifierFailure(
      schemaType: missingSchemaType,
      modifierChain: [missingSchemaType],
      failedIndex: 0,
      jsonPayload: jsonPayload,
      description: 'Unknown modifier configuration: $missingSchemaType',
      suggestions: [
        'Register a TypeDescriptor for $missingSchemaType',
        'Check if the modifier type is properly exported',
      ],
    );

    return VyuhBinding.instance.widgetBuilder.unknown(context, failure);
  }
}