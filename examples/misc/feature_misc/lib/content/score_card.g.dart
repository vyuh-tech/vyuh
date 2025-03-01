// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      score1: (json['score1'] as num?)?.toInt() ?? 0,
      score2: (json['score2'] as num?)?.toInt() ?? 0,
    );

ScoreCard _$ScoreCardFromJson(Map<String, dynamic> json) => ScoreCard(
      player1: json['player1'] as String? ?? 'Player 1',
      player2: json['player2'] as String? ?? 'Player 2',
      games: (json['games'] as List<dynamic>?)
              ?.map((e) => Game.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      layout: typeFromFirstOfListJson(json['layout']),
      modifiers: ContentItem.modifierList(json['modifiers']),
    );

ScoreCardDefaultLayout _$ScoreCardDefaultLayoutFromJson(
        Map<String, dynamic> json) =>
    ScoreCardDefaultLayout();
