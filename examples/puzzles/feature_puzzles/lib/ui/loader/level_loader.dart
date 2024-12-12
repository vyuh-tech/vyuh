import 'package:design_system/design_system.dart' as ds;
import 'package:feature_puzzles/api/model/level.dart';
import 'package:feature_puzzles/ui/widgets/puzzle_button.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vyuh_core/runtime/platform/powered_by_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';

class LevelContentLoader extends StatelessWidget {
  const LevelContentLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gap = SizedBox(height: theme.sizing.s4);

    final level = Level.empty();
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Flexible(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: theme.aspectRatio.oneToOne,
                    child: Container(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                gap,
                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                gap,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.s16,
                  ),
                  child: vyuh.content.buildContent(context, level.instructions),
                ),
                gap,
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(theme.spacing.s16),
            child: Column(
              children: [
                PuzzleButton(
                  title: "START LEVEL",
                  onTap: () {},
                ),
                gap,
                const PoweredByWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
