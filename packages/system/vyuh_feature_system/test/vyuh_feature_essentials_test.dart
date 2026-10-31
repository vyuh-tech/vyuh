import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

void main() {
  test('the system feature contributes the built-in content', () {
    expect(feature.name, 'system');
    expect(
      feature.extensions!.whereType<ContentExtensionDescriptor>(),
      isNotEmpty,
    );
  });
}
