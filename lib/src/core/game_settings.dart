import './board.dart';

/// The settings used to play on the [Board] at each game.
class GameSettings {
  final int initialHandSize;
  final bool includeJokers;
  final bool useTwoDecks;
  final bool enableUndoRedo;

  GameSettings(
      {required this.initialHandSize,
      required this.includeJokers,
      required this.useTwoDecks,
      required this.enableUndoRedo});

  factory GameSettings.defaults() => GameSettings(
      initialHandSize: 5,
      includeJokers: true,
      useTwoDecks: false,
      enableUndoRedo: false);
}
