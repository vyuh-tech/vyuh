import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_onboarding/onboarding.dart';

final feature = FeatureDescriptor(
  name: 'vyuh_feature_onboarding',
  title: 'Vyuh Feature Onboarding',
  description: 'Onboarding screens when user first opens the app.',
  icon: Icons.checklist,
  extensions: [
    ContentExtensionDescriptor(
      contentBuilders: [OnboardingContentBuilder()],
    )
  ],
  routes: () => [],
);
