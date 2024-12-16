/// Core library for Vyuh applications.

/// This library provides essential functionalities for building Vyuh apps,
/// including a way to organize features with [FeatureDescriptor] and leveraging the [Plugin] interface
/// for interacting with third-party integrations such as Authentication, Content Management,
/// Networking, Dependency Injection, Analytics, etc.

/// **Key Features:**

/// * **Plugin System:**  A flexible plugin architecture allows extending
///   Vyuh with custom features and integrations.  See [Plugin] for more details.
/// * **Modular Features:**  Organize features with [FeatureDescriptor] and build Apps in a composable manner.
/// Features are atomic, transferable between Vyuh Apps and provide a decentralized approach for building large scale Apps.
/// * **Platform Widgets:** Provides a mechanism to supply your own Widgets for loaders, error-views and other types of visual branding.
/// See [VyuhPlatform] and [PlatformWidgetBuilder].

/// **Getting Started:**

/// To use this library, import it into your Dart code:

/// ```dart
/// import 'package:vyuh_core/vyuh_core.dart';
/// ```

/// Then, you can initialize the features and plugins.

/// ```dart
///   runApp(
///     initialLocation: '/',
///     plugins: PluginDescriptor(
///       content: DefaultContentPlugin(
///         provider: SanityContentProvider.withConfig(
///           config: SanityConfig(
///             projectId: '<your-project-id>',
///             dataset: 'production',
///             perspective: Perspective.previewDrafts,
///             useCdn: false,
///             token: '<your-token>',
///           ),
///           cacheDuration: const Duration(seconds: 5),
///         ),
///       ),
///       env: vc.DefaultEnvPlugin(),
///       auth: MyCustomAuthPlugin(),
///       telemetry:
///           vc.TelemetryPlugin(providers: [vc.ConsoleLoggerTelemetryProvider()]),
///     ),
///     features: () => [
///       // Core Vyuh features that are necessary for all apps
///       system.feature,
///       developer.feature,
///
///       // Example Features
///       root.feature,
///       counter.feature,
///       onboarding.feature,
///       auth.feature(),
///     ],
///   );
/// ```

library;

export 'asserts.dart';
export 'extension.dart';
export 'feature_descriptor.dart';
export 'plugin/analytics/analytics_plugin.dart';
export 'plugin/analytics/analytics_provider.dart';
export 'plugin/analytics/noop_analytics_provider.dart';
export 'plugin/auth/auth_plugin.dart';
export 'plugin/auth/exceptions.dart';
export 'plugin/auth/user.dart';
export 'plugin/content/content_item.dart';
export 'plugin/content/content_plugin.dart';
export 'plugin/content/content_provider.dart';
export 'plugin/content/noop_content_plugin.dart';
export 'plugin/content/noop_content_provider.dart';
export 'plugin/content/reference.dart';
export 'plugin/content/route_base.dart';
export 'plugin/content/serialization.dart';
export 'plugin/content/type_descriptor.dart';
export 'plugin/content/unknown.dart';
export 'plugin/di/di_plugin.dart';
export 'plugin/di/plugin_di_get_it.dart';
export 'plugin/env/default_env_plugin.dart';
export 'plugin/env/env_plugin.dart';
export 'plugin/event_plugin.dart';
export 'plugin/feature_flag.dart';
export 'plugin/navigation/default_navigation_plugin.dart';
export 'plugin/navigation/navigation.dart';
export 'plugin/network/http_network_plugin.dart';
export 'plugin/network/network_plugin.dart';
export 'plugin/plugin.dart';
export 'plugin/plugin_descriptor.dart';
export 'plugin/telemetry/console_logger_telemetry_provider.dart';
export 'plugin/telemetry/logger.dart';
export 'plugin/telemetry/noop_telemetry_provider.dart';
export 'plugin/telemetry/telemetry_plugin.dart';
export 'plugin/telemetry/telemetry_provider.dart';
export 'runtime/cms_route.dart';
export 'runtime/init_tracker.dart';
export 'runtime/platform/default_platform_widget_builder.dart';
export 'runtime/platform/events.dart';
export 'runtime/platform/vyuh_platform.dart';
export 'runtime/platform_widget_builder.dart';
export 'runtime/run_app.dart';
