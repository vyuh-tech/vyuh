abstract class FeatureExtensionDescriptor {
  final String title;

  FeatureExtensionDescriptor({
    required this.title,
  });
}

abstract class FeatureExtensionBuilder {
  final String title;
  final Type extensionType;

  FeatureExtensionBuilder({
    required this.extensionType,
    required this.title,
  });

  void build(List<FeatureExtensionDescriptor> extensions) {}

  void init() {}
  void dispose() {}
}
