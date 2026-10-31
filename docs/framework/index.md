---
title: Framework packages
description: Choose the composition, shared capabilities, and tooling for your Flutter app.
---

# Framework packages

Start with `vyuh_core` to compose independent features and shared capabilities. Add storage and telemetry implementations when your app needs them.

<FrameworkLayers />

| Package | Responsibility |
| --- | --- |
| [Core](vyuh-core) | Features, plugins, app composition, routing, lifecycle, events, redirects, errors and theming |
| [Cache](vyuh-cache) | Expiration-aware reads and shared generation for concurrent misses |
| [Hive storage](hive-storage) | General values in a named Hive box |
| [Secure storage](secure-storage) | String values through platform secure storage |
| [Preferences](shared-preferences-storage) | Simple string preferences; values use `toString()` |
| [Console telemetry](console-telemetry) | Console messages and errors; trace operations are no-ops |
| [Test helpers](vyuh-test) | Readiness and mocked-context utilities |
| [CLI](/intro/cli) | A tool that scaffolds apps, features and plugins; covered in Getting Started |

Content-driven apps add the optional [CMS packages](/cms/packages/vyuh-extension-content): the content runtime, system feature, auth, onboarding, developer tools, Widgetbook previews and the Sanity integration.

Follow [the core API catalog](/api/) for declarations and [examples](/examples/) for feature composition.
