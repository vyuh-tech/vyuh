import 'package:vyuh_core/vyuh_core.dart';

enum UserEventType {
  tap,
  longTap,
  swipe,
  view,
}

extension UserEvents on AnalyticsPlugin {
  void reportUserEvent(UserEventType eventType, {ContentItem? content}) {}
}
