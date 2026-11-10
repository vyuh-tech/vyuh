<p align="center">
  <a href="https://vyuh.tech">
    <img src="https://github.com/vyuh-tech.png" alt="Vyuh Logo" height="128" />
  </a>
  <h1 align="center">Vyuh Framework</h1>
  <p align="center">A modular framework to grow your Flutter app.<br/>Independent features, shared capabilities, composable apps.</p>
  <h4 align="center">
    <a href="https://docs.vyuh.tech">Docs</a> |
    <a href="https://vyuh.tech">Website</a>
  </h4>
</p>

[![Discord](https://img.shields.io/discord/1198906057502769252?style=for-the-badge&logo=discord)](https://discord.gg/b49sbjqszG)
[![Twitter Follow](https://img.shields.io/twitter/follow/vyuh_tech?style=for-the-badge&logo=x)](https://twitter.com/vyuh_tech)

# Docs for Vyuh

The main documentation for the Vyuh Framework: feature ownership, app-selected plugin capabilities, and composition into Flutter apps. Start with Getting Started and Why Vyuh. Optional content systems, authoring, and integrations have their own CMS Integration section.

## Built with VitePress

This documentation has been created with
[VitePress](https://vitepress.dev), a Vite & Vue powered static site generator.

## Local development

Run `bun install` at the repo root, then `bun run docs` (or `bun run dev` in this folder) for live updates with HMR.

Run `bun run build` to validate core/CMS structure, redirects, Mermaid diagrams, and all pages.

The site lives in the framework monorepo, so it always documents the code beside it. After changing a public API, run `bun run docs:api` to regenerate the API reference from source, and `bun run docs:examples` to sync the first-app example. Both need `flutter pub get` at the repo root.

Pages sit directly in this folder (`intro/`, `concepts/`, `guides/`, `api/`, `cms/`, `examples/`, `framework/`). Site configuration, theme and scripts live in `.vitepress/`. Every push to `main` that touches `docs/` deploys docs.vyuh.tech through `.github/workflows/deploy_docs.yml`.

## Analytics

![Alt](https://repobeats.axiom.co/api/embed/c608ba0ba3b14640f9fa29ae2f8f6463bc10d09d.svg 'Repobeats analytics image')

## License

The documentation is FSL Licensed.
