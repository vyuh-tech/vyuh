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
    final theme = Theme.of(context);

    final pages = content.steps.map((step) {
      return PageViewModel(
        title: step.title,
        bodyWidget: step.description != null
            ? vyuh.content.buildContent(context, step.description!)
            : null,
        image: _buildImage(step, theme),
        decoration: const PageDecoration(
          pageMargin: EdgeInsets.all(0),
          titlePadding: EdgeInsets.symmetric(vertical: 16),
          bodyPadding: EdgeInsets.symmetric(horizontal: 16),
          imagePadding: EdgeInsets.only(bottom: 24),
          contentMargin: EdgeInsets.all(16),
        ),
      );
    }).toList();

    return IntroductionScreen(
      pages: pages,
      showSkipButton: true,
      skip: Text('Skip'),
      next: Text('Next'),
      done: Text('Done'),
      onDone: () {
        if (content.doneAction != null) {
          content.doneAction!.execute(context);
        }
      },
      onSkip: () {
        if (content.doneAction != null) {
          content.doneAction!.execute(context);
        }
      },
      dotsDecorator: DotsDecorator(
        size: const Size(8.0, 8.0),
        spacing: const EdgeInsets.symmetric(horizontal: 4.0),
        color: theme.colorScheme.primary.withValues(alpha: 0.25),
        activeSize: const Size(16.0, 8.0),
        activeColor: theme.colorScheme.primary,
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }

  Widget _buildImage(OnboardingStep step, ThemeData theme) {
    if (step.image != null) {
      return ContentImage(
        ref: step.image!,
        fit: BoxFit.cover,
      );
    }

    if (step.icon != null) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.1),
        ),
        child: Center(child: step.icon!),
      );
    }

    return const SizedBox.shrink();
  }
}
