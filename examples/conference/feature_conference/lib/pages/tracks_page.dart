import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/track.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class TracksPage extends StatelessWidget {
  final String editionId;

  const TracksPage({super.key, required this.editionId});

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<List<Track>>(
      errorTitle: 'Failed to load Tracks',
      future: () => vyuh.di.get<ConferenceApi>().tracks(editionId: editionId),
      builder: (context, tracks) {
        return ConferenceRouteCustomScrollView(
          title: 'Tracks',
          subtitle: '(${tracks.length})',
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final track = tracks[index];
                return VyuhBinding.instance.content
                    .buildContent(context, track);
              },
              childCount: tracks.length,
            ),
          ),
        );
      },
    );
  }
}
