library;

import 'package:feature_conference/api/conference_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

final feature = FeatureDescriptor(
  name: 'feature_conference',
  title: 'Feature Conference',
  description: 'Describe your feature in more detail here.',
  icon: Icons.add_circle_outlined,
  init: () async {
    vyuh.di.register(ConferenceApi(vyuh.content.provider));
  },
  routes: () async {
    return [
      GoRoute(
          path: '/conference',
          builder: (context, state) {
            return const _ConferenceRoot();
          },
          routes: [
            GoRoute(
              path: ':identifier',
              builder: (context, state) {
                return const _ConferenceDetail();
              },
            ),
          ]),
    ];
  },
);

final class _ConferenceDetail extends StatefulWidget {
  const _ConferenceDetail();

  @override
  State<_ConferenceDetail> createState() => _ConferenceDetailState();
}

class _ConferenceDetailState extends State<_ConferenceDetail> {
  @override
  Widget build(BuildContext context) {
    final identifier = GoRouterState.of(context).pathParameters['identifier']!;

    return Scaffold(
      appBar: AppBar(title: const Text('Editions')),
      body: FutureBuilder(
          future: vyuh.di.get<ConferenceApi>().getEditions(identifier),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final editions = snapshot.data!;
              return ListView.builder(
                  itemCount: editions.length,
                  itemBuilder: (context, index) {
                    final edition = editions[index];
                    return ListTile(
                      title: Text(edition.title),
                      subtitle: Text(edition.identifier),
                      onTap: () {
                        vyuh.router.push(
                            '/conference/$identifier/editions/${edition.identifier}');
                      },
                    );
                  });
            } else if (snapshot.hasError) {
              return vyuh.widgetBuilder.errorView(context,
                  title: 'Failed to load Editions', error: snapshot.error!);
            } else {
              return vyuh.widgetBuilder.contentLoader(context);
            }
          }),
    );
  }
}

final class _ConferenceRoot extends StatefulWidget {
  const _ConferenceRoot();

  @override
  State<_ConferenceRoot> createState() => _ConferenceRootState();
}

class _ConferenceRootState extends State<_ConferenceRoot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conferences')),
      body: FutureBuilder(
          future: vyuh.di.get<ConferenceApi>().getConferences(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final conference = snapshot.data![index];
                    return ListTile(
                      title: Text(conference.title),
                      subtitle: Text(conference.identifier),
                      onTap: () {
                        vyuh.router.push('/conference/${conference.id}');
                      },
                    );
                  });
            } else {
              return vyuh.widgetBuilder.contentLoader(context);
            }
          }),
    );
  }
}
