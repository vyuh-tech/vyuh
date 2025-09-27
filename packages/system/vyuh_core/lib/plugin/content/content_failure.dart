/// Base class for content-related failures in the Vyuh framework.
///
/// This class hierarchy provides a unified way to handle missing or invalid
/// content registrations, layouts, modifiers, actions, and conditions.
/// Instead of scattered error handling, all content failures route through
/// the platform widget builder's unknown content handler.
abstract class ContentFailure {
  /// The schema type that failed to resolve
  final String schemaType;

  /// The original JSON payload that caused the failure (if available)
  final Map<String, dynamic>? jsonPayload;

  /// Human-readable description of the failure
  final String? description;

  /// Optional suggestions for resolving the failure
  final List<String>? suggestions;

  const ContentFailure({
    required this.schemaType,
    this.jsonPayload,
    this.description,
    this.suggestions,
  });
}

/// Failure when a ContentItem type registration is missing.
///
/// This occurs when JSON from the CMS contains a schema type that has no
/// registered TypeDescriptor in the content system.
///
/// Example:
/// ```dart
/// ContentItemFailure(
///   schemaType: 'blog.post',
///   jsonPayload: {'_type': 'blog.post', 'title': 'My Post'},
///   description: 'No TypeDescriptor registered for blog.post',
/// )
/// ```
final class ContentItemFailure extends ContentFailure {
  const ContentItemFailure({
    required super.schemaType,
    super.jsonPayload,
    super.description,
    super.suggestions,
  });
}

/// Failure when a layout for a registered content type is missing.
///
/// This occurs when a ContentItem has been successfully deserialized but
/// no layout configuration can be found to render it.
final class LayoutFailure extends ContentFailure {
  /// The content type that needs a layout
  final String contentSchemaType;

  /// The specific layout type that was requested (if any)
  final String? requestedLayoutType;

  const LayoutFailure({
    required super.schemaType,
    required this.contentSchemaType,
    this.requestedLayoutType,
    super.jsonPayload,
    super.description,
    super.suggestions,
  });
}

/// Failure when a content modifier registration is missing.
///
/// This occurs when applying a chain of modifiers to content and one
/// of the modifiers in the chain cannot be resolved.
final class ModifierFailure extends ContentFailure {
  /// The complete chain of modifiers being applied
  final List<String> modifierChain;

  /// The index in the modifier chain where the failure occurred
  final int failedIndex;

  const ModifierFailure({
    required super.schemaType,
    required this.modifierChain,
    required this.failedIndex,
    super.jsonPayload,
    super.description,
    super.suggestions,
  });
}

/// Failure when an action configuration registration is missing.
///
/// This occurs when content references an action that has no registered
/// TypeDescriptor in the action system.
final class ActionFailure extends ContentFailure {
  /// The action configuration that failed to resolve
  final Map<String, dynamic>? actionConfig;

  const ActionFailure({
    required super.schemaType,
    this.actionConfig,
    super.jsonPayload,
    super.description,
    super.suggestions,
  });
}

/// Failure when a condition configuration registration is missing.
///
/// This occurs when content references a condition that has no registered
/// TypeDescriptor in the condition system.
final class ConditionFailure extends ContentFailure {
  /// The condition configuration that failed to resolve
  final Map<String, dynamic>? conditionConfig;

  const ConditionFailure({
    required super.schemaType,
    this.conditionConfig,
    super.jsonPayload,
    super.description,
    super.suggestions,
  });
}