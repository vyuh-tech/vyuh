library;

import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/edition.dart';
import 'package:feature_conference/content/session.dart';
import 'package:feature_conference/content/speaker.dart';
import 'package:feature_conference/content/track.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/content_extension_descriptor.dart';

import 'content/conference.dart';

final feature = FeatureDescriptor(
  name: 'feature_conference',
  title: 'Feature Conference',
  description: 'Describe your feature in more detail here.',
  icon: Icons.add_circle_outlined,
  init: () async {
    vyuh.di.register(ConferenceApi(vyuh.content.provider));
  },
  extensions: [
    ContentExtensionDescriptor(contentBuilders: [
      Conference.contentBuilder,
      Edition.contentBuilder,
      Session.contentBuilder,
      Speaker.contentBuilder,
      Track.contentBuilder,
    ]),
  ],
  routes: () async {
    return [
      GoRoute(
        path: '/conference',
        builder: (context, state) {
          return const _ConferenceRoot();
        },
      ),
      GoRoute(
        path: '/conference/:conferenceId',
        builder: (context, state) {
          return const _ConferenceDetail();
        },
      ),
      GoRoute(
        path: '/conference/:conferenceId/editions/:editionId',
        builder: (context, state) {
          return const _EditionDetail();
        },
      ),
    ];
  },
);

final class _EditionDetail extends StatelessWidget {
  const _EditionDetail();

  @override
  Widget build(BuildContext context) {
    final identifier = GoRouterState.of(context).pathParameters['editionId']!;

    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      body: FutureBuilder(
          future: vyuh.di.get<ConferenceApi>().getSessions(identifier),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final sessions = snapshot.data!;
              return ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return vyuh.content.buildContent(context, session);
                  });
            } else if (snapshot.hasError) {
              return vyuh.widgetBuilder.errorView(context,
                  title: 'Failed to load Sessions', error: snapshot.error!);
            } else {
              return vyuh.widgetBuilder.contentLoader(context);
            }
          }), // ListView
    );
  }
}

final class _ConferenceDetail extends StatelessWidget {
  const _ConferenceDetail();

  @override
  Widget build(BuildContext context) {
    final identifier =
        GoRouterState.of(context).pathParameters['conferenceId']!;

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
                    return vyuh.content.buildContent(context, edition);
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

final class _ConferenceRoot extends StatelessWidget {
  const _ConferenceRoot();

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
                    return vyuh.content.buildContent(context, conference);
                  });
            } else {
              return vyuh.widgetBuilder.contentLoader(context);
            }
          }),
    );
  }
}
