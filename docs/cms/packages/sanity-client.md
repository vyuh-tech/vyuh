---
title: Sanity Client
description: Package responsibilities and setup for sanity_client.
---

# Sanity Client

SanityClient runs GROQ queries using an injected or default HTTP client. SanityConfig selects project, dataset, API version, perspective, and CDN behavior. The client also builds image/file URLs and provides a live query stream.

```mermaid
flowchart LR
  Config["SanityConfig"] --> Client["SanityClient"]
  Client --> HTTP["HTTP query request"]
  HTTP --> Result["QueryResponse"]
```

[Browse every public declaration and member](/cms/api/sanity-client).



<PubBadge package="sanity_client" />

The `sanity_client` package is a native Dart client for running GROQ queries and fetching documents from [Sanity.io](https://sanity.io). It provides the low-level communication layer between your Flutter app and the Sanity content platform.

## Overview

Sanity.io is a headless CMS that stores structured content as JSON documents. This client library allows you to query and fetch those documents using GROQ (Graph-Relational Object Queries), Sanity's powerful query language.

## Key Features

- **GROQ query support** -- Execute GROQ queries against your Sanity dataset
- **Document fetching** -- Fetch individual documents or collections
- **CDN support** -- Option to use the Sanity CDN for faster reads
- **Perspective modes** -- Support for published, drafts, and preview perspectives
- **Authentication** -- Token-based authentication for private datasets
- **Real-time updates** -- Server-Sent Events (SSE) over `package:http` for live content updates, on every platform including web

## Configuration

```dart
import 'package:sanity_client/sanity_client.dart';

final client = SanityClient(
  SanityConfig(
    projectId: 'your-project-id',
    dataset: 'production',
    token: 'your-token', // optional, for authenticated access
    useCdn: true,
    perspective: Perspective.published,
  ),
);
```

## Usage

### Fetching documents with GROQ

```dart
// Fetch all documents of a specific type
final results = await client.fetch(
  '*[_type == "article"]',
);

// Fetch a single document by ID
final doc = await client.fetch(
  '*[_id == "document-id"][0]',
);

// Fetch with parameters
final filtered = await client.fetch(
  '*[_type == "article" && category == \$category]',
  params: {'category': 'technology'},
);
```

## Integration with Vyuh

While you can use `sanity_client` directly, it is typically used through the `vyuh_plugin_content_provider_sanity` package which wraps it in a Vyuh-compatible content provider:

```dart
SanityContentProvider.withConfig(
  config: SanityConfig(
    projectId: 'your-project-id',
    dataset: 'production',
  ),
)
```

## Links

- [pub.dev](https://pub.dev/packages/sanity_client)
- [GitHub Source](https://github.com/vyuh-tech/vyuh/tree/main/packages/sanity/sanity_client)
- [GROQ Documentation](https://www.sanity.io/docs/groq)
