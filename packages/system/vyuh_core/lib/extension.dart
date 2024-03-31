abstract base class ExtensionDescriptor {
  final String title;

  ExtensionDescriptor({
    required this.title,
  });
}

abstract base class ExtensionBuilder {
  final String title;
  final Type extensionType;

  ExtensionBuilder({
    required this.extensionType,
    required this.title,
  });

  void build(List<ExtensionDescriptor> extensions) {}

  void init() {}
  void dispose() {}
}
