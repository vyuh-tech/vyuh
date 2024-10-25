import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:design_system/design_system.dart';
import 'package:feature_puzzles/ui/river_level/dialogs/dialogs.dart';
import 'package:feature_puzzles/ui/river_level/river_level_store.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final RiverLevelStore store;

  const MenuWidget({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(
        theme.spacing.s12,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MenuItem(
            icon: Icons.refresh,
            onTap: store.reset,
          ),
          MenuItem(
            icon: Icons.info,
            onTap: () => showInstructionsDialog(context, level: store.level),
          ),
          Center(
            child: StreamBuilder(
              stream: store.gameStream,
              builder: (context, snapshot) {
                return AnimatedFlipCounter(
                  value: double.tryParse(store.getScore()) ?? 0,
                  textStyle: theme.textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          MenuItem(
            icon: Icons.question_mark,
            onTap: () => showHowToPlayDialog(context),
          ),
          MenuItem(
            icon: Icons.close_sharp,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: onTap,
      icon: CircleAvatar(
        backgroundColor: theme.colorScheme.primary,
        child: Icon(
          icon,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
