---
title: Concepts
description: Understand the composition model behind modular Flutter apps.
---

# Concepts

Think in three layers: shared plugin capabilities, portable features, and apps composed from those features. Extensions let a feature contribute to a shared system through a declared contract.

<FrameworkLayers />

## Start with ownership

[Why Vyuh?](why-vyuh) explains when explicit product boundaries and app-owned composition help, what reuse requires, and what the framework adds to ordinary Flutter packages.

[Features and plugins](features-and-plugins) explains where routes, state, UI, services, and configuration belong. An app selects the composition; features own product capabilities; plugins own shared services.

## Understand contributions

[Descriptors and builders](descriptors-and-builders) explains how features declare contributions and how a builder aggregates them.

## Follow the runtime

[Startup and lifecycle](runtime-lifecycle) covers dependency ordering, readiness, lazy loading, and disposal. [Performance and correctness](performance) covers caching and the checks that preserve accurate behavior.

Use the [glossary](glossary) for terminology and [FAQ](faq) for common questions. The [API References](/api/) provide the package contracts.
