import 'package:confetti/confetti.dart';
import 'package:feature_puzzles/api/model/level.dart';
import 'package:feature_puzzles/ui/river_level/dialogs/dialogs.dart';
import 'package:feature_puzzles/ui/river_level/river_level_store.dart';
import 'package:feature_puzzles/ui/river_level/widgets/level_play_widget.dart';
import 'package:feature_puzzles/ui/river_level/widgets/menu_widget.dart';
import 'package:feature_puzzles/ui/river_level/widgets/start_level_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class RiverLevel extends StatefulWidget {
  const RiverLevel({super.key, required this.level});

  final Level level;

  @override
  State<RiverLevel> createState() => _RiverLevelState();
}

class _RiverLevelState extends State<RiverLevel> {
  late RiverLevelStore store;
  late ReactionDisposer _disposeReaction;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    store = RiverLevelStore(level: widget.level)..init();
    _disposeReaction = reaction(
      (_) => store.levelEndReason.value,
      (final reason) {
        if (reason != null) {
          if (reason.won) {
            showWinDialog(
              context,
              confettiController: _confettiController,
              onPlayAgain: store.reset,
              score: store.getScore(),
            );
          } else {
            showLoseDialog(
              context,
              reason: reason,
              onPlayAgain: store.reset,
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _disposeReaction();
    _confettiController.dispose();
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final isStarted = store.isStarted;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: isStarted
            ? Column(
                children: [
                  Flexible(
                    child: LevelPlayWidget(
                      store: store,
                    ),
                  ),
                  MenuWidget(store: store),
                ],
              )
            : StartLevelWidget(
                level: widget.level,
                onStart: store.startLevel,
              ),
      );
    });
  }
}
