import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_developer/components/sticky_section.dart';
import 'package:vyuh_feature_developer/feature_detail.dart';
import 'package:vyuh_feature_developer/plugin_detail.dart';

class PluginAndFeatureList extends StatelessWidget {
  const PluginAndFeatureList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final features = vyuh.features;
    final plugins = vyuh.plugins;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Developer'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            StickySection(
                title: 'Plugins [${plugins.length}]',
                sliver: SliverList.builder(
                  itemBuilder: (_, index) => plugins[index].build(context),
                  itemCount: plugins.length,
                )),
            StickySection(
              title: 'Features [${features.length}]',
              sliver: SliverList.builder(
                itemBuilder: (_, index) =>
                    FeatureItem(feature: features[index]),
                itemCount: features.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
