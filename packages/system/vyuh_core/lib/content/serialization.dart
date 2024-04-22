import 'package:flutter/foundation.dart';
import 'package:vyuh_core/vyuh_core.dart';

T? typeFromFirstOfListJson<T extends SchemaItem>(dynamic json) {
  final item = (json as List?)?.firstOrNull;
  if (item == null) {
    return null;
  }

  final typedItem = vyuh.content.fromJson<T>(item);
  assert(typedItem != null, '''
Could not convert JSON to $T. 
You have missed registering a TypeDescriptor for schemaType: "${vyuh.content.provider.schemaType(item)}".''');

  if (typedItem == null) {
    debugPrint(
        'Unknown schemaType: "${vyuh.content.provider.schemaType(item)}" of $T');
  }

  return typedItem;
}

List<T>? listFromJson<T extends SchemaItem>(dynamic json) {
  if (json == null) {
    return null;
  }

  if (json is! List) {
    throw ArgumentError.value(json, 'json', 'is not a List');
  }

  return json.map((e) {
    final item = vyuh.content.fromJson<T>(e);
    assert(item != null,
        'Could not convert JSON to $T. You have missed setting a de-serializer for schemaType: "${vyuh.content.provider.schemaType(e)}".');

    return item!;
  }).toList(growable: false);
}

Object? readValue(dynamic json, String key) {
  return vyuh.content.provider.fieldValue(key, json);
}
