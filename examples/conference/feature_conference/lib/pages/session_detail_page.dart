import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/session.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class SessionDetailPage extends StatelessWidget {
  final String sessionId;

  const SessionDetailPage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<Session>(
      errorTitle: 'Failed to load Session',
      future: () => vyuh.di.get<ConferenceApi>().session(id: sessionId),
      builder: (context, session) {
        return ConferenceRouteCustomScrollView(
          title: 'Session',
          subtitle: session.title,
          sliver: SliverToBoxAdapter(
            child: VyuhBinding.instance.content.buildContent(context, session),
          ),
        );
      },
    );
  }
}
