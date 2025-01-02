import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/conference.dart';
import 'package:feature_conference/content/edition.dart';
import 'package:feature_conference/layouts/edition_summary_layout.dart';
import 'package:feature_conference/layouts/session_summary_layout.dart';
import 'package:feature_conference/layouts/speaker_layout.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart' hide RouteBase;

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
        redirect: (context, state) {
          if (['overview', 'sessions', 'speakers', 'tracks']
              .contains(state.uri.pathSegments.last)) {
            return state.uri.toString();
          }

          final editionId = state.pathParameters['editionId']!;
          final conferenceId = state.pathParameters['conferenceId']!;

          return '/conference/$conferenceId}/editions/$editionId/overview';
        },
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return _EditionShell(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: 'overview',
                    builder: (context, state) => const _EditionDetail(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: 'sessions',
                    builder: (context, state) {
                      final editionId = state.pathParameters['editionId']!;
                      return _Sessions(editionId: editionId);
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: 'speakers',
                    builder: (context, state) {
                      final editionId = state.pathParameters['editionId']!;
                      return _Speakers(editionId: editionId);
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: 'tracks',
                    builder: (context, state) {
                      final editionId = state.pathParameters['editionId']!;
                      return _Tracks(editionId: editionId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ]),
    GoRoute(
      path: '/conference/:conferenceId/editions/:editionId/sessions/:sessionId',
      builder: (context, state) {
        final sessionId = state.pathParameters['sessionId']!;
        return _SessionDetail(sessionId: sessionId);
      },
    ),
    GoRoute(
      path: '/conference/:conferenceId/editions/:editionId/speakers/:speakerId',
      builder: (context, state) {
        final speakerId = state.pathParameters['speakerId']!;
        final editionId = state.pathParameters['editionId']!;
        return _SpeakerDetail(
          speakerId: speakerId,
          editionId: editionId,
        );
      },
    ),
    GoRoute(
      path: '/conference/:conferenceId/editions/:editionId/tracks/:trackId',
      builder: (context, state) {
        final trackId = state.pathParameters['trackId']!;
        final editionId = state.pathParameters['editionId']!;
        return _TrackDetail(
          trackId: trackId,
          editionId: editionId,
        );
      },
    ),
  ];
}

final class _ConferenceRoot extends StatelessWidget {
  const _ConferenceRoot();

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<List<Conference>>(
      errorTitle: 'Failed to load Conferences',
      future: vyuh.di.get<ConferenceApi>().getConferences(),
      builder: (context, conferences) {
        return ConferenceRouteCustomScrollView(
          title: 'Conferences',
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final conference = conferences[index];
                return vyuh.content.buildContent(context, conference);
              },
              childCount: conferences.length,
            ),
          ),
        );
      },
    );
  }
}

final class _ConferenceDetail extends StatelessWidget {
  const _ConferenceDetail();

  @override
  Widget build(BuildContext context) {
    final identifier =
        GoRouterState.of(context).pathParameters['conferenceId']!;
    final editionLayout = EditionSummaryLayout();

    return ConferenceRouteScaffold<List<Edition>>(
      errorTitle: 'Failed to load Editions',
      future:
          vyuh.di.get<ConferenceApi>().getEditions(conferenceId: identifier),
      builder: (context, editions) {
        return ConferenceRouteCustomScrollView(
          title: 'Editions',
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final edition = editions[index];
                return vyuh.content.buildContent(
                  context,
                  edition,
                  layout: editionLayout,
                );
              },
              childCount: editions.length,
            ),
          ),
        );
      },
    );
  }
}

final class _EditionShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _EditionShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Sessions',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Speakers',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_column_outlined),
            selectedIcon: Icon(Icons.view_column),
            label: 'Tracks',
          ),
        ],
      ),
    );
  }
}

final class _EditionDetail extends StatelessWidget {
  const _EditionDetail();

  @override
  Widget build(BuildContext context) {
    final editionId = GoRouterState.of(context).pathParameters['editionId']!;

    return ConferenceRouteScaffold<Edition>(
      errorTitle: 'Failed to load Edition',
      future: vyuh.di.get<ConferenceApi>().getEdition(id: editionId),
      builder: (context, edition) {
        return ConferenceRouteCustomScrollView(
          title: 'Edition',
          appBarActions: [
            IconButton(
                onPressed: () {
                  vyuh.router.go('/conference');
                },
                icon: Icon(Icons.home))
          ],
          sliver: SliverToBoxAdapter(
            child: vyuh.content.buildContent(context, edition),
          ),
        );
      },
    );
  }
}

final class _Sessions extends StatelessWidget {
  const _Sessions({
    required this.editionId,
  });

  final String editionId;

  @override
  Widget build(BuildContext context) {
    final summaryLayout = SessionSummaryLayout();

    return ConferenceRouteScaffold<List<Session>>(
      errorTitle: 'Failed to load Sessions',
      future: vyuh.di.get<ConferenceApi>().getSessions(editionId: editionId),
      builder: (context, sessions) {
        return ConferenceRouteCustomScrollView(
          title: 'Sessions (${sessions.length})',
          appBarActions: [
            IconButton(
                onPressed: () {
                  vyuh.router.go('/conference');
                },
                icon: Icon(Icons.home))
          ],
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final session = sessions[index];
                return GestureDetector(
                  onTap: () {
                    final conferenceId = GoRouterState.of(context)
                        .pathParameters['conferenceId']!;
                    final editionId =
                        GoRouterState.of(context).pathParameters['editionId']!;

                    vyuh.router.push(
                      '/conference/$conferenceId/editions/$editionId/sessions/${session.id}',
                    );
                  },
                  child: vyuh.content
                      .buildContent(context, session, layout: summaryLayout),
                );
              },
              childCount: sessions.length,
            ),
          ),
        );
      },
    );
  }
}

final class _SessionDetail extends StatelessWidget {
  final String sessionId;

  const _SessionDetail({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<Session>(
      errorTitle: 'Failed to load Session',
      future: vyuh.di.get<ConferenceApi>().getSession(id: sessionId),
      builder: (context, session) {
        return ConferenceRouteCustomScrollView(
          title: 'Session',
          sliver: SliverToBoxAdapter(
            child: vyuh.content.buildContent(context, session),
          ),
        );
      },
    );
  }
}

final class _Speakers extends StatelessWidget {
  const _Speakers({
    required this.editionId,
  });

  final String editionId;

  @override
  Widget build(BuildContext context) {
    final speakerLayout = SpeakerProfileCardLayout();

    return ConferenceRouteScaffold<List<Speaker>>(
      errorTitle: 'Failed to load Speakers',
      future: vyuh.di.get<ConferenceApi>().getSpeakers(editionId: editionId),
      builder: (context, speakers) {
        return ConferenceRouteCustomScrollView(
          title: 'All Speakers',
          appBarActions: [
            IconButton(
                onPressed: () {
                  vyuh.router.go('/conference');
                },
                icon: Icon(Icons.home))
          ],
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final speaker = speakers[index];
                return GestureDetector(
                  onTap: () {
                    final conferenceId = GoRouterState.of(context)
                        .pathParameters['conferenceId']!;
                    final editionId =
                        GoRouterState.of(context).pathParameters['editionId']!;

                    vyuh.router.push(
                      '/conference/$conferenceId/editions/$editionId/speakers/${speaker.id}',
                    );
                  },
                  child: vyuh.content
                      .buildContent(context, speaker, layout: speakerLayout),
                );
              },
              childCount: speakers.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
          ),
        );
      },
    );
  }
}

final class _SpeakerDetail extends StatelessWidget {
  final String speakerId;
  final String editionId;

  const _SpeakerDetail({required this.speakerId, required this.editionId});

  @override
  Widget build(BuildContext context) {
    final summaryLayout = SessionSummaryLayout();

    return ConferenceRouteScaffold<List>(
      errorTitle: 'Failed to load Speaker Details',
      future: Future.wait([
        vyuh.di.get<ConferenceApi>().getSpeaker(id: speakerId),
        vyuh.di
            .get<ConferenceApi>()
            .getSessions(editionId: editionId, speakerId: speakerId),
      ]),
      builder: (context, list) {
        final theme = Theme.of(context);

        final speaker = list[0] as Speaker;
        final sessions = list[1] as List<Session>;

        return ConferenceRouteCustomScrollView(
          title: 'Speaker',
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                vyuh.content.buildContent(context, speaker),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Sessions (${sessions.length})',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                ...List.generate(
                  sessions.length,
                  (index) {
                    final session = sessions[index];
                    return GestureDetector(
                      onTap: () {
                        final conferenceId = GoRouterState.of(context)
                            .pathParameters['conferenceId']!;
                        final editionId = GoRouterState.of(context)
                            .pathParameters['editionId']!;

                        vyuh.router.push(
                          '/conference/$conferenceId/editions/$editionId/sessions/${session.id}',
                        );
                      },
                      child: vyuh.content.buildContent(
                        context,
                        session,
                        layout: summaryLayout,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final class _Tracks extends StatelessWidget {
  const _Tracks({
    required this.editionId,
  });

  final String editionId;

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<List<Track>>(
      errorTitle: 'Failed to load Tracks',
      future: vyuh.di.get<ConferenceApi>().getTracks(editionId: editionId),
      builder: (context, tracks) {
        return ConferenceRouteCustomScrollView(
          title: 'Tracks',
          appBarActions: [
            IconButton(
                onPressed: () {
                  vyuh.router.go('/conference');
                },
                icon: Icon(Icons.home))
          ],
          sliver: SliverList.separated(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return GestureDetector(
                onTap: () {
                  final conferenceId =
                      GoRouterState.of(context).pathParameters['conferenceId']!;
                  final editionId =
                      GoRouterState.of(context).pathParameters['editionId']!;

                  vyuh.router.push(
                    '/conference/$conferenceId/editions/$editionId/tracks/${track.id}',
                  );
                },
                child: vyuh.content.buildContent(context, track),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
          ),
        );
      },
    );
  }
}

final class _TrackDetail extends StatelessWidget {
  final String trackId;
  final String editionId;

  const _TrackDetail({required this.trackId, required this.editionId});

  @override
  Widget build(BuildContext context) {
    final summaryLayout = SessionSummaryLayout();

    return ConferenceRouteScaffold<List>(
      errorTitle: 'Failed to load Track Details',
      future: Future.wait([
        vyuh.di.get<ConferenceApi>().getTrack(id: trackId),
        vyuh.di
            .get<ConferenceApi>()
            .getSessions(editionId: editionId, trackId: trackId),
      ]),
      builder: (context, snapshot) {
        final track = snapshot[0] as Track;
        final sessions = snapshot[1] as List<Session>;

        return ConferenceRouteCustomScrollView(
          title: track.title,
          subtitle: 'Sessions (${sessions.length})',
          sliver: SliverList.separated(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return GestureDetector(
                onTap: () {
                  final conferenceId =
                      GoRouterState.of(context).pathParameters['conferenceId']!;
                  final editionId =
                      GoRouterState.of(context).pathParameters['editionId']!;

                  vyuh.router.push(
                    '/conference/$conferenceId/editions/$editionId/sessions/${session.id}',
                  );
                },
                child: vyuh.content
                    .buildContent(context, session, layout: summaryLayout),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
          ),
        );
      },
    );
  }
}
