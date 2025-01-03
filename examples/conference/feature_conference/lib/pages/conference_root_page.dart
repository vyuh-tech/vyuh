import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/conference.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class ConferenceRootPage extends StatelessWidget {
  const ConferenceRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<List<Conference>>(
      errorTitle: 'Failed to load Conferences',
      future: () => vyuh.di.get<ConferenceApi>().getConferences(),
      builder: (context, conferences) {
        return ConferenceRouteCustomScrollView(
          title: 'Conferences',
          appBarActions: [
            IconButton(
                onPressed: () {
                  vyuh.router.go('/chakra');
                },
                icon: Icon(Icons.home))
          ],
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
