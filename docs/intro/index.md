---
title: What is Vyuh?
description: A modular framework to grow your Flutter app. Independent features, shared capabilities, composable apps.
---

# A modular framework to grow your Flutter app

Vyuh helps you build large Flutter applications from independent **features**, supported by shared **plugins**. A feature owns a useful slice of your product. A plugin provides a capability that one or more features need. Your app chooses the pieces and brings them together.

<FrameworkLayers />

## Build one feature at a time

Keep a feature’s routes, state, UI, and initialization in its own Flutter package. A `FeatureDescriptor` exposes what the feature contributes to the app. Teams can work on those packages independently and add features without moving everything into a single application module.

A boundary should follow a coherent product capability: catalog, account, search, checkout. A screen alone is not always a useful boundary, and an entire customer journey can cross several features.

## Share the capabilities beneath them

Plugins provide contracts for logging, telemetry, networking, authentication, storage, navigation, and other shared services. Configure the implementations once in your app. Features use the contracts rather than constructing their own infrastructure.

This keeps capability choices with the app: two apps can share a feature package while selecting different plugin implementations.

## Compose different apps from the same pieces

A customer app might include catalog, account, and checkout. A team app might reuse catalog with inventory and reporting. Reuse the feature package and its public contributions, keeping app-specific details in configuration or the app’s chosen plugins.

Portability depends on explicit dependencies and routes. Avoid reaching into another app’s private state or hard-coding app-only assumptions inside a shared feature.

## Start with an ordinary Flutter screen

The [quick start](get-started) provides a complete app with one feature and a standard Flutter screen. Then [compose two features](compose-features) around one app-selected capability.

<ActionLink href="/intro/get-started" variant="primary">Build your first feature</ActionLink>

## Follow the learning path

| Section | Use it to |
| --- | --- |
| [Getting Started](get-started) | Run your first app and learn the project structure |
| [Concepts](/concepts/) | Understand features, plugins, extensions, and lifecycle |
| [Guides](/guides/creating-a-feature) | Implement specific behaviors |
| [Framework](/framework/) | Choose the packages and their responsibilities |
| [Examples](/examples/) | Trace complete features in source |
| [API References](/api/) | Look up declarations and directly declared members |

Read [Why Vyuh?](/concepts/why-vyuh) for the ownership, reuse, and lifecycle decisions behind this model. The [CLI](cli) can scaffold feature packages as your project grows.
