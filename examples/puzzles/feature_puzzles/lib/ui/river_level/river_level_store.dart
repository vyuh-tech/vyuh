import 'dart:async';

import 'package:feature_puzzles/api/model/level.dart';
import 'package:feature_puzzles/ui/river_level/river_engine.dart';
import 'package:feature_puzzles/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

const int boatCapacity = 2;
const int boatSpeed = 300; //ms
const Duration interval = Duration(milliseconds: boatSpeed);

class RiverLevelStore {
  final Level level;

  RiverLevelStore({required this.level}) {
    gameStream.listen(_gameListener);
  }

  final ObservableList<Character> charactersOnTop = ObservableList<Character>();
  final ObservableList<Character> charactersOnBottom =
      ObservableList<Character>();
  final ObservableList<Character> charactersOnBoat =
      ObservableList<Character>();
  final Observable<AlignmentGeometry> boatAlignment =
      Observable(Alignment.topCenter);

  final Observable<LevelEndReason?> levelEndReason = Observable(null);

  late final Observable<DateTime?> startTime = Observable(null);
  late final Observable<DateTime?> endTime = Observable(null);

  final StreamController<int> _gameStreamController =
      StreamController<int>.broadcast();

  Stream<int> get gameStream => _gameStreamController.stream;

  bool get isStarted => startTime.value != null;

  bool get isEnded => endTime.value != null;

  bool get isBoatOnTop => boatAlignment.value == Alignment.topCenter;

  bool get isBoatOnBottom => boatAlignment.value == Alignment.bottomCenter;

  bool get isBoatEmpty =>
      charactersOnBoat.where((element) => element.isNotEmpty).isEmpty;

  bool get isBoatFull =>
      charactersOnBoat.where((element) => element.isNotEmpty).length ==
      boatCapacity;

  void init() {
    runInAction(() {
      charactersOnTop.addAll(level.characters);
      charactersOnBottom.addAll(
        List.generate(level.characters.length, (index) {
          return Character.empty();
        }),
      );
      charactersOnBoat.addAll(
        List.generate(boatCapacity, (index) {
          return Character.empty();
        }),
      );
    });
  }

  void _gameListener(event) {
    if (isEnded) {
      debugPrint('Game ended');
      return;
    }
    int score = _calculateScore();
    if (score <= 0 && !isEnded && isStarted) {
      endLevel(
        reason: LevelEndReason('You ran out of time!'),
      );
      return;
    }
  }

  void startLevel() {
    runInAction(() {
      startTime.value = DateTime.now();
      _startGameStream();
    });
  }

  void _startGameStream() {
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if (!isStarted || isEnded) {
        timer.cancel();
      } else {
        if (!_gameStreamController.isClosed) {
          _gameStreamController.add(timer.tick);
        }
      }
    });
  }

  void endLevel({
    required LevelEndReason reason,
  }) {
    runInAction(() {
      endTime.value = DateTime.now();
      levelEndReason.value = LevelEndReason(
        reason.message,
        killer: reason.killer,
        victim: reason.victim,
        won: reason.won,
      );
    });
  }

  void _evaluateWin() {
    final characters =
        charactersOnBottom.where((element) => element.isNotEmpty);
    if (characters.length == level.characters.length) {
      endLevel(
        reason: LevelEndReason(
          'You win!',
          won: true,
        ),
      );
    }
  }

  String getScore() {
    int score = _calculateScore();
    return score.toTwoDigits;
  }

  int _calculateScore() {
    if (startTime.value == null) {
      return 0;
    }
    Duration duration;
    if (endTime.value == null) {
      duration = DateTime.now().difference(startTime.value!);
    } else {
      duration = endTime.value!.difference(startTime.value!);
    }
    int score = level.duration - duration.inSeconds;
    return score;
  }

  void moveBoat({required Function(String) onError}) {
    if (!isStarted) {
      onError('Please start the game first!');
      return;
    }
    if (isEnded) {
      onError('Please re-start the game!');
      return;
    }
    if (isBoatEmpty) {
      onError('No one is on the boat');
      return;
    }
    final canSail = charactersOnBoat
        .any((element) => element.canSail && element.isNotEmpty);
    if (!canSail) {
      final sailors = level.characters
          .where(
            (element) => element.canSail,
          )
          .map((e) => e.title)
          .join(' or ');
      final characters = charactersOnBoat
          .where((element) => element.isNotEmpty)
          .map((e) => e.title)
          .join(', ');
      onError('$characters cannot sail the boat without $sailors');
      return;
    }

    runInAction(() {
      if (isBoatOnTop) {
        boatAlignment.value = Alignment.bottomCenter;
      } else {
        boatAlignment.value = Alignment.topCenter;
      }
    });
    RiverLevelEngine.evaluate(
      charactersOnTop: charactersOnTop,
      charactersOnBottom: charactersOnBottom,
      charactersOnBoat: charactersOnBoat,
      isBoatOnTop: isBoatOnTop,
      isBoatOnBottom: isBoatOnBottom,
      level: level,
      endLevel: endLevel,
    );
  }

  void moveCharacter(
    Character character, {
    required Function(String) onError,
  }) {
    if (!isStarted) {
      onError('Please start the game first!');
      return;
    }
    if (isEnded) {
      onError('Please re-start the game!');
      return;
    }
    if (character.isEmpty) {
      debugPrint('Empty character');
      return;
    }
    runInAction(() {
      if (charactersOnBoat.contains(character)) {
        final index = charactersOnBoat.indexOf(character);
        charactersOnBoat[index] = Character.empty();
        if (isBoatOnTop) {
          final firstEmpty = charactersOnTop.firstWhere(
            (element) => element.isEmpty,
          );
          final emptyIndex = charactersOnTop.indexOf(firstEmpty);
          charactersOnTop[emptyIndex] = character;
        } else {
          final firstEmpty = charactersOnBottom.firstWhere(
            (element) => element.isEmpty,
          );
          final emptyIndex = charactersOnBottom.indexOf(firstEmpty);
          charactersOnBottom[emptyIndex] = character;
        }
      } else {
        if (isBoatFull) {
          onError('Boat is full!');
          return;
        }
        if (charactersOnTop.contains(character) && isBoatOnTop) {
          final index = charactersOnTop.indexOf(character);
          final firstEmpty = charactersOnBoat.firstWhere(
            (element) => element.isEmpty,
          );
          final emptyIndex = charactersOnBoat.indexOf(firstEmpty);
          charactersOnBoat[emptyIndex] = character;
          charactersOnTop[index] = Character.empty();
        } else if (charactersOnBottom.contains(character) && isBoatOnBottom) {
          final index = charactersOnBottom.indexOf(character);
          final firstEmpty = charactersOnBoat.firstWhere(
            (element) => element.isEmpty,
          );
          final emptyIndex = charactersOnBoat.indexOf(firstEmpty);
          charactersOnBoat[emptyIndex] = character;
          charactersOnBottom[index] = Character.empty();
        } else {
          onError('Invalid move!');
        }
      }
    });
    _evaluateWin();
  }

  void reset() {
    runInAction(() {
      charactersOnTop.clear();
      charactersOnBottom.clear();
      charactersOnBoat.clear();
      charactersOnTop.addAll(level.characters);
      charactersOnBottom.addAll(
        List.generate(level.characters.length, (index) {
          return Character.empty();
        }),
      );
      charactersOnBoat.addAll(
        List.generate(boatCapacity, (index) {
          return Character.empty();
        }),
      );
      boatAlignment.value = Alignment.topCenter;
      startTime.value = null;
      endTime.value = null;
      levelEndReason.value = null;
    });
  }

  void dispose() {
    _gameStreamController.close();
  }
}
