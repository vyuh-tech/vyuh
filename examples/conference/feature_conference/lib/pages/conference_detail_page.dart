import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/edition.dart';
import 'package:feature_conference/layouts/edition_summary_layout.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class ConferenceDetailPage extends StatelessWidget {
  const ConferenceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final identifier = GoRouterState.of(context).pathParameters['conferenceId']!;
    final editionLayout = EditionSummaryLayout();

    return ConferenceRouteScaffold<List<Edition>>(
      errorTitle: 'Failed to load Editions',
      future: () =>
          vyuh.di.get<ConferenceApi>().editions(conferenceId: identifier),
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
