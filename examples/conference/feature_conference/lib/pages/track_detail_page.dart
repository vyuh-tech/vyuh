import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/session.dart';
import 'package:feature_conference/content/track.dart';
import 'package:feature_conference/layouts/session_summary_layout.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/ui/content_image.dart';

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
        final track = await api.track(id: trackId);
        final sessions =
            await api.sessions(editionId: editionId, trackId: trackId);

        return (track!, sessions);
      },
      builder: (context, data) {
        final theme = Theme.of(context);
        final (track, sessions) = data;

        return ConferenceRouteCustomScrollView(
          title: 'Track',
          subtitle: track.title,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (track.icon != null)
                Card(
                    clipBehavior: Clip.antiAlias,
                    child:
                        ContentImage(ref: track.icon, height: 150, width: 150)),
              Text(track.title, style: theme.textTheme.headlineSmall),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Sessions (${sessions.length})',
                  style: theme.textTheme.titleMedium,
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
