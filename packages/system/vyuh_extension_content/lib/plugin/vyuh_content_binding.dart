import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

final class VyuhContentBinding {
  static void init({
    required ContentPlugin plugin,
    required List<ContentExtensionDescriptor> descriptors,
    PlatformWidgetBuilder? widgetBuilder,
    Future<void> Function(VyuhBinding)? onReady,
  }) {
    VyuhBinding.instance.widgetInit(
      plugins: PluginDescriptor(
        content: plugin,
      ),
      widgetBuilder: widgetBuilder,
      extensionBuilder: ContentExtensionBuilder(),
      extensionDescriptors: [
        ...descriptors,
        _standardExtensionDescriptor,
      ],
      onReady: onReady,
    );
  }

  static ContentPlugin get content => VyuhBinding.instance.content;
}

final _standardExtensionDescriptor = ContentExtensionDescriptor(
  contents: [
    Document.descriptor(),
  ],
  contentBuilders: [
    Document.contentBuilder,
  ],
);
