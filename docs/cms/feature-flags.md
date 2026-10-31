---
title: Feature Flags
description: Control feature visibility and behavior with feature flags
---

# Feature Flags

Feature flags allow you to control the visibility and behavior of features in
your application at runtime, without deploying new code. In the Vyuh Framework,
feature flags integrate with the **Condition** system, enabling you to use them
for conditional routes, conditional content, and conditional actions -- all
configured from the CMS.

## How Feature Flags Work in Vyuh

The framework provides a `FeatureFlagPlugin` interface in `vyuh_core`. This
plugin acts as a bridge between your feature flag service (such as LaunchDarkly,
Firebase Remote Config, or a custom backend) and the rest of the framework.

```dart
abstract class FeatureFlagPlugin extends Plugin {
  Future<bool> isEnabled(String flagName);
  Future<String?> getValue(String flagName);
}
```

- **`isEnabled()`** checks whether a boolean flag is turned on or off.
- **`getValue()`** retrieves the string value of a flag, which is useful for
  multi-variant flags (e.g., A/B/N testing).

Once a `FeatureFlagPlugin` is registered, it becomes accessible throughout the
application via `vyuh.featureFlag`.

## Integration with Conditions

The built-in **Feature Flag** condition type connects the `FeatureFlagPlugin` to
the Vyuh Condition system. When a Feature Flag condition is evaluated, it calls
into the registered plugin to check the flag's value, then returns the result as
a string. This result drives the branching logic for whichever element the
condition is attached to.

::: info Feature Flag as a Condition
The Feature Flag condition works like any other condition in the framework. It
evaluates asynchronously, returns a string value, and can be used anywhere a
condition is expected. See the [Conditions](/cms/guides/conditions) guide for
details on how conditions work.
:::

Because conditions are a general-purpose mechanism, feature flags can be applied
in several places:

### Conditional Routes

A **Conditional Route** with a Feature Flag condition lets you direct users to
different pages based on a flag. For example, you could use a flag called
`new_checkout_flow` to send some users to the redesigned checkout and others to
the existing one.

In the CMS, you would:

1. Create a Conditional Route for the path (e.g., `/checkout`).
2. Select the **Feature Flag** condition and specify the flag name.
3. Set up the route cases: one for `true` pointing to the new checkout route, and
   one for `false` pointing to the existing route.

This is configured entirely in the CMS. No code changes are required to switch
between the two routes.

### Conditional Content

A **Conditional Content** block can show or hide content items based on a flag.
This is useful for rolling out new UI sections gradually. For instance, a
`show_promo_banner` flag could control whether a promotional banner appears on
the home screen.

### Conditional Actions

A **Conditional Action** can trigger different actions depending on a flag. For
example, a `use_new_api` flag could determine whether a button invokes the
legacy API endpoint or the new one.

::: tip Combining with Other Conditions
Feature flag conditions can be nested with other conditional elements. A
Conditional Route could use a feature flag, and within the resulting route, a
Conditional Content block could use a different condition (such as platform or
screen size). This composability gives you fine-grained control over the user
experience.
:::

## Creating a Custom FeatureFlagPlugin

To connect your feature flag service to Vyuh, create a class that extends
`FeatureFlagPlugin`. Here is an example using LaunchDarkly:

```dart
final class LaunchDarklyFeatureFlagPlugin extends FeatureFlagPlugin {
  LaunchDarklyFeatureFlagPlugin()
      : super(name: 'feature_flag', title: 'LaunchDarkly');

  @override
  Future<void> init() async {
    // Initialize LaunchDarkly SDK
  }

  @override
  Future<bool> isEnabled(String flagName) async {
    // Check flag status via LaunchDarkly
  }

  @override
  Future<String?> getValue(String flagName) async {
    // Get flag value
  }

  @override
  Future<void> dispose() async {
    // Cleanup
  }
}
```

The `init()` method is called when the application starts and is where you
configure the SDK, set up user contexts, and establish connections. The
`dispose()` method handles cleanup when the application shuts down.

## Registering the Plugin

Register your feature flag plugin in the `runApp()` call using the
`PluginDescriptor`:

```dart
vc.runApp(
  plugins: PluginDescriptor(
    featureFlag: LaunchDarklyFeatureFlagPlugin(),
  ),
  features: () => [...],
);
```

Once registered, the plugin is available via `vyuh.featureFlag` and is
automatically used by any Feature Flag conditions configured in the CMS.

## Using Feature Flags in Code

While feature flags are primarily used through the CMS-driven condition system,
you can also query them directly in your Dart code:

```dart
// Check a boolean flag
final isEnabled = await vyuh.featureFlag.isEnabled('new_feature');

// Get a multi-variant flag value
final variant = await vyuh.featureFlag.getValue('experiment_group');
```

This is useful when you need to control behavior in feature initialization logic
or in custom widgets that are not managed by the CMS.

## Summary

Feature flags in the Vyuh Framework connect your feature flag service to the
Condition system through the `FeatureFlagPlugin`. Once configured, you can use
feature flags as conditions for routes, content blocks, and actions -- all from
the CMS. This allows you to control rollouts, run experiments, and toggle
functionality without code changes or redeployments.
