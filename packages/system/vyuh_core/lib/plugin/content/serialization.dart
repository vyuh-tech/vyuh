import 'package:vyuh_core/vyuh_core.dart';

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
  assert(
      typedItem != null,
      _missingTypeRegistrationMessage<T>(
          VyuhBinding.instance.content.provider.schemaType(jsonItem)));

  return typedItem;
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
    assert(
        item != null,
        _missingTypeRegistrationMessage<T>(
            VyuhBinding.instance.content.provider.schemaType(itemJson)));

    return item!;
  }).toList(growable: false);
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
