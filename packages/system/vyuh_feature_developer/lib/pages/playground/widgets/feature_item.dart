import 'package:vyuh_core/vyuh_core.dart';

/// A data class to represent a feature item.
///
final class FeatureItem {
  /// The title of the feature item.
  ///
  final String title;

  /// The feature descriptor of the feature item.
  ///
  final FeatureDescriptor? feature;

  /// Creates a new feature item.
  ///
  const FeatureItem({
    required this.title,
    this.feature,
  });
}
