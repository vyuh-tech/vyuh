import 'dart:async';

/// The base interface for an Analytics Provider. The provider is responsible for
/// reporting analytics events, errors, and messages.
abstract interface class AnalyticsProvider {
  /// The name of the provider.
  String get name;

  /// The title of the provider.
  String get title;

  /// The description of the provider.
  String get description;

  /// Initializes the provider.
  Future<void> init();

  /// Disposes the provider.
  Future<void> dispose();

  /// Reports an event with a specific name and optional parameters.
  Future<void> reportEvent(String name, {Map<String, dynamic>? params});
}
