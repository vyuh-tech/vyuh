# Sanity Client

A Dart client for connecting to Sanity.io projects and executing GROQ queries.
It supports the HTTP semantics described here:
https://www.sanity.io/docs/http-query

## Features

- Connect to a Sanity.io project and run GROQ.
- Support all parameters allowed by the HTTP API of Sanity including
  `apiVersion`, `perspective`, `explain`, `useCDN`.
- Has support for switching between URL Builders for images and files. This is
  useful if you are hosting your images on an external service like _Cloudinary_
  or _ImageKit_.

## Usage

Create an instance of the SanityClient and give it a SanityConfig. Use the
`fetch` method to run queries.

```dart
import 'package:sanity_client/sanity_client.dart';

Future<void> main() async {
  // using the SanityClient
  var client = SanityClient(
    SanityConfig(
      projectId: 'your_project_id',
      dataset: 'your_dataset',
      token: 'your_token',
      perspective: Perspective.published,
      explainQuery: true,
      useCdn: true,
      apiVersion: 'v2024-02-16',
    ),
  );

  // make a query
  var query = '''
    *[_type == "movie"]{
      _id,
      title,
      releaseDate,
      "director": crewMembers[job == "Director"][0].person->name
    }
  ''';

  final response = await client.fetch(query);
  print(response);
}

```
