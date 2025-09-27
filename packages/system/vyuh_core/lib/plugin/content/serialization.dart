import 'package:flutter/foundation.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// Factory function for creating unknown placeholders for different types.
/// This is set by the extension_content package to provide unknown placeholders
/// for ActionConfiguration, ConditionConfiguration, etc.
typedef UnknownPlaceholderFactory = SchemaItem? Function(
  Type type,
  String missingSchemaType,
  Map<String, dynamic> jsonPayload,
);

/// Global factory for creating unknown placeholders.
/// Set this from extension_content package during initialization.
UnknownPlaceholderFactory? _unknownPlaceholderFactory;

/// Sets the factory for creating unknown placeholders.
void setUnknownPlaceholderFactory(UnknownPlaceholderFactory factory) {
  _unknownPlaceholderFactory = factory;
}

/// Converts a JSON object to a nullable-instance of [SchemaItem] of type [T].
///
/// This helper is used when deserializing a single item from a JSON array.
/// It takes the first item from the array and converts it to type [T].
///
/// Example:
/// ```dart
/// final json = [{'title': 'Post 1', '_type': 'blog.post'}];
/// final post = typeFromFirstOfListJson<BlogPost>(json);
/// ```
///
/// Returns null if:
/// - The input is null
/// - The input array is empty
/// - The type conversion fails
T? typeFromFirstOfListJson<T extends SchemaItem>(dynamic json) {
  final jsonItem = switch (json) {
    (Map<String, dynamic> item) => item,
    (List list) => list.firstOrNull,
    _ => null,
  };

  if (jsonItem == null) {
    return null;
  }

  final typedItem = VyuhBinding.instance.content.fromJson<T>(jsonItem);

  if (typedItem != null) {
    return typedItem;
  }

  // Create appropriate unknown placeholder based on type
  // This will be handled by the extension_content package
  final schemaType = VyuhBinding.instance.content.provider.schemaType(jsonItem);

  // For ContentItem, we already have UnknownContentItem
  if (T == ContentItem) {
    return UnknownContentItem(
      missingSchemaType: schemaType,
      jsonPayload: jsonItem,
    ) as T?;
  }

  // For other types, we need to use the factory method approach
  // Since we can't import extension_content types here, we use a callback system
  final unknownPlaceholder = _unknownPlaceholderFactory?.call(T, schemaType, jsonItem);

  if (unknownPlaceholder != null) {
    return unknownPlaceholder as T?;
  }

  // In debug mode, provide helpful error message
  if (kDebugMode) {
    print(_missingTypeRegistrationMessage<T>(schemaType));
  }

  return null;
}

/// Converts a JSON list to a nullable-list of [SchemaItem] instances of type [T].
///
/// This helper is used when deserializing an array of items from JSON.
/// Each item in the array is converted to type [T].
///
/// Example:
/// ```dart
/// final json = [
///   {'title': 'Post 1', '_type': 'blog.post'},
///   {'title': 'Post 2', '_type': 'blog.post'},
/// ];
/// final posts = listFromJson<BlogPost>(json);
/// ```
///
/// Returns null if the input is null.
/// Throws [ArgumentError] if the input is not a List.
List<T>? listFromJson<T extends SchemaItem>(dynamic json) {
  if (json == null) {
    return null;
  }

  if (json is! List) {
    throw ArgumentError.value(json, 'json', 'is not a List');
  }

  return json.map((itemJson) {
    final item = VyuhBinding.instance.content.fromJson<T>(itemJson);

    if (item != null) {
      return item;
    }

    // Create appropriate unknown placeholder based on type
    final schemaType = VyuhBinding.instance.content.provider.schemaType(itemJson);

    // For ContentItem, we already have UnknownContentItem
    if (T == ContentItem) {
      return UnknownContentItem(
        missingSchemaType: schemaType,
        jsonPayload: itemJson,
      ) as T;
    }

    // For other types, use the factory method approach
    final unknownPlaceholder = _unknownPlaceholderFactory?.call(T, schemaType, itemJson);

    if (unknownPlaceholder != null) {
      return unknownPlaceholder as T;
    }

    // In debug mode, provide helpful error message
    if (kDebugMode) {
      print(_missingTypeRegistrationMessage<T>(schemaType));
    }

    // If no placeholder could be created, we have to skip this item
    return null;
  }).where((item) => item != null).cast<T>().toList(growable: false);
}

/// Reads a value from a JSON object using the provided key.
///
/// This helper provides a consistent way to access values from JSON
/// objects across different content providers.
///
/// Example:
/// ```dart
/// final json = {'title': 'My Post'};
/// final title = readValue(json, 'title');
/// ```
///
/// Returns null if:
/// - The input is null
/// - The key does not exist
/// - The value is null
Object? readValue(dynamic json, String key) {
  return VyuhBinding.instance.content.provider.fieldValue(key, json);
}


/// Creates an error message for missing type registration.
///
/// Used internally to provide helpful error messages when type
/// conversion fails due to missing type descriptors.
String _missingTypeRegistrationMessage<T>(String schemaType) {
  return '''
Could not convert JSON to $T.
Please register a TypeDescriptor for schemaType: "$schemaType".''';
}
