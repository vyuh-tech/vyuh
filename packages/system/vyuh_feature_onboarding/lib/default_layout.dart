import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_onboarding/onboarding.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'default_layout.g.dart';

@JsonSerializable()
final class DefaultOnboardingLayout
    extends LayoutConfiguration<OnboardingContent> {
  static const schemaName = '${OnboardingContent.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: DefaultOnboardingLayout.fromJson,
    title: 'Default Onboarding Layout',
  );

  DefaultOnboardingLayout() : super(schemaType: schemaName);

  factory DefaultOnboardingLayout.fromJson(Map<String, dynamic> json) =>
      _$DefaultOnboardingLayoutFromJson(json);

  @override
  Widget build(BuildContext context, OnboardingContent content) {
    final pages = content.steps.map((step) {
      return PageViewModel(
          title: step.title,
          body: step.description == null ? '' : null,
          bodyWidget: step.description != null
              ? vyuh.content.buildContent(context, step.description!)
              : null,
          image: step.image != null
              ? ContentImage(
                  ref: step.image!,
                  fit: BoxFit.cover,
                )
              : null,
          decoration: const PageDecoration(
            pageMargin: EdgeInsets.all(0),
            titlePadding: EdgeInsets.symmetric(vertical: 8),
            imagePadding: EdgeInsets.only(bottom: 8),
            contentMargin: EdgeInsets.all(8),
          ));
    }).toList();

    return LimitedBox(
      maxHeight: 400,
      child: IntroductionScreen(
        pages: pages,
        onDone: () => content.doneAction?.execute(context),
        onSkip: () => content.doneAction?.execute(context),
        next: const Icon(Icons.navigate_next),
        done: const Text('Done'),
        skip: const Text('Skip'),
        showNextButton: true,
        showSkipButton: true,
      ),
    );
  }
}
