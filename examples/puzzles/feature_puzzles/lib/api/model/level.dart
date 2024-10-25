import 'package:equatable/equatable.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart';

part 'level.g.dart';

class LevelEndReason {
  final Character? killer;
  final Character? victim;
  final String message;
  final bool won;

  LevelEndReason(
    this.message, {
    this.killer,
    this.victim,
    this.won = false,
  });

  bool get hasCharacters => killer != null && victim != null;
}

@JsonSerializable()
class Character extends Equatable {
  @JsonKey(name: '_key')
  final String id;
  final String title;
  final ImageReference? image;
  final bool canSail;

  bool get isEmpty => title.isEmpty;

  bool get isNotEmpty => title.isNotEmpty;

  Character({
    String? id,
    required this.title,
    this.canSail = true,
    this.image,
  }) : id = id ?? const Uuid().v4();

  factory Character.empty() => Character(title: '');

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  @override
  List<Object?> get props => [
        id,
        title.toLowerCase(),
      ];

  @override
  String toString() => 'Character:${toJson()}';
}

enum KillType {
  absent,
  greater,
  unknown,
}

@JsonSerializable()
class KillCondition {
  final KillType type;
  @JsonKey(defaultValue: '')
  final String witness;

  final String killer;
  final String victim;

  KillCondition({
    required this.type,
    required this.witness,
    required this.killer,
    required this.victim,
  });

  factory KillCondition.fromJson(Map<String, dynamic> json) =>
      _$KillConditionFromJson(json);

  Map<String, dynamic> toJson() => _$KillConditionToJson(this);

  @override
  String toString() => 'KillCondition:${toJson()}';
}

@JsonSerializable()
class Level {
  final String title;
  @JsonKey(defaultValue: 99)
  final int duration;
  final ImageReference? image;
  final PortableTextContent instructions;
  final List<Character> characters;
  final List<KillCondition> killConditions;
  final String killWord;

  Level({
    required this.title,
    required this.duration,
    required this.image,
    required this.instructions,
    required this.characters,
    required this.killConditions,
    required this.killWord,
  });

  factory Level.empty() => Level(
        title: '',
        duration: 99,
        image: null,
        instructions: PortableTextContent(
          blocks: List.generate(
            4,
            (index) => TextBlockItem(
              children: [
                Span(
                  text: 'empty ' * 10,
                  marks: [],
                ),
              ],
            ),
          ),
        ),
        characters: [],
        killConditions: [],
        killWord: '',
      );

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);

  Map<String, dynamic> toJson() => _$LevelToJson(this);

  @override
  String toString() => 'Level:${toJson()}';
}
