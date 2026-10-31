---
title: Setting Up Sanity
description: Integrating the Vyuh Framework with Sanity.io as your headless CMS
---

# Setting Up Sanity

The Vyuh Framework uses [Sanity.io](https://sanity.io) as its default supported
CMS. This guide walks you through setting up Sanity, configuring the studio, and
connecting it to your Flutter app.

## Overview

The CMS (Content) is a flagship extension provided by the Vyuh Framework. It
allows you to integrate with any headless CMS and have it control the app
experience. The Content extension is supported by two types of classes:
`ContentExtensionDescriptor` and `ContentExtensionBuilder`, which work in
conjunction to extract the content extensions from various features and use them
to render content in the final app.

::: info Descriptors and Builders
The `ContentExtensionDescriptor` is used by individual features to export
various content types, actions, conditions, and other kinds of configurations.
The `ContentExtensionBuilder` compiles all these descriptors across the features
and assembles a registry that is used to render content at runtime.
:::

## 1. Setup the Sanity CMS

Sanity is a headless CMS that allows you to define your own schemas and content
types entirely in code. This makes it easy to quickly build sophisticated
schemas without wrestling with any drag-and-drop builders. It also includes a
**Studio** which becomes the go-to UI tool for content editors.

### Scaffold the Project

Set up a free Sanity project using the
[guides from Sanity.io](https://www.sanity.io/get-started?ref=hero) or use the
command line:

```bash
pnpm dlx create-sanity@latest
```

While creating the Sanity project, select the project template as
`Clean project with no predefined schema types`.

::: tip Scaffold Quickly
A faster way to scaffold a Vyuh project is with the `vyuh_cli` tool. The Vyuh
CLI can generate a complete Vyuh project, a Flutter feature package, and an NPM
schema package.
:::

## 2. Configure the Studio

Add the following dependencies to your `package.json` and run `pnpm install`:

```json5
{
  dependencies: {
    '@vyuh/sanity-plugin-structure': '^1.16.2',
    '@vyuh/sanity-schema-core': '^1.16.2',
    '@vyuh/sanity-schema-system': '^1.16.2',
  },
}
```

Update the `sanity.config.ts` file:

```typescript
import { defineConfig } from 'sanity'
import { vyuh } from '@vyuh/sanity-plugin-structure'
import { system } from '@vyuh/sanity-schema-system'

export default defineConfig([
  {
    name: 'default',
    title: 'My Blog',
    basePath: '/',

    projectId: '<Your Sanity Project ID>',
    dataset: 'production',

    plugins: [
      vyuh({
        features: [
          system,
          // ... other features ...
        ],
      }),
    ],
  },
])
```

::: info The vyuh() Plugin
**`vyuh({ features: [] })`** is a Sanity plugin that configures the studio.
It takes an array of `FeatureDescriptor` instances that represent the features
of your application. Each `FeatureDescriptor` contributes a set of content
schemas available on the Studio. It also includes the standard Sanity plugins
such as the _Structure_, _Vision_, and _Media_ plugins.
:::

Now run the project with `pnpm dev`. Your studio should include the standard
document types of _Route_, _Conditional Route_, _Category_, and _Region_.

## 3. Explore the Sanity Studio

Create a simple route for a blog post with the path `/blog`. Add a region on
the route and call it `body`. Inside this region, add the `Portable Text` block.

Create some text and format it to look like a real blog post. You can add a
title, section headings, paragraphs, and images.

## 4. Create the Feature on the Flutter Side

Just like the `FeatureDescriptor` for setting up schemas in Sanity, there is an
equivalent `FeatureDescriptor` on the Flutter side that handles rendering:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

final feature = FeatureDescriptor(
  name: 'blog',
  title: 'My diary of travel blogs',
  description: 'Chronicling my journeys across the world',
  icon: Icons.pages,
  routes: () async {
    return [
      GoRoute(
        path: '/blog',
        pageBuilder: defaultRoutePageBuilder,
      ),
    ];
  },
);
```

The `defaultRoutePageBuilder` is a standard page builder that knows how to work
with CMS routes.

## 5. Setup the Vyuh App

Connect the content, feature, and the app. Add the required framework packages:

```shell
flutter pub add vyuh_feature_system vyuh_feature_developer vyuh_plugin_content_provider_sanity
```

Now set up `SanityContentProvider` within the `DefaultContentPlugin`:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:sanity_client/client.dart';
import 'package:vyuh_core/vyuh_core.dart' as vc;
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'feature.dart' as blog;
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;
import 'package:vyuh_feature_developer/vyuh_feature_developer.dart'
    as developer;
import 'package:vyuh_plugin_content_provider_sanity/vyuh_plugin_content_provider_sanity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  vc.runApp(
    initialLocation: '/blog',
    features: () => [
      system.feature,
      developer.feature,
      blog.feature,
    ],
    plugins: PluginDescriptor(
      content: DefaultContentPlugin(
        provider: SanityContentProvider(
          SanityClient(
            SanityConfig(
              dataset: 'your_dataset',
              projectId: 'your_project_id',
              token: 'your_token',
            ),
          ),
        ),
      ),
    ),
  );
}
```

- Use `/blog` as the `initialRoute` to load it as the starting page
- The `project-id` should match the one used for the Studio setup
- To get the **token**, visit the Manage console of the Sanity Project and
  create a Read Token

::: tip Running on the Web?
If you are running on the Web, make sure to update the **CORS Origins** in
Sanity to include the port number you are using. You will also have to pass
`--web-port=8080` to ensure the browser launches on the correct port.
:::

## CMS-Side FeatureDescriptor

The `FeatureDescriptor` class on the CMS side has a well-defined structure:

```typescript
class FeatureDescriptor {
  name: string
  title: string
  description: string
  contents: ContentDescriptor[]
  contentSchemaBuilders: ContentSchemaBuilder[]
  contentSchemaModifiers: ContentSchemaModifier[]
  actions: SchemaTypeDefinition[]
  conditions: SchemaTypeDefinition[]
}
```

Each feature exports its schemas through this descriptor. The `vyuh()` plugin
reads all `FeatureDescriptor` instances and assembles them into a single master
schema for Sanity.

## Flutter-Side Setup

A similar setup exists on the Flutter side, where you bootstrap the counterpart
features of the content schemas:

```dart
import 'package:vyuh_core/vyuh_core.dart' as vc;

void main() async {
  final plugins = await _getPlugins();

  vc.runApp(
    initialLocation: '/chakra',
    features: () => [
      system.feature,
      developer.feature,
      // ... other features ...
    ],
    plugins: plugins,
  );
}
```

The main entry point calls `runApp()` from the **`vyuh_core`** library, taking
in an array of `features` and `plugins` to bootstrap the Vyuh app.

## Summary

This guide covered how to set up Sanity as your CMS, configure the Studio with
Vyuh's schema plugins, and connect it to your Flutter app. With this setup, you
can make changes on Sanity and have them rendered in real time.

Try exploring other content types such as Cards, Groups, and playing around with
Actions and Conditions. Refer to the dedicated guides for more information:

- [Content Types](/cms/guides/content-types)
- [Layouts](/cms/guides/layouts)
- [Actions](/cms/guides/actions)
- [Conditions](/cms/guides/conditions)
