# Vyuh CLI

Scaffold modular Flutter Apps, portable features, and shared capability plugins. CMS integration is optional and disabled by default.

## Install

```sh
dart pub global activate vyuh_cli
```

## Create an App workspace

```sh
vyuh create project shop --org-name=com.acme --platforms=android,ios,web -o products
```

Creates a Dart workspace with a Flutter App, a counter feature, plugin/package directories, Material UI, and local Melos tooling. It runs Flutter setup and workspace bootstrap. Flutter and Dart must be on PATH. `--application-id` overrides native bundle identifiers; `--description` sets the App description. CMS defaults to `none`; `--cms=sanity` explicitly adds Sanity packages and a Studio, requiring Node/pnpm and Sanity account access.

## Create a feature

```sh
vyuh create feature feature_catalog --title="Catalog" --description="Product browsing" --route=/catalog -o features
```

Generates a Flutter package with a descriptor and starter screen. Add it to the workspace/dependencies and include its descriptor in `runApp(features: ...)`. Package names use lowercase letters, digits, and underscores. Routes must be absolute paths.

## Create a plugin

```sh
vyuh create plugin catalog_search --class-name=CatalogSearchPlugin --title="Catalog search" --description="Shared search capability" -o plugins
```

Generates an exported custom Plugin class using InitOncePlugin, cleanup hooks, and a lifecycle test. Register it in PluginDescriptor.others and retrieve it through vyuh.getPlugin. For a built-in system capability, implement its specific contract and use the named descriptor slot instead.

## Optional CMS scaffolds

```sh
vyuh create schema catalog --cms=sanity
vyuh create item product --feature=feature_catalog
```

These commands are explicit authoring tools, independent of the default App/feature/plugin path.

## Development tools

```sh
vyuh doctor
vyuh doctor --cms=sanity
vyuh update
vyuh completion --help
vyuh --version
vyuh create project --help
```

Doctor checks Flutter/Dart by default and adds Node/pnpm checks when Sanity is selected. Each create command supports --output-directory (-o). Built-in scaffolds ship with the CLI so a registry brick cannot replace them with older templates.
