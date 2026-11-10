/// The CMS add-on for Vyuh: content items, layouts, the content plugin and
/// provider contracts, CMS routes and the builders that render them.
///
/// Register a content plugin with `PluginDescriptor(others: [DefaultContentPlugin(...)])`
/// and reach it through `vyuh.content`.
library;

export 'contracts/content_failure.dart';
export 'contracts/content_item.dart';
export 'contracts/content_plugin.dart';
export 'contracts/content_provider.dart';
export 'contracts/live_content_provider.dart';
export 'contracts/local_content_provider.dart';
export 'contracts/noop_content_plugin.dart';
export 'contracts/noop_content_provider.dart';
export 'contracts/reference.dart';
export 'contracts/route_base.dart';
export 'contracts/serialization.dart';
export 'contracts/type_descriptor.dart';
export 'plugin/accessors.dart';
export 'routing/cms_fallback_route.dart';
export 'routing/cms_route.dart';
export 'ui/unknown_content_view.dart';

export 'content/action.dart';
export 'content/condition.dart';
export 'content/content_builder.dart';
export 'content/content_descriptor.dart';
export 'content_extension_builder.dart';
export 'content_extension_descriptor.dart';
export 'plugin/content_plugin.dart';
export 'plugin/extension.dart';
export 'preview/preview_context.dart';
export 'ui/route_builder_proxy.dart';
export 'ui/route_builder.dart';
export 'ui/scoped_di_widget.dart';
export 'ui/document_builder.dart';
export 'ui/document_future_builder.dart';
export 'ui/document_stream_builder.dart';
export 'ui/unknown_content_indicator.dart';
export 'plugin/unknown_placeholders.dart';
export 'plugin/unknown_placeholder_factory.dart';
