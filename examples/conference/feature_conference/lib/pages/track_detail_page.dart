import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/session.dart';
import 'package:feature_conference/content/track.dart';
import 'package:feature_conference/layouts/session_summary_layout.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class TrackDetailPage extends StatelessWidget {
  final String trackId;
  final String editionId;

  const TrackDetailPage({
    super.key,
    required this.trackId,
    required this.editionId,
  });

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<(Track, List<Session>)>(
      errorTitle: 'Failed to load Track',
      future: () async {
        final api = vyuh.di.get<ConferenceApi>();
        final track = await api.getTrack(id: trackId);
        final sessions =
            await api.getSessions(editionId: editionId, trackId: trackId);

        return (track!, sessions);
      },
      builder: (context, data) {
        final (track, sessions) = data;

        return ConferenceRouteCustomScrollView(
          title: track.title,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              vyuh.content.buildContent(context, track),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Sessions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...sessions.map(
                (session) => vyuh.content.buildContent(
                  context,
                  session,
                  layout: SessionSummaryLayout(),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
