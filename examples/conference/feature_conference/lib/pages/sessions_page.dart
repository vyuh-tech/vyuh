import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/session.dart';
import 'package:feature_conference/layouts/session_summary_layout.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class SessionsPage extends StatelessWidget {
  final String editionId;

  const SessionsPage({super.key, required this.editionId});

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<List<Session>>(
      errorTitle: 'Failed to load Sessions',
      future: () => vyuh.di.get<ConferenceApi>().sessions(editionId: editionId),
      builder: (context, sessions) {
        return ConferenceRouteCustomScrollView(
          title: 'Sessions',
          subtitle: '(${sessions.length})',
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final session = sessions[index];
                return VyuhBinding.instance.content.buildContent(
                  context,
                  session,
                  layout: SessionSummaryLayout(),
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
