library;

import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/edition.dart';
import 'package:feature_conference/content/session.dart';
import 'package:feature_conference/content/speaker.dart';
import 'package:feature_conference/content/track.dart';
import 'package:feature_conference/layouts/speaker_layout.dart';
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
        routes: [
          GoRoute(
            path: 'speakers',
            builder: (context, state) {
              final editionId = state.pathParameters['editionId']!;
              return _Speakers(editionId: editionId);
            },
          ),
          GoRoute(
            path: 'tracks',
            builder: (context, state) {
              final editionId = state.pathParameters['editionId']!;
              return _Tracks(editionId: editionId);
            },
          ),
        ],
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
          future:
              vyuh.di.get<ConferenceApi>().getSessions(editionId: identifier),
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
          future: vyuh.di
              .get<ConferenceApi>()
              .getEditions(conferenceId: identifier),
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

final class _Speakers extends StatelessWidget {
  const _Speakers({required this.editionId});

  final String editionId;

  @override
  Widget build(BuildContext context) {
    final speakerLayout = SpeakerProfileCardLayout();

    return Scaffold(
      appBar: AppBar(
        title: Text('All Speakers'),
      ),
      body: FutureBuilder(
        future: vyuh.di.get<ConferenceApi>().getSpeakers(editionId: editionId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final speakers = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              padding: const EdgeInsets.all(16),
              itemCount: speakers.length,
              itemBuilder: (context, index) {
                final speaker = speakers[index];
                return vyuh.content
                    .buildContent(context, speaker, layout: speakerLayout);
              },
            );
          } else if (snapshot.hasError) {
            return vyuh.widgetBuilder.errorView(
              context,
              title: 'Failed to load Speakers',
              error: snapshot.error!,
            );
          } else {
            return vyuh.widgetBuilder.contentLoader(context);
          }
        },
      ),
    );
  }
}

final class _Tracks extends StatelessWidget {
  const _Tracks({required this.editionId});

  final String editionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracks'),
      ),
      body: FutureBuilder(
        future: vyuh.di.get<ConferenceApi>().getTracks(editionId: editionId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tracks = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return vyuh.content.buildContent(context, track);
              },
            );
          } else if (snapshot.hasError) {
            return vyuh.widgetBuilder.errorView(
              context,
              title: 'Failed to load Tracks',
              error: snapshot.error!,
            );
          } else {
            return vyuh.widgetBuilder.contentLoader(context);
          }
        },
      ),
    );
  }
}
