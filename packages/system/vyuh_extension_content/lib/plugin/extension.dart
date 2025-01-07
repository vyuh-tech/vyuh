import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

extension ServiceExtensions on ContentPlugin {
  /// Sets the default layout for the [schemaType] of the [ContentItem].
  /// Returns true if the layout was set, false otherwise.
  bool setDefaultLayout({
    required String schemaType,
    required LayoutConfiguration layout,
    required FromJsonConverter<LayoutConfiguration> fromJson,
  }) {
    final builder = contentBuilder(schemaType);

    if (builder == null) {
      return false;
    }

    builder.setDefaultLayout(layout, fromJson: fromJson);

    return true;
  }

  /// Returns the [ContentBuilder] for the [schemaType] of the [ContentItem].
  /// Returns null if it does not exist.
  ContentBuilder? contentBuilder(String schemaType) {
    return (vyuh.extensionBuilder<ContentExtensionDescriptor>()
            as ContentExtensionBuilder?)
        ?.contentBuilder(schemaType);
  }

  /// Returns a map of all content builders, where the key is the schemaType and
  /// the value is the ContentBuilder.
  List<ContentBuilder<ContentItem>>? contentBuilders() {
    return (vyuh.extensionBuilder<ContentExtensionDescriptor>()
            as ContentExtensionBuilder?)
        ?.contentBuilders();
  }
}
