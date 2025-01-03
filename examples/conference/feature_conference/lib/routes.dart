import 'package:feature_conference/pages/conference_detail_page.dart';
import 'package:feature_conference/pages/conference_root_page.dart';
import 'package:feature_conference/pages/edition_detail_page.dart';
import 'package:feature_conference/pages/edition_shell_page.dart';
import 'package:feature_conference/pages/session_detail_page.dart';
import 'package:feature_conference/pages/sessions_page.dart';
import 'package:feature_conference/pages/speaker_detail_page.dart';
import 'package:feature_conference/pages/speakers_page.dart';
import 'package:feature_conference/pages/track_detail_page.dart';
import 'package:feature_conference/pages/tracks_page.dart';
import 'package:go_router/go_router.dart';

Future<List<RouteBase>> routes() async {
  final sharedRoutes = [
    GoRoute(
      path: 'sessions/:sessionId',
      builder: (context, state) {
        final sessionId = state.pathParameters['sessionId']!;
        return SessionDetailPage(sessionId: sessionId);
      },
    ),
    GoRoute(
      path: 'speakers/:speakerId',
      builder: (context, state) {
        final speakerId = state.pathParameters['speakerId']!;
        final editionId = state.pathParameters['editionId']!;
        return SpeakerDetailPage(
          speakerId: speakerId,
          editionId: editionId,
        );
      },
    ),
    GoRoute(
      path: 'tracks/:trackId',
      builder: (context, state) {
        final trackId = state.pathParameters['trackId']!;
        final editionId = state.pathParameters['editionId']!;
        return TrackDetailPage(
          trackId: trackId,
          editionId: editionId,
        );
      },
    ),
  ];

  return [
    GoRoute(
      path: '/conferences',
      builder: (context, state) {
        return const ConferenceRootPage();
      },
    ),
    GoRoute(
      path: '/conferences/:conferenceId',
      builder: (context, state) {
        return const ConferenceDetailPage();
      },
    ),
    GoRoute(
      path: '/conferences/:conferenceId/editions/:editionId',
      redirect: (context, state) {
        final expectedSegments = ['overview', 'sessions', 'speakers', 'tracks'];

        // Potential paths will be .../[expectedSegment] OR .../[expectedSegment]/:id
        if (expectedSegments.contains(state.uri.pathSegments.last) ||
            expectedSegments.contains(state.uri.pathSegments
                .elementAt(state.uri.pathSegments.length - 2))) {
          return state.uri.toString();
        }

        final editionId = state.pathParameters['editionId']!;
        final conferenceId = state.pathParameters['conferenceId']!;

        return '/conferences/$conferenceId/editions/$editionId/overview';
      },
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return EditionShellPage(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'overview',
                  builder: (context, state) => const EditionDetailPage(),
                ),
                ...sharedRoutes,
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'sessions',
                  builder: (context, state) {
                    final editionId = state.pathParameters['editionId']!;
                    return SessionsPage(editionId: editionId);
                  },
                ),
                ...sharedRoutes,
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'speakers',
                  builder: (context, state) {
                    final editionId = state.pathParameters['editionId']!;
                    return SpeakersPage(editionId: editionId);
                  },
                ),
                ...sharedRoutes,
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'tracks',
                  builder: (context, state) {
                    final editionId = state.pathParameters['editionId']!;
                    return TracksPage(editionId: editionId);
                  },
                ),
                ...sharedRoutes,
              ],
            ),
          ],
        ),
      ],
    ),
  ];
}
