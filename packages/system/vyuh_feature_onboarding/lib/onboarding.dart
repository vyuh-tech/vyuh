import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_onboarding/default_layout.dart';
import 'package:vyuh_feature_system/content/index.dart';

part 'onboarding.g.dart';

final class OnboardingDescriptor extends ContentDescriptor {
  OnboardingDescriptor({super.layouts})
      : super(
          schemaType: OnboardingContent.schemaName,
          title: 'Onboarding',
        );
}

final class OnboardingContentBuilder extends ContentBuilder<OnboardingContent> {
  OnboardingContentBuilder()
      : super(
          content: OnboardingContent.typeDescriptor,
          defaultLayout: DefaultOnboardingLayout(),
          defaultLayoutDescriptor: DefaultOnboardingLayout.typeDescriptor,
        );
}

@JsonSerializable()
final class OnboardingContent extends ContentItem {
  static const schemaName = 'vyuh.content.onboarding';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: OnboardingContent.fromJson,
    title: 'Onboarding',
  );

  final Action? doneAction;
  final List<OnboardingStep> steps;

  OnboardingContent({
    this.doneAction,
    this.steps = const [],
    super.layout,
  }) : super(schemaType: schemaName);

  factory OnboardingContent.fromJson(Map<String, dynamic> json) =>
      _$OnboardingContentFromJson(json);
}

@JsonSerializable()
final class OnboardingStep {
  final String title;
  final PortableTextContent? description;
  final ImageReference? image;

  OnboardingStep({
    this.title = '',
    this.description,
    this.image,
  });

  factory OnboardingStep.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStepFromJson(json);
}
