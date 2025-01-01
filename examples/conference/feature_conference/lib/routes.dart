import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/layouts/speaker_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' hide RouteBase;
import 'package:vyuh_feature_system/vyuh_feature_system.dart' hide Card;

import 'content/session.dart';
import 'content/speaker.dart';
import 'content/track.dart';

Future<List<RouteBase>> routes() async {
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
          path: 'speakers/:speakerId',
          builder: (context, state) {
            final speakerId = state.pathParameters['speakerId']!;
            final editionId = state.pathParameters['editionId']!;
            return _SpeakerDetail(speakerId: speakerId, editionId: editionId);
          },
        ),
        GoRoute(
          path: 'tracks',
          builder: (context, state) {
            final editionId = state.pathParameters['editionId']!;
            return _Tracks(editionId: editionId);
          },
        ),
        GoRoute(
          path: 'tracks/:trackId',
          builder: (context, state) {
            final trackId = state.pathParameters['trackId']!;
            final editionId = state.pathParameters['editionId']!;
            return _TrackDetail(trackId: trackId, editionId: editionId);
          },
        ),
      ],
    ),
  ];
}

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
              return ListView.separated(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return vyuh.content.buildContent(context, session);
                },
                separatorBuilder: (_, __) => SizedBox(height: 16),
              );
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
              return ListView.separated(
                itemCount: editions.length,
                itemBuilder: (context, index) {
                  final edition = editions[index];
                  return vyuh.content.buildContent(context, edition);
                },
                separatorBuilder: (_, __) => SizedBox(height: 16),
              );
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

final class _TrackDetail extends StatelessWidget {
  final String trackId;
  final String editionId;

  const _TrackDetail({required this.trackId, required this.editionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Sessions'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          vyuh.di.get<ConferenceApi>().getTrack(id: trackId),
          vyuh.di
              .get<ConferenceApi>()
              .getSessions(editionId: editionId, trackId: trackId),
        ]),
        builder: (context, snapshot) {
          final theme = Theme.of(context);

          if (snapshot.hasData) {
            final track = snapshot.data![0] as Track;
            final sessions = snapshot.data![1] as List<Session>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  color: theme.colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(track.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.apply(
                              color: theme.colorScheme.onPrimaryContainer)),
                      Text('Sessions: ${sessions.length}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.apply(
                              color: theme.colorScheme.onPrimaryContainer)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return vyuh.content.buildContent(context, session);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return vyuh.widgetBuilder.errorView(
              context,
              title: 'Failed to load Track Details',
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

final class _SpeakerDetail extends StatelessWidget {
  final String speakerId;
  final String editionId;

  const _SpeakerDetail({required this.speakerId, required this.editionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([
          vyuh.di.get<ConferenceApi>().getSpeaker(id: speakerId),
          vyuh.di
              .get<ConferenceApi>()
              .getSessions(editionId: editionId, speakerId: speakerId),
        ]),
        builder: (context, snapshot) {
          final theme = Theme.of(context);

          if (snapshot.hasData) {
            final speaker = snapshot.data![0] as Speaker;
            final sessions = snapshot.data![1] as List<Session>;

            return CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  floating: false,
                  pinned: true,
                  expandedHeight: speaker.photo != null ? 200 : 80,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(speaker.name),
                    centerTitle: true,
                    background: Container(
                      color: theme.colorScheme.primaryContainer,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (speaker.photo != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ClipOval(
                                child: ContentImage(
                                  ref: speaker.photo,
                                  width: 128,
                                  height: 128,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (speaker.bio != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 32, bottom: 16, left: 16, right: 16),
                      child: Text(
                        speaker.bio!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Sessions (${sessions.length})',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return vyuh.content.buildContent(context, session);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 16),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return vyuh.widgetBuilder.errorView(
              context,
              title: 'Failed to load Speaker Details',
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
