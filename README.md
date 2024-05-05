<p align="center">
  <a href="https://vyuh.tech">
    <img src="_images/logo.png" alt="Vyuh Logo" height="128" />
  </a>
  <h1 align="center">Vyuh Framework</h1>
  <p align="center">Build Modular, Scalable, CMS-driven Flutter Apps</p>
  <h4 align="center">
    <a href="https://docs.vyuh.tech">Docs</a> |
    <a href="https://vyuh.tech">Website</a>
  </h4>
</p>

[![Codecov](https://img.shields.io/codecov/c/github/vyuh-tech/vyuh?token=5NL6KJ70AR&logo=codecov&style=for-the-badge)](https://codecov.io/github/vyuh-tech/vyuh)
&nbsp;
[![Publish Action](https://img.shields.io/github/actions/workflow/status/vyuh-tech/vyuh/publish-dart.yml?label=Publish&logo=github&style=for-the-badge)](https://github.com/vyuh-tech/vyuh/actions/workflows/publish-dart.yml)
&nbsp;
[![Discord](https://img.shields.io/discord/1198906057502769252?style=for-the-badge&logo=discord)](https://discord.gg/b49sbjqszG)

| Packages                                                                                                                                                                                                                            |
| :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| _Sanity Integration_                                                                                                                                                                                                                |
| [![sanity_client](https://img.shields.io/pub/v/sanity_client.svg?label=sanity_client&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/sanity_client)                                                             |
| [![flutter_sanity_portable_text](https://img.shields.io/pub/v/flutter_sanity_portable_text.svg?label=flutter_sanity_portable_text&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/flutter_sanity_portable_text) |
| _Vyuh_                                                                                                                                                                                                                              |
| [![vyuh_core](https://img.shields.io/pub/v/vyuh_core.svg?label=vyuh_core&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_core)                                                                             |
| [![vyuh_cache](https://img.shields.io/pub/v/vyuh_cache.svg?label=vyuh_cache&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_cache)                                                                         |
| [![vyuh_extension_content](https://img.shields.io/pub/v/vyuh_extension_content.svg?label=vyuh_extension_content&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_extension_content)                         |
| [![vyuh_feature_system](https://img.shields.io/pub/v/vyuh_feature_system.svg?label=vyuh_feature_system&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_feature_system)                                     |
| [![vyuh_feature_developer](https://img.shields.io/pub/v/vyuh_feature_developer.svg?label=vyuh_feature_developer&logo=dart&color=blue&style=for-the-badge)](https://pub.dev/packages/vyuh_feature_developer)                         |

<hr style="height: 1px;"/>

**Vyuh** is a framework to build CMS-driven Flutter Apps at scale. It gives the
**no-code** flexibility to the Business teams (via the CMS), and the
**full-code** power to the Engineering teams. This puts the right control at the
right place without any compromise.

> CMS is one of the many extensible integrations inside Vyuh. All integrations
> are managed as Plugins, which are standardized interfaces to extend the
> capabilities of the framework.

## Why did we build this?

A common problem when building large scale apps is the _need to stay modular_ as
you keep growing the feature set. You also want different teams to _work in
parallel_ without stepping on each other. The typical approach of creating a
single project and building all the functionality in it does not scale very well
over time. You could break up the app into several packages but that still does
not give you the clarity of who owns what. It does not tell you how to combine
these packages to create the final app.

Additionally, Apps today are very content-oriented and need to be dynamic. This
means your journeys, page content, themes, etc. should be remotely controllable.
In other words, making your app _Server-driven_.

### Separation of Concerns

Combining all these capabilities requires a holistic approach, which is only
possible when you build a cohesive framework.

> **Vyuh** is that framework.
>
> It allows you to create the perfect balance of simple, modular components on
> the `CMS`, with powerful `Flutter` counterparts that take care of all the
> complexity.

The teams managing the content and experience don't have to worry about pixel
precision or performance and focus more on _building the screen journeys and
page content_ instead. The Flutter engineering teams handle the complexity of
the components along with its performance.

This clear separation allows a phenomenal flexibility in building simple to
large scale apps. It also gives _the right tools to the right teams_ and makes
them more productive.

**Vyuh** comes with powerful capabilities like:

- [x] Building features atomically and in a modular fashion.
- [x] Features as transferable and reusable units of functionality that can be
      moved between Apps.
- [x] Remote configuration of content, enabling Server-Driven UI.
- [x] Extensible Plugin-based approach to add new third-party integrations.
- [x] Team Independence.
- [x] Decentralised development.
- [x] Creating a family of apps with reusable features.
- [x] A growing set of integrations (aka building blocks) to make app
      development faster.

## The Building Blocks

Vyuh comes with some core building blocks such as:

- **Features**: build user-facing functionality in a modular, reusable, atomic
  manner. Features can be composed together to create the entire app or a family
  of apps. Features can also be transferred between apps easily.
- **Plugins**: All third party integrations are handled in a cross-cutting
  manner using Plugins. Authentication, Networking, CMS, Storage, Permissions,
  Ads, etc. are all plugins that are available to all features.
- **CMS-Driven UI**: Also known as Server-Driven UI, the entire app experience
  can be driven from a CMS. This includes the screen journeys, page content,
  themes, etc. The CMS itself is a standard plugin with custom Providers. Bring
  your own CMS as a `ContentProvider`!
- **Community packages**: leverages the best community packages like `mobx`,
  `go_router`, `get_it`, `hive`, `firebase`, etc. This means you don't have to
  learn anything proprietary to use Vyuh.

> It is plain old Flutter with a fresh approach to building scalable apps.

## Getting Started

Start with the documentation on the [Website](https://docs.vyuh.tech).

## Contact

Follow us, stay up to date or reach out on:

- [@vyuh_tech](https://x.com/vyuh_tech)
- [LinkedIn](https://www.linkedin.com/company/vyuh-tech)
- [Discord](https://discord.gg/b49sbjqszG)
- [Email](mailto:ask@vyuh.tech)

## License

The framework is [MIT Licensed](LICENSE).
