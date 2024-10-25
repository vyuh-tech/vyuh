import 'package:collection/collection.dart';
import 'package:feature_puzzles/api/model/level.dart';

class RiverLevelEngine {
  static void evaluate({
    required List<Character> charactersOnTop,
    required List<Character> charactersOnBottom,
    required List<Character> charactersOnBoat,
    required bool isBoatOnTop,
    required bool isBoatOnBottom,
    required Level level,
    required void Function({required LevelEndReason reason}) endLevel,
  }) {
    for (var killCondition in level.killConditions) {
      final topCharacters = [
        ...charactersOnTop,
        if (isBoatOnTop) ...charactersOnBoat,
      ];
      final topEndReason = evaluateEndReason(
        characters: topCharacters,
        killCondition: killCondition,
        killWord: level.killWord,
      );
      if (topEndReason != null) {
        endLevel(reason: topEndReason);
        return;
      }

      final bottomCharacters = [
        ...charactersOnBottom,
        if (isBoatOnBottom) ...charactersOnBoat,
      ];
      final bottomEndReason = evaluateEndReason(
        characters: bottomCharacters,
        killCondition: killCondition,
        killWord: level.killWord,
      );
      if (bottomEndReason != null) {
        endLevel(reason: bottomEndReason);
        return;
      }
    }
  }

  static LevelEndReason? evaluateEndReason({
    required List<Character> characters,
    required KillCondition killCondition,
    required String killWord,
  }) {
    final endReason = validateKillConditions(
      characters: characters,
      killCondition: killCondition,
      killWord: killWord,
    );
    if (endReason != null) {
      final killer = characters.firstWhereOrNull(
        (element) =>
            element.title.toLowerCase() == killCondition.killer.toLowerCase(),
      );
      final victim = characters.firstWhereOrNull(
        (element) =>
            element.title.toLowerCase() == killCondition.victim.toLowerCase(),
      );
      return LevelEndReason(
        endReason,
        killer: killer,
        victim: victim,
      );
    }
    return null;
  }

  static String? validateKillConditions({
    required KillCondition killCondition,
    required List<Character> characters,
    required String killWord,
  }) {
    switch (killCondition.type) {
      case KillType.absent:
        return absentValidator(
          killCondition: killCondition,
          characters: characters,
          killWord: killWord,
        );
      case KillType.greater:
        return greaterValidator(
          killCondition: killCondition,
          characters: characters,
          killWord: killWord,
        );
      default:
        return null;
    }
  }

  static String? absentValidator({
    required KillCondition killCondition,
    required List<Character> characters,
    required String killWord,
  }) {
    final killer = characters.firstWhereOrNull(
      (character) =>
          character.title.toLowerCase() == killCondition.killer.toLowerCase(),
    );
    final victim = characters.firstWhereOrNull(
      (character) =>
          character.title.toLowerCase() == killCondition.victim.toLowerCase(),
    );
    final witness = characters.firstWhereOrNull(
      (character) =>
          character.title.toLowerCase() == killCondition.witness.toLowerCase(),
    );
    if (killer != null && victim != null && witness == null) {
      return '${victim.title} was $killWord by ${killer.title}';
    }

    return null;
  }

  static String? greaterValidator({
    required KillCondition killCondition,
    required List<Character> characters,
    required String killWord,
  }) {
    final killers = characters.where(
      (character) =>
          character.title.toLowerCase() == killCondition.killer.toLowerCase(),
    );
    final victims = characters.where(
      (character) =>
          character.title.toLowerCase() == killCondition.victim.toLowerCase(),
    );

    if (killers.length > victims.length && victims.isNotEmpty) {
      if (killCondition.witness.isNotEmpty) {
        final witness = characters.firstWhereOrNull(
          (character) =>
              character.title.toLowerCase() ==
              killCondition.witness.toLowerCase(),
        );
        if (witness == null) {
          return '${killCondition.victim} was $killWord by ${killCondition.killer}';
        }
        return null;
      }
      return '${killCondition.victim} was $killWord by ${killCondition.killer}';
    }

    return null;
  }
}
