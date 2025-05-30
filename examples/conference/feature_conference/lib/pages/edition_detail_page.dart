import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/content/edition.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

final class EditionDetailPage extends StatelessWidget {
  const EditionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final identifier = GoRouterState.of(context).pathParameters['editionId']!;

    return ConferenceRouteScaffold<Edition>(
      errorTitle: 'Failed to load Edition',
      future: () => vyuh.di.get<ConferenceApi>().edition(id: identifier),
      builder: (context, edition) {
        final theme = Theme.of(context);

        return ConferenceRouteCustomScrollView(
          title: 'Edition',
          subtitle: edition.title,
          appBarActions: [
            IconButton(
              icon: Icon(Icons.home, color: theme.colorScheme.onPrimary),
              onPressed: () => context.go('/conferences'),
            ),
          ],
          sliver: SliverToBoxAdapter(
            child: VyuhBinding.instance.content.buildContent(context, edition),
          ),
        );
      },
    );
  }
}
