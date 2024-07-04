/// The base type for all extension descriptors.
/// An ExtensionDescriptor provides configurability for an extension.
abstract class ExtensionDescriptor {
  /// The title of the extension.
  final String title;

  /// Creates a new ExtensionDescriptor.
  ExtensionDescriptor({
    required this.title,
  });
}

/// The base type for all extension builders. An extension builder is responsible for building an extension,
/// by assembling all of the extension descriptors.
abstract class ExtensionBuilder {
  /// The title of the extension.
  final String title;

  /// The runtime Type of the extension.
  final Type extensionType;

  /// Creates a new ExtensionBuilder.
  ExtensionBuilder({
    required this.extensionType,
    required this.title,
  });

  /// Builds the extension.
  void build(List<ExtensionDescriptor> extensions) {}

  /// Initializes the extension.
  void init() {}

  /// Disposes the extension.
  void dispose() {}
}
