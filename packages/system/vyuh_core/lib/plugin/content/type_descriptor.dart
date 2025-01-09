typedef FromJsonConverter<T> = T? Function(Map<String, dynamic> json);

class TypeDescriptor<T> {
  final String title;
  final String schemaType;
  final FromJsonConverter<T> fromJson;

  final Type type;

  String? _sourceFeature;
  String? get sourceFeature => _sourceFeature;

  setSourceFeature(String? featureName) {
    _sourceFeature = featureName;
  }

  TypeDescriptor({
    required this.schemaType,
    required this.fromJson,
    required this.title,
  }) : type = T;

  @override
  bool operator ==(Object other) {
    if (other is! TypeDescriptor<T>) {
      return false;
    }

    if (other.schemaType != schemaType) {
      return false;
    }

    if (other.fromJson != fromJson) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode => Object.hash(schemaType, fromJson);
}
