import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

final _noOpContentPlugin = NoOpContentPlugin();

/// `vyuh.content`: the registered [ContentPlugin].
///
/// Register one with `PluginDescriptor(others: [DefaultContentPlugin(...)])`.
/// Without one, a [NoOpContentPlugin] answers, showing an error view that
/// explains how to configure content.
extension ContentPlatformAccessor on VyuhPlatform {
  /// The content plugin, or a [NoOpContentPlugin] when none is registered.
  ContentPlugin get content => getPlugin<ContentPlugin>() ?? _noOpContentPlugin;
}

/// `VyuhBinding.instance.content`: the same as `vyuh.content`, for code that
/// also runs in widget mode (`VyuhContentWidget`, without `runApp`).
extension ContentBindingAccessor on VyuhBinding {
  /// The content plugin, or a [NoOpContentPlugin] when none is registered.
  ContentPlugin get content => get<ContentPlugin>() ?? _noOpContentPlugin;
}
