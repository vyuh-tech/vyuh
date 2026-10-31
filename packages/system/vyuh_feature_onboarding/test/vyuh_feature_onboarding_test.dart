import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_onboarding/vyuh_feature_onboarding.dart';

void main() {
  test('the feature contributes the onboarding content builder', () {
    expect(feature.routes, isNull, reason: 'onboarding adds content, not routes');
    final contributions =
        feature.extensions!.whereType<ContentExtensionDescriptor>().single;
    expect(
      contributions.contentBuilders!.single,
      isA<OnboardingContentBuilder>(),
    );
  });
}
