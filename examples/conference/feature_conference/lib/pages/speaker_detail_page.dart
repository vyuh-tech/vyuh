import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/session.dart';
import 'package:feature_conference/content/speaker.dart';
import 'package:feature_conference/layouts/session_summary_layout.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class SpeakerDetailPage extends StatelessWidget {
  final String speakerId;
  final String editionId;

  const SpeakerDetailPage({
    super.key,
    required this.speakerId,
    required this.editionId,
  });

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<(Speaker, List<Session>)>(
      errorTitle: 'Failed to load Speaker',
      future: () async {
        final api = vyuh.di.get<ConferenceApi>();
        final speaker = await api.getSpeaker(id: speakerId);
        final sessions =
            await api.getSessions(editionId: editionId, speakerId: speakerId);

        return (speaker!, sessions);
      },
      builder: (context, data) {
        final (speaker, sessions) = data;

        return ConferenceRouteCustomScrollView(
          title: 'Speaker',
          subtitle: speaker.name,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              vyuh.content.buildContent(context, speaker),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Sessions (${sessions.length})',
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
