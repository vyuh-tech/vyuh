import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// The binding layer for the [VyuhContentWidget]. It provides access to various plugins, including the content plugin.
/// You can also customize the default widget builders for showing loaders and errors.
final class VyuhContentBinding {
  /// Initializes the binding layer for the [VyuhContentWidget]. This is a required call before using the widget.
  /// It takes in a [PluginDescriptor] and optional parameters for customizing the widget builders.
  /// The descriptors are used for extending the default content types and content builders.
  /// You can also be notified once the binding layer is completely ready by providing an [onReady] callback.
  static void init({
    required PluginDescriptor plugins,
    List<ContentExtensionDescriptor>? descriptors,
    PlatformWidgetBuilder? widgetBuilder,
    Future<void> Function(VyuhBinding)? onReady,
  }) {
    VyuhBinding.instance.widgetInit(
      plugins: plugins,
      widgetBuilder: widgetBuilder,
      extensionBuilder: ContentExtensionBuilder(),
      extensionDescriptors: standardDescriptors + (descriptors ?? []),
      onReady: onReady,
    );
  }

  /// The default content plugin used by the [VyuhContentWidget].
  static ContentPlugin get content => VyuhBinding.instance.content;

  /// The default widget builder used by the [VyuhContentWidget].
  static PlatformWidgetBuilder get widgetBuilder =>
      VyuhBinding.instance.widgetBuilder;

  /// The default descriptors used by the [VyuhContentWidget]. It includes the Document type and several
  /// content-types from the vyuh_feature_system package.
  static final standardDescriptors = [
    ContentExtensionDescriptor(
      contents: [
        Document.descriptor(),
      ],
      contentBuilders: [
        Document.contentBuilder,
      ],
    )
  ];

  static Future<void> dispose() {
    return VyuhBinding.instance.dispose();
  }
}
