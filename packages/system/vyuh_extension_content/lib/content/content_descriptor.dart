import 'package:vyuh_core/vyuh_core.dart';

typedef ContentDescriptorFactory<T extends ContentItem> = ContentDescriptor
    Function({List<TypeDescriptor<LayoutConfiguration<T>>>? layouts});

abstract class ContentDescriptor {
  final String title;
  final String schemaType;
  final List<TypeDescriptor<LayoutConfiguration>>? layouts;

  String? _sourceFeature;

  /// The feature that this content descriptor was registered by.
  String? get sourceFeature => _sourceFeature;

  ContentDescriptor({
    required this.schemaType,
    required this.title,
    required this.layouts,
  });

  /// A simplified approach to creating a [ContentDescriptor] that follows the standard conventions.
  /// This eliminates the need to create a new `<Item>ContentDescriptor`.
  ///
  /// [schemaType] is ContentItem's schemaType.
  /// [title] of the descriptor.
  ///
  /// Returns a function that takes in a list of [TypeDescriptor]<[LayoutConfiguration]>. This is the function
  /// that will be used by consuming features to pass in new layouts for the [ContentItem].
  static ContentDescriptorFactory createDefault(
      {required String schemaType, required String title}) {
    return ({List<TypeDescriptor<LayoutConfiguration>>? layouts}) =>
        _DefaultContentDescriptor(
          schemaType: schemaType,
          title: title,
          layouts: layouts,
        );
  }

  void setSourceFeature(String? featureName) {
    _sourceFeature = featureName;

    for (final layout in layouts ?? <TypeDescriptor<LayoutConfiguration>>[]) {
      layout.setSourceFeature(featureName);
    }
  }
}

final class _DefaultContentDescriptor extends ContentDescriptor {
  _DefaultContentDescriptor({
    required super.schemaType,
    required super.title,
    super.layouts,
  });
}
