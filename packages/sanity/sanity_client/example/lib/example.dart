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
