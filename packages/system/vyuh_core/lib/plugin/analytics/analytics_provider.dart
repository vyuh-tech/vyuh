import 'dart:async';

import 'package:flutter/widgets.dart';

/// The base interface for an Analytics Provider. The provider is responsible for
/// reporting analytics events, errors, and messages.
abstract interface class AnalyticsProvider {
  /// The list of observers for the provider.
  /// These are added to the navigator, as part of the router setup.
  List<NavigatorObserver> get observers;

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

  /// Identifies a user with the given ID and optional traits.
  /// The traits can include any user properties like email, name, etc.
  Future<void> identifyUser(String userId, {Map<String, dynamic>? traits});

  /// Clears the current user identification and associated traits.
  /// This should be called when the user logs out.
  Future<void> resetUser();
}
