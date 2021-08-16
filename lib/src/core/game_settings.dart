import './board.dart';

/// The settings used to play on the [Board] at each game.
class GameSettings {
  final int initialHandSize;
  final bool includeJokers;
  final bool useTwoDecks;

  GameSettings(
      {required this.initialHandSize,
      this.includeJokers = true,
      this.useTwoDecks = false});
}
