<p align="center">
  <a href="https://vyuh.tech">
    <img src="_images/logo.png" alt="Vyuh Logo" height="128" />
  </a>
  <h1 align="center">Vyuh Framework</h1>
  <p align="center">Build Modular, Scalable, CMS-driven Flutter Apps</p>
  <h4 align="center">
    <a href="https://vyuh.tech/docs">Docs</a> |
    <a href="https://vyuh.tech">Website</a>
  </h4>
</p>

![Publish Action](https://img.shields.io/github/actions/workflow/status/vyuh-tech/vyuh/publish-dart.yml?label=Publish&logo=github&style=for-the-badge)&nbsp;
![](https://img.shields.io/discord/1198906057502769252?style=for-the-badge&logo=discord)

<hr />

![vyuh_core](https://img.shields.io/pub/v/vyuh_core.svg?label=vyuh_core&logo=dart&color=blue&style=for-the-badge)&nbsp;
![vyuh_extension_content](https://img.shields.io/pub/v/vyuh_extension_content.svg?label=vyuh_extension_content&logo=dart&color=blue&style=for-the-badge)&nbsp;
![sanity_client](https://img.shields.io/pub/v/sanity_client.svg?label=sanity_client&logo=dart&color=blue&style=for-the-badge)&nbsp;
![flutter_sanity_portable_text](https://img.shields.io/pub/v/flutter_sanity_portable_text.svg?label=flutter_sanity_portable_text&logo=dart&color=blue&style=for-the-badge)&nbsp;

<hr />

Vyuh is a framework to build CMS-driven Flutter Apps at scale. It gives the
**no-code** flexibility to the Business teams (via the CMS), and the
**full-code** power to the Engineering teams. This puts the right control at the
right place without compromise.

## Why did we build this?

A common problem when building large scale apps is the need to stay modular as
you keep growing the feature set. You also want different teams to work in
parallel without stepping on each other. The typical approach of creating a
single project and building all the functionality in it does not scale very well
over time.

Apps today are very content-oriented and need to be dynamic. This means your
journeys, page content, themes, etc. should be remotely controllable. In other
words, making your app Server-driven.

Combining all these capabilities together requires a holistic approach, which is
only possible when you build a cohesive framework. **Vyuh** is that framework.

It comes with powerful capabilities like:

- [x] Building features atomically and in a modular fashion
- [x] Remote configuration of content, enabling Server-Driven UI
- [x] Extensible Plugin based model to add new third-party integrations
- [x] Team Independence
- [x] Decentralised development
- [x] Creating a family of apps with reusable features
- [x] A growing set of integrations (aka building blocks) to make app development
  faster

## The Building Blocks

Vyuh comes with some core building blocks such as:

- **Features**: build user-facing functionality in a modular, reusable, atomic
  manner. Features can be composed together to create the entire app or a family
  of apps. Features can also be transferred between apps easily.
- **Plugins**: All third party integrations are handled in a cross-cutting
  manner using Plugins. Authentication, Networking, CMS, Storage, Permissions,
  Ads, etc. are all plugins that are available to all features.
- **CMS-Driven UI**: Also known as Server-Driven UI, the entire app experience
  can be driven from a CMS
- **Community packages**: leverages the best community packages like `mobx`,
  `go_router`, `get_it`, `hive`, `firebase`, etc. This means you don't have to
  learn anything proprietary to use Vyuh.

> It is plain old Flutter with a fresh approach to building scalable apps.

## Getting Started

Start with the documentation on the [website](https://vyuh.tech).

## Contact

Follow us, stay up to date or reach out on:

- [@vyuh_tech](https://x.com/vyuh_tech)
- [LinkedIn](https://www.linkedin.com/company/vyuh-tech)
- [Email](mailto:ask@vyuh.tech)

## License

The framework is [MIT Licensed](LICENSE).
