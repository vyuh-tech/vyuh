import 'package:vyuh_core/vyuh_core.dart';

/// Converts a JSON object to a nullable-instance of [SchemaItem] of type [T].
T? typeFromFirstOfListJson<T extends SchemaItem>(dynamic json) {
  final item = (json as List?)?.firstOrNull;
  if (item == null) {
    return null;
  }

  final typedItem = vyuh.content.fromJson<T>(item);
  assert(
      typedItem != null,
      _missingTypeRegistrationMessage<T>(
          vyuh.content.provider.schemaType(item)));

  return typedItem;
}

/// Converts a JSON list to a nullable-list of [SchemaItem] instances of type [T].
List<T>? listFromJson<T extends SchemaItem>(dynamic json) {
  if (json == null) {
    return null;
  }

  if (json is! List) {
    throw ArgumentError.value(json, 'json', 'is not a List');
  }

  return json.map((itemJson) {
    final item = vyuh.content.fromJson<T>(itemJson);
    assert(
        item != null,
        _missingTypeRegistrationMessage<T>(
            vyuh.content.provider.schemaType(itemJson)));

    return item!;
  }).toList(growable: false);
}

/// Reads a value from a JSON object using the provided key.
Object? readValue(dynamic json, String key) {
  return vyuh.content.provider.fieldValue(key, json);
}

_missingTypeRegistrationMessage<T>(String schemaType) {
  return '''
Could not convert JSON to $T. 
Please register a TypeDescriptor for schemaType: "$schemaType".''';
}
