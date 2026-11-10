import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_demo/root_feature.dart' as root;

void main() {
  test('the root feature runs its setup when the app is ready', () {
    expect(root.feature.events.single.eventType, SystemReadyEvent);
  });
}
