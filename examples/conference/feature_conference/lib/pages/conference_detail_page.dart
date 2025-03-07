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

    return ConferenceRouteScaffold<(Conference?, List<Edition>)>(
      errorTitle: 'Failed to load Editions',
      future: () async {
        final getConference =
            vyuh.di.get<ConferenceApi>().conference(conferenceId: conferenceId);
        final getEditions =
            vyuh.di.get<ConferenceApi>().editions(conferenceId: conferenceId);

        final (conference, editions) = await (getConference, getEditions).wait;

        return (conference, editions);
      },
      builder: (context, data) {
        final theme = Theme.of(context);
        final (conference, editions) = data;

        return ConferenceRouteCustomScrollView(
          title: 'Conference',
          subtitle: conference?.title,
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                if (conference != null)
                  VyuhBinding.instance.content.buildContent(context, conference)
                else
                  Text('No conference found with id: $conferenceId'),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Editions (${editions.length})',
                      style: theme.textTheme.titleLarge),
                ),
                for (final edition in editions)
                  VyuhBinding.instance.content.buildContent(
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
