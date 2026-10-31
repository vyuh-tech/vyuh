---
title: vyuh_feature_onboarding API
description: Public declarations and contracts for vyuh_feature_onboarding.
outline: 2
---

# vyuh_feature_onboarding

The onboarding feature supplies a content type, step data, and a default layout. It composes text, imagery, and actions using the normal content extension pipeline.

```mermaid
flowchart LR
  Steps["Typed onboarding steps"] --> Feature["Onboarding content builder"]
  Feature --> Layout["Default layout"]
  Layout --> Actions["Configured step actions"]
```

[Package source](https://github.com/vyuh-tech/vyuh/tree/main/packages/system/vyuh_feature_onboarding) · [Released API](https://pub.dev/documentation/vyuh_feature_onboarding/latest/)

## Choose a declaration

[DefaultOnboardingLayout](#defaultonboardinglayout) · [OnboardingContent](#onboardingcontent) · [OnboardingContentBuilder](#onboardingcontentbuilder) · [OnboardingDescriptor](#onboardingdescriptor) · [OnboardingStep](#onboardingstep) · [feature](#feature)

## DefaultOnboardingLayout {#defaultonboardinglayout}

[Source](https://github.com/vyuh-tech/vyuh/blob/main/packages/system/vyuh_feature_onboarding/lib/default_layout.dart#L10)

Public declaration in this package.

```dart
final class DefaultOnboardingLayout extends LayoutConfiguration<OnboardingContent>
```

Directly declared public members:

```dart
static const dynamic schemaName;
```



```dart
static final dynamic typeDescriptor;
```



```dart
DefaultOnboardingLayout();
```



```dart
factory DefaultOnboardingLayout.fromJson(Map<String, dynamic> json);
```



```dart
Widget build(BuildContext context, OnboardingContent content);
```



## OnboardingContent {#onboardingcontent}

[Source](https://github.com/vyuh-tech/vyuh/blob/main/packages/system/vyuh_feature_onboarding/lib/onboarding.dart#L23)

Public declaration in this package.

```dart
final class OnboardingContent extends ContentItem
```

Directly declared public members:

```dart
static const dynamic schemaName;
```



```dart
static final dynamic typeDescriptor;
```



```dart
final Action? doneAction;
```



```dart
final List<OnboardingStep> steps;
```



```dart
OnboardingContent({this.doneAction, this.steps = const [], super.layout, super.modifiers});
```



```dart
factory OnboardingContent.fromJson(Map<String, dynamic> json);
```



## OnboardingContentBuilder {#onboardingcontentbuilder}

[Source](https://github.com/vyuh-tech/vyuh/blob/main/packages/system/vyuh_feature_onboarding/lib/onboarding.dart#L14)

Public declaration in this package.

```dart
final class OnboardingContentBuilder extends ContentBuilder<OnboardingContent>
```

Directly declared public members:

```dart
OnboardingContentBuilder();
```



## OnboardingDescriptor {#onboardingdescriptor}

[Source](https://github.com/vyuh-tech/vyuh/blob/main/packages/system/vyuh_feature_onboarding/lib/onboarding.dart#L9)

Public declaration in this package.

```dart
final class OnboardingDescriptor extends ContentDescriptor
```

Directly declared public members:

```dart
OnboardingDescriptor({super.layouts});
```



## OnboardingStep {#onboardingstep}

[Source](https://github.com/vyuh-tech/vyuh/blob/main/packages/system/vyuh_feature_onboarding/lib/onboarding.dart#L47)

Public declaration in this package.

```dart
final class OnboardingStep
```

Directly declared public members:

```dart
final String title;
```



```dart
final PortableTextContent? description;
```



```dart
final Widget? icon;
```



```dart
final ImageReference? image;
```



```dart
OnboardingStep({this.title = '', this.description, this.icon, this.image});
```



```dart
factory OnboardingStep.fromJson(Map<String, dynamic> json);
```



## feature {#feature}

[Source](https://github.com/vyuh-tech/vyuh/blob/main/packages/system/vyuh_feature_onboarding/lib/feature.dart#L6)

Public declaration in this package.

```dart
final feature = FeatureDescriptor( name: 'vyuh_feature_onboarding', title: 'Vyuh Feature Onboarding', description: 'Onboarding screens when user first opens the app.', icon: Icons.checklist, extensions: [ ContentExtensionDescriptor(contentBuilders: [OnboardingContentBuilder()]), ], );
```
