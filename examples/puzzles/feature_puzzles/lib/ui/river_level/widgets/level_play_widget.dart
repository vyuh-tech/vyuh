import 'package:feature_puzzles/ui/river_level/dialogs/dialogs.dart';
import 'package:feature_puzzles/ui/river_level/river_level_store.dart';
import 'package:feature_puzzles/ui/river_level/widgets/boat_widget.dart';
import 'package:feature_puzzles/ui/river_level/widgets/character_widget.dart';
import 'package:feature_puzzles/ui/river_level/widgets/ground_widget.dart';
import 'package:feature_puzzles/ui/river_level/widgets/river_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LevelPlayWidget extends StatelessWidget {
  const LevelPlayWidget({
    super.key,
    required this.store,
  });

  final RiverLevelStore store;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalCharacter = store.level.characters.length;
      final factor = constraints.maxWidth <= constraints.maxHeight
          ? constraints.maxWidth
          : constraints.maxHeight;
      final heightFactor = factor == constraints.maxWidth
          ? constraints.maxHeight
          : constraints.maxWidth;
      final characterSize = factor / totalCharacter;
      final groundFactor = heightFactor * 0.2;
      final boatFactor = heightFactor - (groundFactor * boatCapacity);
      final groundAspectRatio = factor / groundFactor;
      final boatAspectRatio = factor / boatFactor;

      return Column(
        children: [
          GroundWidget(
            aspectRatio: groundAspectRatio,
            itemCount: totalCharacter,
            itemBuilder: (context, index) => Observer(builder: (context) {
              final character = store.charactersOnTop[index];
              return CharacterWidget(
                character: character,
                size: characterSize,
                onTap: store.moveCharacter,
              );
            }),
          ),
          RiverWidget(
            aspectRatio: boatAspectRatio,
            onTap: () => store.moveBoat(
              onError: (message) => showWarningDialog(
                context,
                message: message,
              ),
            ),
            child: Observer(builder: (context) {
              final alignment = store.boatAlignment.value;
              return AnimatedAlign(
                duration: interval,
                alignment: alignment,
                child: BoatWidget(
                  itemCount: boatCapacity,
                  constraints: BoxConstraints(
                    maxWidth: characterSize,
                    maxHeight: characterSize * boatCapacity,
                  ),
                  itemBuilder: (context, index) => Observer(builder: (context) {
                    final character = store.charactersOnBoat[index];
                    return CharacterWidget(
                      character: character,
                      size: characterSize,
                      onTap: store.moveCharacter,
                    );
                  }),
                ),
              );
            }),
          ),
          GroundWidget(
            quarterTurns: 2,
            aspectRatio: groundAspectRatio,
            itemCount: totalCharacter,
            itemBuilder: (context, index) => Observer(builder: (context) {
              final character = store.charactersOnBottom[index];
              return CharacterWidget(
                character: character,
                size: characterSize,
                onTap: store.moveCharacter,
              );
            }),
          ),
        ],
      );
    });
  }
}
