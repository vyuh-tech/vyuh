// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingContent _$OnboardingContentFromJson(Map<String, dynamic> json) =>
    OnboardingContent(
      doneAction: json['doneAction'] == null
          ? null
          : Action.fromJson(json['doneAction'] as Map<String, dynamic>),
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => OnboardingStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

OnboardingStep _$OnboardingStepFromJson(Map<String, dynamic> json) =>
    OnboardingStep(
      title: json['title'] as String? ?? '',
      description: json['description'] == null
          ? null
          : PortableTextContent.fromJson(
              json['description'] as Map<String, dynamic>),
      image: json['image'] == null
          ? null
          : ImageReference.fromJson(json['image'] as Map<String, dynamic>),
    );
