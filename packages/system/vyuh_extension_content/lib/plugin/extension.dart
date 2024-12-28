import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

extension DefaultLayout on ContentPlugin {
  /// Returns the [ContentBuilder] for the [schemaType] of the [ContentItem].
  /// Returns null if it does not exist.
  bool setDefaultLayout({
    required String schemaType,
    required LayoutConfiguration layout,
    required FromJsonConverter<LayoutConfiguration> fromJson,
  }) {
    final extBuilder = vyuh.getExtensionBuilder<ContentExtensionDescriptor>()
        as ContentExtensionBuilder?;

    if (extBuilder == null) {
      return false;
    }

    final builder = extBuilder.getContentBuilder(schemaType);

    if (builder == null) {
      return false;
    }

    builder.setDefaultLayout(layout, fromJson: fromJson);

    return true;
  }
}
