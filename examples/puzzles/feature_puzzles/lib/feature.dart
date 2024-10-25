import 'package:feature_puzzles/action/select_level.dart';
import 'package:feature_puzzles/api/puzzles_client.dart';
import 'package:feature_puzzles/routes.dart';
import 'package:feature_puzzles/ui/content/level_section.dart';
import 'package:feature_puzzles/ui/layout/level_layout.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

final feature = FeatureDescriptor(
  name: 'puzzles',
  title: 'Puzzles',
  description: 'A puzzle game crafted with Vyuh.',
  icon: Icons.videogame_asset,
  init: () async {
    vyuh.di.register(PuzzleClient());
  },
  routes: routes,
  extensions: [
    ContentExtensionDescriptor(
      contents: [
        RouteDescriptor(layouts: [
          LevelLayout.typeDescriptor,
        ]),
      ],
      contentBuilders: [
        ContentBuilder<LevelSection>(
          content: LevelSection.typeDescriptor,
          defaultLayout: LevelSectionLayout(),
          defaultLayoutDescriptor: LevelSectionLayout.typeDescriptor,
        ),
      ],
      actions: [
        SelectLevel.typeDescriptor,
      ],
    ),
  ],
);
