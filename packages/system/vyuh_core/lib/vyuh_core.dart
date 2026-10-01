/// Composition and lifecycle contracts for modular Flutter applications.
///
/// A [FeatureDescriptor] declares a product capability with routes, lifecycle
/// hooks, dependencies, and extension contributions. [PluginDescriptor] selects
/// the shared capabilities that features consume. The app owns their composition.
///
/// Start with an ordinary Flutter screen:
///
/// ```dart
/// import 'package:material_ui/material_ui.dart';
/// import 'package:go_router/go_router.dart';
/// import 'package:vyuh_core/vyuh_core.dart' as vc;
///
/// void main() {
///   vc.runApp(
///     initialLocation: '/',
///     platformWidgetBuilder: vc.PlatformWidgetBuilder.system.copyWith(
///       appBuilder: (_, platform) => MaterialApp.router(
///         routerConfig: platform.router.instance,
///       ),
///     ),
///     features: () => [
///       vc.FeatureDescriptor(
///         name: 'hello',
///         title: 'Hello',
///         routes: () => [
///           GoRoute(
///             path: '/',
///             builder: (_, _) => const Scaffold(body: Text('Hello, Vyuh.')),
///           ),
///         ],
///       ),
///     ],
///   );
/// }
/// ```
///
/// Add feature descriptors to compose a larger app. Use plugin contracts for
/// shared services such as networking, storage, authentication, and telemetry.
/// Custom capabilities belong in [PluginDescriptor.others] and are retrieved
/// from the initialized platform through [VyuhPlatform.getPlugin].
///
/// Feature packages own their behavior; apps select the implementations and
/// configuration they need. See [VyuhPlatform] and [PlatformWidgetBuilder] for
/// runtime access and app-wide loading, error, and branding widgets.
library;

export 'asserts.dart';
export 'extension.dart';
export 'feature_descriptor.dart';
export 'lazy_feature_descriptor.dart';
export 'plugin/analytics/analytics_plugin.dart';
export 'plugin/analytics/analytics_provider.dart';
export 'plugin/analytics/noop_analytics_provider.dart';
export 'plugin/auth/auth_plugin.dart';
export 'plugin/auth/exceptions.dart';
export 'plugin/auth/user.dart';
export 'plugin/content/content_failure.dart';
export 'plugin/content/content_item.dart';
export 'plugin/content/content_plugin.dart';
export 'plugin/content/content_provider.dart';
export 'plugin/content/live_content_provider.dart';
export 'plugin/content/local_content_provider.dart';
export 'plugin/content/noop_content_plugin.dart';
export 'plugin/content/noop_content_provider.dart';
export 'plugin/content/reference.dart';
export 'plugin/content/route_base.dart';
export 'plugin/content/serialization.dart';
export 'plugin/content/type_descriptor.dart';
export 'plugin/di/di_plugin.dart';
export 'plugin/di/plugin_di_get_it.dart';
export 'plugin/env/default_env_plugin.dart';
export 'plugin/env/env_plugin.dart';
export 'plugin/event_plugin.dart';
export 'plugin/feature_flag.dart';
export 'plugin/i18n/i18n.dart';
export 'plugin/navigation/default_navigation_plugin.dart';
export 'plugin/navigation/navigation.dart';
export 'plugin/network/http_network_plugin.dart';
export 'plugin/network/network_plugin.dart';
export 'plugin/plugin.dart';
export 'plugin/plugin_descriptor.dart';
export 'plugin/storage/storage_plugin.dart';
export 'plugin/telemetry/logger.dart';
export 'plugin/telemetry/noop_telemetry_provider.dart';
export 'plugin/telemetry/telemetry_plugin.dart';
export 'plugin/telemetry/telemetry_provider.dart';
export 'runtime/cms_route.dart';
export 'runtime/init_tracker.dart';
export 'runtime/platform/events.dart';
export 'runtime/platform/vyuh_platform.dart';
export 'runtime/platform_widget_builder.dart';
export 'runtime/run_app.dart';
