import 'package:design_system/design_system.dart' as ds;
import 'package:feature_puzzles/api/model/level.dart';
import 'package:feature_puzzles/ui/widgets/animated_heading_text.dart';
import 'package:feature_puzzles/ui/widgets/puzzle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vyuh_core/runtime/platform/powered_by_widget.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

class StartLevelWidget extends StatelessWidget {
  final Level level;
  final GestureTapCallback onStart;

  const StartLevelWidget({
    super.key,
    required this.level,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gap = SizedBox(height: theme.sizing.s4);
    return Column(
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: theme.aspectRatio.oneToOne,
                  child: Stack(
                    children: [
                      ContentImage(
                        ref: level.image,
                        fit: BoxFit.contain,
                      ).animate().slideX(),
                      gap,
                      Positioned(
                        top: theme.sizing.s10,
                        left: theme.sizing.s10,
                        child: SizedBox(
                          width: theme.sizing.s70,
                          child: AnimatedHeadingText(
                            text: level.title,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: CircleAvatar(
                              backgroundColor: theme.colorScheme.surface,
                              child: Icon(
                                Icons.close_sharp,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                  child: vyuh.content
                      .buildContent(context, level.instructions)
                      .animate()
                      .fadeIn(),
                ),
                gap,
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(theme.spacing.s16),
          child: Column(
            children: [
              PuzzleButton(
                title: "START LEVEL",
                onTap: onStart,
              ),
              gap,
              const PoweredByWidget()
            ],
          ),
        ),
      ],
    );
  }
}
