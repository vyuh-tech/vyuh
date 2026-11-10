/// Function type for converting JSON data to a typed object.
///
/// Takes a JSON map as input and returns a nullable instance of type [T].
/// This is typically implemented using generated fromJson methods from
/// json_serializable.
///
/// Example:
/// ```dart
/// final converter = BlogPost.fromJson;
/// final post = converter({'title': 'Hello', 'content': 'World'});
/// ```
typedef FromJsonConverter<T> = T? Function(Map<String, dynamic> json);

/// Describes a schema type and its serialization behavior.
///
/// Type descriptors are used by the content system to:
/// - Register content types with their schema names
/// - Convert JSON data to typed objects
/// - Provide metadata about content types
/// - Generate preview instances for design tools
///
/// Each content type should have a corresponding TypeDescriptor that
/// defines how to create instances from JSON data.
///
/// Example:
/// ```dart
/// static final typeDescriptor = TypeDescriptor(
///   schemaType: 'blog.post',
///   fromJson: BlogPost.fromJson,
///   title: 'Blog Post',
///   preview: () => BlogPost(
///     title: 'Preview Post',
///     content: 'This is a preview',
///   ),
/// );
/// ```
class TypeDescriptor<T> {
  /// Human-readable name for this type.
  ///
  /// Used in UI components and error messages.
  final String title;

  /// Schema type identifier from the CMS.
  ///
  /// Must match the type name defined in the CMS schema.
  /// For example: 'blog.post', 'product.detail'
  final String schemaType;

  /// Function to convert JSON data to an instance of [T].
  ///
  /// This is typically the generated fromJson method from
  /// json_serializable.
  final FromJsonConverter<T> fromJson;

  /// Optional function to create a preview instance.
  ///
  /// Used by design tools to show sample content without
  /// fetching from the CMS.
  final T Function()? preview;

  /// The runtime type of [T].
  final Type type;

  /// The feature that registered this type descriptor.
  ///
  /// Set automatically by the content system when the
  /// type is registered.
  String? _sourceFeature;
  String? get sourceFeature => _sourceFeature;

  /// Updates the source feature for this type descriptor.
  ///
  /// This is called internally by the content system and
  /// should not be called directly.
  void setSourceFeature(String? featureName) {
    _sourceFeature = featureName;
  }

  /// Creates a new type descriptor.
  ///
  /// - [schemaType]: The CMS schema type name
  /// - [fromJson]: Function to convert JSON to [T]
  /// - [title]: Human-readable name
  /// - [preview]: Optional preview instance generator
  TypeDescriptor({
    required this.schemaType,
    required this.fromJson,
    required this.title,
    this.preview,
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
