import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'score_card.g.dart';

/// Represents a game score between two players
@JsonSerializable()
final class Game {
  final int score1;
  final int score2;

  Game({
    this.score1 = 0,
    this.score2 = 0,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  /// Determines if player 1 is the winner of this game
  /// A player wins when they have at least 11 points and a 2-point lead
  bool get isPlayer1Winner {
    if (score1 < 11 && score2 < 11) return false;
    return score1 >= 11 && (score1 - score2) >= 2;
  }

  /// Determines if player 2 is the winner of this game
  /// A player wins when they have at least 11 points and a 2-point lead
  bool get isPlayer2Winner {
    if (score1 < 11 && score2 < 11) return false;
    return score2 >= 11 && (score2 - score1) >= 2;
  }

  /// Determines if this game has a valid winner
  bool get hasWinner => isPlayer1Winner || isPlayer2Winner;
}

/// ScoreCard content item representing a match between two players with game scores
@JsonSerializable()
final class ScoreCard extends ContentItem {
  static const schemaName = 'misc.content.scoreCard';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Score Card',
    fromJson: ScoreCard.fromJson,
  );

  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayout: ScoreCardDefaultLayout(),
    defaultLayoutDescriptor: ScoreCardDefaultLayout.typeDescriptor,
  );

  final String player1;
  final String player2;
  final List<Game> games;

  ScoreCard({
    this.player1 = 'Player 1',
    this.player2 = 'Player 2',
    this.games = const [],
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory ScoreCard.fromJson(Map<String, dynamic> json) =>
      _$ScoreCardFromJson(json);
}

/// Default layout for the ScoreCard content item
@JsonSerializable()
final class ScoreCardDefaultLayout extends LayoutConfiguration<ScoreCard> {
  static const schemaName = '${ScoreCard.schemaName}.layout.default';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    fromJson: ScoreCardDefaultLayout.fromJson,
    title: 'Score Card Default Layout',
  );

  ScoreCardDefaultLayout() : super(schemaType: schemaName);

  factory ScoreCardDefaultLayout.fromJson(Map<String, dynamic> json) =>
      _$ScoreCardDefaultLayoutFromJson(json);

  @override
  Widget build(BuildContext context, ScoreCard content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ScoreCardHeader(
            player1: content.player1,
            player2: content.player2,
          ),
          Expanded(
              child: content.games.isNotEmpty
                  ? _ScoreCardGames(
                      games: content.games,
                      player1: content.player1,
                      player2: content.player2,
                    )
                  : const _EmptyGamesPlaceholder()),
          _ScoreCardFooter(
            games: content.games,
            player1: content.player1,
            player2: content.player2,
          ),
        ],
      ),
    );
  }
}

/// Header component showing the match title with player names
class _ScoreCardHeader extends StatelessWidget {
  final String player1;
  final String player2;

  const _ScoreCardHeader({
    required this.player1,
    required this.player2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              player1,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const _VersusLabel(),
          Expanded(
            child: Text(
              player2,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// VS label shown between player names
class _VersusLabel extends StatelessWidget {
  const _VersusLabel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'VS',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// Component to display when no games are recorded
class _EmptyGamesPlaceholder extends StatelessWidget {
  const _EmptyGamesPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          'No games recorded',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }
}

/// Component to display game scores
class _ScoreCardGames extends StatelessWidget {
  final List<Game> games;
  final String player1;
  final String player2;

  const _ScoreCardGames({
    required this.games,
    required this.player1,
    required this.player2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        verticalInside: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        bottom: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const FixedColumnWidth(50), // Player column
        for (int i = 0; i < 7; i++) i + 1: const FlexColumnWidth(1),
      },
      children: [
        // Game labels row
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
          ),
          children: [
            // Empty cell for player column
            const TableCell(child: SizedBox()),

            // Game number cells - always show 7 games
            for (int i = 0; i < 7; i++)
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'G${i + 1}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),

        // Player 1 row
        _buildPlayerRow(
          context,
          playerName: player1,
          playerColor: Colors.red,
          isWinnerFunction: (game) => game.isPlayer1Winner,
          getScoreFunction: (game) => game.score1,
        ),

        // Player 2 row
        _buildPlayerRow(
          context,
          playerName: player2,
          playerColor: Colors.blue,
          isWinnerFunction: (game) => game.isPlayer2Winner,
          getScoreFunction: (game) => game.score2,
        ),
      ],
    );
  }

  TableRow _buildPlayerRow(
    BuildContext context, {
    required String playerName,
    required Color playerColor,
    required bool Function(Game) isWinnerFunction,
    required int Function(Game) getScoreFunction,
  }) {
    final theme = Theme.of(context);

    // Always create a list of 7 games, filling with actual games or empty ones
    final List<Game> gamesList = List.generate(7, (index) {
      if (index < games.length) {
        return games[index];
      } else {
        return Game(); // Empty game
      }
    });

    return TableRow(
      children: [
        // Player name cell
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: playerColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  playerName
                      .split(' ')
                      .map((name) => name.isNotEmpty ? name[0] : '')
                      .take(2)
                      .join()
                      .toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),

        // Score cells for player - always show 7 games
        for (int i = 0; i < 7; i++)
          TableCell(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: i < games.length && isWinnerFunction(gamesList[i])
                  ? playerColor.withValues(alpha: 0.1)
                  : null,
              child: Text(
                i < games.length ? '${getScoreFunction(gamesList[i])}' : '',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: i < games.length && isWinnerFunction(gamesList[i])
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: i < games.length && isWinnerFunction(gamesList[i])
                      ? playerColor
                      : theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// Footer component showing match statistics
class _ScoreCardFooter extends StatelessWidget {
  final List<Game> games;
  final String player1;
  final String player2;

  const _ScoreCardFooter({
    required this.games,
    required this.player1,
    required this.player2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate wins based on the game rules
    int player1Wins = 0;
    int player2Wins = 0;

    for (final game in games.take(7)) {
      if (game.isPlayer1Winner) {
        player1Wins++;
      } else if (game.isPlayer2Winner) {
        player2Wins++;
      }
    }

    // Determine match winner based on the rules:
    // - Winner must have at least 4 games
    // - Winner must have a 2-game lead, or win the 7th game in case of a tie
    String? winner;

    if (player1Wins > player2Wins && player1Wins >= 4) {
      winner = player1;
    } else if (player2Wins > player1Wins && player2Wins >= 4) {
      winner = player2;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: winner == player1
                  ? Colors.red
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$player1Wins',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: winner == player1 ? Colors.white : Colors.red,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: winner != null
                  ? Text(
                      '$winner wins',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    )
                  : games.isNotEmpty && games.length == 7
                      ? const Text('Tie')
                      : const SizedBox(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: winner == player2
                  ? Colors.blue
                  : Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$player2Wins',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: winner == player2 ? Colors.white : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
