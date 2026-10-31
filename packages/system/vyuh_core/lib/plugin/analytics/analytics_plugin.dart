import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';

/// The default implementation of analytics tracking in Vyuh applications.
///
/// The analytics plugin provides a unified interface for tracking user
/// behavior and application events. It supports:
/// - Multiple analytics providers (e.g., Firebase, Mixpanel)
/// - Automatic navigation tracking
/// - User identification and traits
/// - Custom event tracking with parameters
///
/// The plugin manages multiple providers simultaneously, allowing you to
/// send analytics data to multiple services. Each provider can have its
/// own configuration and implementation.
///
/// Example providers:
/// - Firebase Analytics
/// - Google Analytics
/// - Mixpanel
/// - Custom analytics services
final class AnalyticsPlugin extends Plugin
    with PreloadedPlugin, InitOncePlugin, RouteObservers
    implements AnalyticsProvider {
  /// The list of analytics providers managed by this plugin.
  ///
  /// Each provider will receive all analytics events and can process
  /// them according to its own implementation.
  final List<AnalyticsProvider> providers;

  @override
  String get description => 'Analytics Plugin';

  /// Navigation observers for automatic route tracking.
  ///
  /// These observers are automatically added to the Navigator to track
  /// screen views and navigation events.
  @override
  List<NavigatorObserver> get observers =>
      providers.expand((provider) => provider.observers).toList();

  /// Creates a new AnalyticsPlugin with the given providers.
  ///
  /// Example:
  /// ```dart
  /// final analytics = AnalyticsPlugin(
  ///   providers: [
  ///     FirebaseAnalyticsProvider(),
  ///     MixpanelProvider(),
  ///   ],
  /// );
  /// ```
  AnalyticsPlugin({required this.providers})
      : super(
          name: 'vyuh.plugin.analytics',
          title: 'Analytics Plugin',
        );

  /// Initializes all analytics providers.
  ///
  /// This is called automatically when the plugin is initialized.
  /// A provider that fails to initialize is logged and skipped.
  @override
  Future<void> initOnce() => _fanOut((provider) => provider.init());

  /// Disposes all analytics providers.
  ///
  /// This is called automatically when the plugin is disposed.
  /// Each provider's cleanup is handled independently.
  @override
  Future<void> disposeOnce() => _fanOut((provider) => provider.dispose());

  /// Reports an analytics event to all providers.
  ///
  /// The [name] parameter is the event identifier, and [params] contains
  /// any additional data to track with the event.
  ///
  /// Example:
  /// ```dart
  /// await analytics.reportEvent(
  ///   'button_clicked',
  ///   params: {'button_id': 'submit', 'screen': 'login'},
  /// );
  /// ```
  @override
  Future<void> reportEvent(String name, {Map<String, dynamic>? params}) =>
      _fanOut((provider) => provider.reportEvent(name, params: params));

  /// Identifies a user across all analytics providers.
  ///
  /// The [userId] parameter is a unique identifier for the user, and
  /// [traits] contains any additional user properties to track.
  ///
  /// Example:
  /// ```dart
  /// await analytics.identifyUser(
  ///   'user123',
  ///   traits: {'plan': 'premium', 'company': 'Acme Inc'},
  /// );
  /// ```
  @override
  Future<void> identifyUser(String userId, {Map<String, dynamic>? traits}) =>
      _fanOut((provider) => provider.identifyUser(userId, traits: traits));

  /// Resets the user identity across all analytics providers.
  ///
  /// This is typically called when the user logs out or is no longer
  /// identifiable.
  @override
  Future<void> resetUser() => _fanOut((provider) => provider.resetUser());

  /// Calls every provider. A provider that fails, synchronously or
  /// asynchronously, is logged and skipped: analytics must never crash the
  /// app, and one broken provider must not stop the others.
  Future<void> _fanOut(Future<void> Function(AnalyticsProvider) call) {
    return Future.wait(providers.map((provider) {
      return Future.sync(() => call(provider)).catchError(
        (Object error, StackTrace stack) => debugPrint(
          'Vyuh: analytics provider ${provider.runtimeType} failed: $error',
        ),
      );
    }));
  }
}
