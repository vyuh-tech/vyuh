import 'package:vyuh_core/vyuh_core.dart';

final class FeatureItem {
  final String title;
  final FeatureDescriptor? feature;

  const FeatureItem({
    required this.title,
    this.feature,
  });
}
