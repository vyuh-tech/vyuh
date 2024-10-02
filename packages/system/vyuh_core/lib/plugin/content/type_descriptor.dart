typedef FromJsonConverter<T> = T? Function(Map<String, dynamic> json);

class TypeDescriptor<T> {
  final String title;
  final String schemaType;
  final FromJsonConverter<T> fromJson;

  TypeDescriptor({
    required this.schemaType,
    required this.fromJson,
    required this.title,
  });
}
