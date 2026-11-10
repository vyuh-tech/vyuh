---
title: FAQ
---

# FAQ

## Does Vyuh replace Flutter?

Vyuh uses Flutter for UI. It adds feature composition, shared capability contracts, lifecycle, routing integration, and extension aggregation around your widgets.

## What belongs in a feature?

A coherent product capability: its routes, state, UI, setup, cleanup, and public contributions. Start with ownership that a team can evolve independently.

## What belongs in a plugin?

A capability shared by one or more features, such as networking, authentication, storage, logging, or telemetry. Apps select implementations; features consume the contract.

## Can two apps share a feature?

Yes. Reuse its Flutter package and public descriptor. Keep app-only configuration and assumptions outside the reusable package, and include the feature’s dependencies in each consuming app.

## Can a feature load later?

Use a lazy feature descriptor with a loader and route prefixes. Measure the target platform’s release artifact before claiming a startup or bundle-size improvement.

## How do I begin?

Follow the [quick start](/intro/get-started), then the [counter example](/examples/counter) and [feature tutorial](/guides/tutorial).
