import 'package:vyuh_core/vyuh_core.dart';

abstract class ContentDescriptor {
  final String title;
  final String schemaType;
  final List<TypeDescriptor<LayoutConfiguration>>? layouts;
  final List<TypeDescriptor<ExtensionConfiguration>>? extensions;

  ContentDescriptor({
    required this.schemaType,
    required this.title,
    this.layouts,
    this.extensions,
  });
}
