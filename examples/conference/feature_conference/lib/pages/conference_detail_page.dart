import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/conference.dart';
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
    final conferenceId =
        GoRouterState.of(context).pathParameters['conferenceId']!;
    final editionLayout = EditionSummaryLayout();

    return ConferenceRouteScaffold<(Conference, List<Edition>)>(
      errorTitle: 'Failed to load Editions',
      future: () async {
        final [conference as Conference, editions as List<Edition>] =
            await Future.wait([
          vyuh.di.get<ConferenceApi>().conference(conferenceId: conferenceId),
          vyuh.di.get<ConferenceApi>().editions(conferenceId: conferenceId),
        ]);

        return (conference, editions);
      },
      builder: (context, data) {
        final theme = Theme.of(context);
        final (conference, editions) = data;

        return ConferenceRouteCustomScrollView(
          title: 'Conference',
          subtitle: conference.title,
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                vyuh.content.buildContent(context, conference),
                Text('Editions (${editions.length})',
                    style: theme.textTheme.titleMedium),
                for (final edition in editions)
                  vyuh.content.buildContent(
                    context,
                    edition,
                    layout: editionLayout,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
