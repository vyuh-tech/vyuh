import 'package:feature_puzzles/api/model/level.dart';
import 'package:feature_puzzles/ui/river_level/dialogs/dialogs.dart';
import 'package:feature_puzzles/ui/widgets/scale_effect_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

typedef CharacterTap = void Function(
  Character character, {
  required Function(String) onError,
});

class CharacterWidget extends StatelessWidget {
  final Character character;
  final CharacterTap onTap;
  final double size;

  const CharacterWidget({
    super.key,
    required this.character,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (character.isEmpty) {
      return SizedBox.square(dimension: size);
    }
    return ScaleEffectButton(
      onTap: () => onTap(
        character,
        onError: (message) => showWarningDialog(
          context,
          message: message,
        ),
      ),
      child: SizedBox.square(
        dimension: size,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ContentImage(
            ref: character.image,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ).animate().scale(),
        ),
      ),
    );
  }
}
