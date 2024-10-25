import 'package:feature_puzzles/api/model/level.dart';
import 'package:feature_puzzles/ui/river_level/river_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

void main() {
  group('RiverLevelEngine', () {
    group('evaluate', () {
      late Level level;

      setUp(() {
        level = Level(
          killConditions: [
            KillCondition(
              killer: 'Wolf',
              victim: 'Sheep',
              witness: 'Farmer',
              type: KillType.absent,
            ),
            KillCondition(
              killer: 'Wolf',
              victim: 'Sheep',
              witness: 'Farmer',
              type: KillType.greater,
            ),
          ],
          killWord: 'eaten',
          title: 'Test',
          duration: 99,
          image: null,
          instructions: PortableTextContent(),
          characters: [],
        );
      });

      test('Killer should kill victim if witness is absent on top bank', () {
        // Arrange
        final charactersOnTop = [
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
        ];
        final charactersOnBottom = [Character(title: 'Farmer')];
        final charactersOnBoat = <Character>[];

        // Act
        RiverLevelEngine.evaluate(
          charactersOnTop: charactersOnTop,
          charactersOnBottom: charactersOnBottom,
          charactersOnBoat: charactersOnBoat,
          isBoatOnTop: false,
          isBoatOnBottom: true,
          level: level,
          endLevel: ({required LevelEndReason reason}) {
            // Assert
            expect(reason.message, 'Sheep was eaten by Wolf');
            expect(reason.killer?.title, 'Wolf');
            expect(reason.victim?.title, 'Sheep');
          },
        );
      });

      test('Killer should kill victim if witness is absent on bottom bank', () {
        // Arrange
        final charactersOnTop = [Character(title: 'Farmer')];
        final charactersOnBottom = [
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
        ];
        final charactersOnBoat = <Character>[];

        // Act
        RiverLevelEngine.evaluate(
          charactersOnTop: charactersOnTop,
          charactersOnBottom: charactersOnBottom,
          charactersOnBoat: charactersOnBoat,
          isBoatOnTop: true,
          isBoatOnBottom: false,
          level: level,
          endLevel: ({required LevelEndReason reason}) {
            // Assert
            expect(reason.message, 'Sheep was eaten by Wolf');
            expect(reason.killer?.title, 'Wolf');
            expect(reason.victim?.title, 'Sheep');
          },
        );
      });

      test('Killer should kill victim if killers are more on top bank', () {
        // Arrange
        final charactersOnTop = [
          Character(title: 'Wolf'),
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
        ];
        final charactersOnBottom = [Character(title: 'Farmer')];
        final charactersOnBoat = <Character>[];

        // Act
        RiverLevelEngine.evaluate(
          charactersOnTop: charactersOnTop,
          charactersOnBottom: charactersOnBottom,
          charactersOnBoat: charactersOnBoat,
          isBoatOnTop: false,
          isBoatOnBottom: true,
          level: level,
          endLevel: ({required LevelEndReason reason}) {
            // Assert
            expect(reason.message, 'Sheep was eaten by Wolf');
            expect(reason.killer?.title, 'Wolf');
            expect(reason.victim?.title, 'Sheep');
          },
        );
      });

      test('Killer should kill victim if killers are more on bottom bank', () {
        // Arrange
        final charactersOnTop = [Character(title: 'Farmer')];
        final charactersOnBottom = [
          Character(title: 'Wolf'),
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
        ];
        final charactersOnBoat = <Character>[];

        // Act
        RiverLevelEngine.evaluate(
          charactersOnTop: charactersOnTop,
          charactersOnBottom: charactersOnBottom,
          charactersOnBoat: charactersOnBoat,
          isBoatOnTop: true,
          isBoatOnBottom: false,
          level: level,
          endLevel: ({required LevelEndReason reason}) {
            // Assert
            expect(reason.message, 'Sheep was eaten by Wolf');
            expect(reason.killer?.title, 'Wolf');
            expect(reason.victim?.title, 'Sheep');
          },
        );
      });

      test(
          'Killer should not kill victim if killers are more but witness is present',
          () {
        // Arrange
        final charactersOnTop = [
          Character(title: 'Wolf'),
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
          Character(title: 'Farmer'),
        ];
        final charactersOnBottom = <Character>[];
        final charactersOnBoat = <Character>[];
        var endLevelCalled = false;

        // Act
        RiverLevelEngine.evaluate(
          charactersOnTop: charactersOnTop,
          charactersOnBottom: charactersOnBottom,
          charactersOnBoat: charactersOnBoat,
          isBoatOnTop: false,
          isBoatOnBottom: true,
          level: level,
          endLevel: ({required LevelEndReason reason}) {
            endLevelCalled = true;
          },
        );

        // Assert
        expect(endLevelCalled, false);
      });

      test('Killer should not kill if victim is absent', () {
        // Arrange
        final charactersOnTop = [
          Character(title: 'Wolf'),
          Character(title: 'Wolf'),
        ];
        final charactersOnBottom = [
          Character(title: 'Farmer'),
          Character(title: 'Sheep'),
        ];
        final charactersOnBoat = <Character>[];
        var endLevelCalled = false;

        // Act
        RiverLevelEngine.evaluate(
          charactersOnTop: charactersOnTop,
          charactersOnBottom: charactersOnBottom,
          charactersOnBoat: charactersOnBoat,
          isBoatOnTop: false,
          isBoatOnBottom: true,
          level: level,
          endLevel: ({required LevelEndReason reason}) {
            endLevelCalled = true;
          },
        );

        // Assert
        expect(endLevelCalled, false);
      });
    });

    group('evaluateEndReason', () {
      test('Should return LevelEndReason when kill condition is met', () {
        final characters = [
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
        ];
        final killCondition = KillCondition(
          killer: 'Wolf',
          victim: 'Sheep',
          witness: 'Farmer',
          type: KillType.absent,
        );

        final result = RiverLevelEngine.evaluateEndReason(
          characters: characters,
          killCondition: killCondition,
          killWord: 'eaten',
        );

        expect(result, isNotNull);
        expect(result?.message, 'Sheep was eaten by Wolf');
        expect(result?.killer?.title, 'Wolf');
        expect(result?.victim?.title, 'Sheep');
      });

      test('Should return null when kill condition is not met', () {
        final characters = [
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
          Character(title: 'Farmer'),
        ];
        final killCondition = KillCondition(
          killer: 'Wolf',
          victim: 'Sheep',
          witness: 'Farmer',
          type: KillType.absent,
        );

        final result = RiverLevelEngine.evaluateEndReason(
          characters: characters,
          killCondition: killCondition,
          killWord: 'eaten',
        );

        expect(result, isNull);
      });
    });

    group('validateKillConditions', () {
      test('Should return kill message for absent kill type', () {
        final characters = [
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
        ];
        final killCondition = KillCondition(
          killer: 'Wolf',
          victim: 'Sheep',
          witness: 'Farmer',
          type: KillType.absent,
        );

        final result = RiverLevelEngine.validateKillConditions(
          killCondition: killCondition,
          characters: characters,
          killWord: 'eaten',
        );

        expect(result, 'Sheep was eaten by Wolf');
      });

      test('Should return kill message for greater kill type', () {
        final characters = [
          Character(title: 'Wolf'),
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
        ];
        final killCondition = KillCondition(
          killer: 'Wolf',
          victim: 'Sheep',
          witness: '',
          type: KillType.greater,
        );

        final result = RiverLevelEngine.validateKillConditions(
          killCondition: killCondition,
          characters: characters,
          killWord: 'eaten',
        );

        expect(result, 'Sheep was eaten by Wolf');
      });

      test('Should return null for unknown kill type', () {
        final characters = [
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
        ];
        final killCondition = KillCondition(
          killer: 'Wolf',
          victim: 'Sheep',
          witness: '',
          type: KillType.unknown,
        );

        final result = RiverLevelEngine.validateKillConditions(
          killCondition: killCondition,
          characters: characters,
          killWord: 'eaten',
        );

        expect(result, isNull);
      });
    });

    group('absentValidator', () {
      test('Should return kill message when witness is absent', () {
        final characters = [
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
        ];
        final killCondition = KillCondition(
          killer: 'Wolf',
          victim: 'Sheep',
          witness: 'Farmer',
          type: KillType.absent,
        );

        final result = RiverLevelEngine.absentValidator(
          killCondition: killCondition,
          characters: characters,
          killWord: 'eaten',
        );

        expect(result, 'Sheep was eaten by Wolf');
      });

      test('Should return null when witness is present', () {
        final characters = [
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
          Character(title: 'Farmer'),
        ];
        final killCondition = KillCondition(
          killer: 'Wolf',
          victim: 'Sheep',
          witness: 'Farmer',
          type: KillType.absent,
        );

        final result = RiverLevelEngine.absentValidator(
          killCondition: killCondition,
          characters: characters,
          killWord: 'eaten',
        );

        expect(result, isNull);
      });
    });

    group('greaterValidator', () {
      test('Should return kill message when killers outnumber victims', () {
        final characters = [
          Character(title: 'Wolf'),
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
        ];
        final killCondition = KillCondition(
          killer: 'Wolf',
          victim: 'Sheep',
          witness: '',
          type: KillType.greater,
        );

        final result = RiverLevelEngine.greaterValidator(
          killCondition: killCondition,
          characters: characters,
          killWord: 'eaten',
        );

        expect(result, 'Sheep was eaten by Wolf');
      });

      test('Should return null when killers do not outnumber victims', () {
        final characters = [
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
          Character(title: 'Sheep'),
        ];
        final killCondition = KillCondition(
          killer: 'Wolf',
          victim: 'Sheep',
          witness: '',
          type: KillType.greater,
        );

        final result = RiverLevelEngine.greaterValidator(
          killCondition: killCondition,
          characters: characters,
          killWord: 'eaten',
        );

        expect(result, isNull);
      });

      test('Should return null when witness is present', () {
        final characters = [
          Character(title: 'Wolf'),
          Character(title: 'Wolf'),
          Character(title: 'Sheep'),
          Character(title: 'Farmer'),
        ];
        final killCondition = KillCondition(
          killer: 'Wolf',
          victim: 'Sheep',
          witness: 'Farmer',
          type: KillType.greater,
        );

        final result = RiverLevelEngine.greaterValidator(
          killCondition: killCondition,
          characters: characters,
          killWord: 'eaten',
        );

        expect(result, isNull);
      });
    });
  });
}
