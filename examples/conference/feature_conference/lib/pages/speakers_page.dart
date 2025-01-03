import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/speaker.dart';
import 'package:feature_conference/layouts/speaker_layout.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class SpeakersPage extends StatelessWidget {
  final String editionId;

  const SpeakersPage({super.key, required this.editionId});

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<List<Speaker>>(
      errorTitle: 'Failed to load Speakers',
      future: () =>
          vyuh.di.get<ConferenceApi>().speakers(editionId: editionId),
      builder: (context, speakers) {
        return ConferenceRouteCustomScrollView(
          title: 'Speakers',
          subtitle: '(${speakers.length})',
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final speaker = speakers[index];
                return vyuh.content.buildContent(
                  context,
                  speaker,
                  layout: SpeakerProfileCardLayout(),
                );
              },
              childCount: speakers.length,
            ),
          ),
        );
      },
    );
  }
}
