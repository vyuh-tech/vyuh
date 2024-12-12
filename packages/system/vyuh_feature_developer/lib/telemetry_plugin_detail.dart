import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_developer/components/standard_plugin_view.dart';
import 'package:vyuh_feature_developer/components/sticky_section.dart';

class TelemetryPluginDetail extends StatelessWidget {
  final TelemetryPlugin plugin;

  const TelemetryPluginDetail({super.key, required this.plugin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(plugin.title),
              pinned: true,
              primary: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StandardPluginItem(plugin: plugin)),
            ),
            StickySection(
              title: 'Providers [${plugin.providers.length}]',
              sliver: SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverList.list(
                  children: [
                    for (final provider in plugin.providers)
                      _TelemetryProviderDetail(provider: provider, index: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TelemetryProviderDetail extends StatelessWidget {
  final int index;

  final TelemetryProvider provider;

  const _TelemetryProviderDetail({
    required this.provider,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          provider.name,
          style: theme.textTheme.labelMedium?.apply(color: theme.disabledColor),
        ),
        Text(
          provider.title,
          style: theme.textTheme.bodyMedium?.apply(fontWeightDelta: 2),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(provider.description),
        ),
        const SizedBox(height: 8),
        Text('${provider.runtimeType}'),
        const SizedBox(height: 8),
        Text(
          'Observers:',
          style: theme.textTheme.bodyMedium?.apply(fontWeightDelta: 2),
        ),
        ...provider.observers.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(e.runtimeType.toString()),
            )),
      ],
    );
  }
}
