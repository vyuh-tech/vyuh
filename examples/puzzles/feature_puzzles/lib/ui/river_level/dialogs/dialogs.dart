import 'package:confetti/confetti.dart';
import 'package:design_system/design_system.dart' as ds;
import 'package:feature_puzzles/api/model/level.dart';
import 'package:feature_puzzles/routes.dart';
import 'package:feature_puzzles/ui/river_level/widgets/character_widget.dart';
import 'package:feature_puzzles/ui/widgets/animated_heading_text.dart';
import 'package:feature_puzzles/ui/widgets/puzzle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vyuh_core/vyuh_core.dart';

void showWinDialog(
  BuildContext context, {
  required final ConfettiController confettiController,
  required VoidCallback onPlayAgain,
  required String score,
}) {
  showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        title: Text(
          'CONGRATULATIONS!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedHeadingText(
              text: 'SCORE: $score',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: theme.spacing.s16),
            const Text('YOU HAVE WON THE LEVEL!'),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: confettiController..play(),
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Colors.red,
                ],
                numberOfParticles: 100,
                maxBlastForce: 100,
              ),
            ),
          ],
        ),
        actions: [
          PuzzleButton(
            onTap: () {
              Navigator.of(context).pop();
              onPlayAgain();
            },
            title: 'PLAY AGAIN',
          ),
          SizedBox(height: theme.spacing.s8),
          PuzzleButton(
            onTap: () {
              Navigator.of(context).popUntil(
                ModalRoute.withName(PuzzlesPath.puzzles),
              );
            },
            title: 'NEXT',
            color: theme.colorScheme.secondary,
          ),
        ],
      );
    },
  );
}

void showWarningDialog(
  BuildContext context, {
  required final String message,
}) {
  showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        title: Text(
          'WARNING',
          style: theme.textTheme.headlineSmall,
        ),
        content: Text(
          message.toUpperCase(),
          style: theme.textTheme.bodyLarge,
        ),
        actions: [
          PuzzleButton(
            color: Colors.orange,
            onTap: () {
              Navigator.of(context).pop();
            },
            title: 'OKAY',
          ),
        ],
      );
    },
  );
}

void showLoseDialog(
  BuildContext context, {
  required LevelEndReason reason,
  required VoidCallback onPlayAgain,
}) {
  showDialog(
    context: context,
    barrierColor:
        Theme.of(context).colorScheme.onErrorContainer.withValues(alpha: 0.5),
    builder: (context) {
      final theme = Theme.of(context);
      return AlertDialog(
        title: Text(
          'GAME OVER',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reason.hasCharacters) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CharacterWidget(
                    character: reason.victim!,
                    size: theme.sizing.s28,
                    onTap: (_, {required onError}) {},
                  ),
                  CharacterWidget(
                    character: reason.killer!,
                    size: theme.sizing.s28,
                    onTap: (_, {required onError}) {},
                  ),
                ],
              ),
            ],
            Text(
              reason.message.toUpperCase(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          PuzzleButton(
            onTap: () {
              Navigator.of(context).pop();
              onPlayAgain();
            },
            title: 'PLAY AGAIN',
          ),
        ],
      );
    },
  );
}

void showInstructionsDialog(
  BuildContext context, {
  required Level level,
}) {
  showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        title: Text(
          'INSTRUCTIONS',
          style: theme.textTheme.headlineSmall,
        ),
        content: AspectRatio(
          aspectRatio: theme.aspectRatio.oneToOne,
          child: Column(
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: vyuh.content
                      .buildContent(context, level.instructions)
                      .animate()
                      .move(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          PuzzleButton(
            onTap: () {
              Navigator.of(context).pop();
            },
            title: 'CLOSE',
          ),
        ],
      );
    },
  );
}

void showHowToPlayDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        title: Text(
          'HOW TO PLAY',
          style: theme.textTheme.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '1. Tap on the character to move it.',
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: theme.spacing.s8),
            Text(
              '2. The boat can carry only two characters at a time.',
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: theme.spacing.s8),
            Text(
              '3. To move the boat, tap on the water.',
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: theme.spacing.s8),
            Text(
              '4. The game ends when time runs out.',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
        actions: [
          PuzzleButton(
            onTap: () {
              Navigator.of(context).pop();
            },
            title: 'CLOSE',
          ),
        ],
      );
    },
  );
}
