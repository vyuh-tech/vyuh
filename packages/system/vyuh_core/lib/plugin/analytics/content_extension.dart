import 'package:vyuh_core/vyuh_core.dart';

/// The type of the user event invoked on the content item.
enum UserEventType {
  /// The user tapped on the content item.
  tap,

  /// The user long tapped on the content item.
  longTap,

  /// The user swiped on the content item.
  swipe,

  /// The user viewed the content item.
  view,
}

/// An extension for easier reporting of user events.
extension UserEvents on AnalyticsPlugin {
  /// Reports a user event on the content item.
  void reportUserEvent(UserEventType eventType, {ContentItem? content}) {}
}
