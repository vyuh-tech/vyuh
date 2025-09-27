import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// Factory function that creates unknown placeholders for different schema item types.
/// This is registered with the serialization system to provide placeholders
/// when type registration fails.
///
/// In debug mode, this immediately triggers visual feedback when unknown types are encountered.
SchemaItem? createUnknownPlaceholder(
  Type type,
  String missingSchemaType,
  Map<String, dynamic> jsonPayload,
) {
  // Log the error for tracking
  VyuhBinding.instance.log.error(
    'Unknown type encountered during deserialization: $missingSchemaType (expected: $type). '
    'Register a TypeDescriptor for this schema type.',
  );

  if (type == ActionConfiguration) {
    return UnknownActionConfiguration(
      missingSchemaType: missingSchemaType,
      jsonPayload: jsonPayload,
    );
  }

  if (type == ConditionConfiguration) {
    return UnknownConditionConfiguration(
      missingSchemaType: missingSchemaType,
      jsonPayload: jsonPayload,
    );
  }

  if (type == ContentModifierConfiguration) {
    return UnknownContentModifierConfiguration(
      missingSchemaType: missingSchemaType,
      jsonPayload: jsonPayload,
    );
  }

  // For LayoutConfiguration, we need to handle generics
  // This is trickier because LayoutConfiguration is generic
  if (type.toString().startsWith('LayoutConfiguration')) {
    return UnknownLayoutConfiguration(
      missingSchemaType: missingSchemaType,
      jsonPayload: jsonPayload,
    );
  }

  // Unknown type, can't create placeholder
  return null;
}


/// Initializes the unknown placeholder factory for the serialization system.
/// This should be called during app initialization.
void initializeUnknownPlaceholderFactory() {
  setUnknownPlaceholderFactory(createUnknownPlaceholder);
}
