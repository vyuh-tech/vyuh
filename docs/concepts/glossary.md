---
title: Glossary
---

# Glossary

| Term | Meaning |
| --- | --- |
| App | A Flutter product composed from selected features and plugin implementations |
| Feature | A package owning a coherent product capability |
| Feature descriptor | The public declaration of a feature’s metadata, routes, dependencies, lifecycle, and contributions |
| Plugin | A shared capability contract and its app-selected implementation |
| Provider | A specific backend implementation inside a capability that supports providers |
| Extension descriptor | A feature’s declared contribution to a shared extension system |
| Extension builder | The owner that aggregates compatible contributions |
| Feature dependency | A named prerequisite that must be ready before a dependent feature initializes |
| Lazy feature | A feature loaded when requested rather than during eager startup |
| Readiness | The runtime state indicating initialization has completed successfully |
| Scope | A bounded lifetime for related dependency-injection registrations |

See [features and plugins](features-and-plugins) and [startup and lifecycle](runtime-lifecycle).
