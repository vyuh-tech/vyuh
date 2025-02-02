import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

final class VyuhContentBinding {
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
      extensionDescriptors: descriptors ?? standardDescriptors,
      onReady: onReady,
    );
  }

  static ContentPlugin get content => VyuhBinding.instance.content;

  static PlatformWidgetBuilder get widgetBuilder =>
      VyuhBinding.instance.widgetBuilder;

  static final standardDescriptors = [
    system.extensionDescriptor,
    ContentExtensionDescriptor(
      contents: [
        Document.descriptor(),
      ],
      contentBuilders: [
        Document.contentBuilder,
      ],
    )
  ];
}
