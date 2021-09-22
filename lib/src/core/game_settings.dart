import './board.dart';

/// The settings used to play on the [Board] at each game.
class GameSettings {
  final bool aceSkipsPlayers;
  final bool enableUndoRedo;
  final int initialHandSize;
  final bool includeJokers;
  final bool useTwoDecks;

  GameSettings({
    required this.aceSkipsPlayers,
    required this.enableUndoRedo,
    required this.initialHandSize,
    required this.includeJokers,
    required this.useTwoDecks
  });

  factory GameSettings.defaults() => GameSettings(
      aceSkipsPlayers: true,
      enableUndoRedo: false,
      initialHandSize: 5,
      includeJokers: true,
      useTwoDecks: false);

  GameSettings copyWith(
      {bool? aceSkipsPlayers,
      bool? enableUndoRedo,
      int? initialHandSize,
      bool? includeJokers,
      bool? useTwoDecks}) {
    return GameSettings(
        aceSkipsPlayers: aceSkipsPlayers ?? this.aceSkipsPlayers,
        initialHandSize: initialHandSize ?? this.initialHandSize,
        includeJokers: includeJokers ?? this.includeJokers,
        useTwoDecks: useTwoDecks ?? this.useTwoDecks,
        enableUndoRedo: enableUndoRedo ?? this.enableUndoRedo);
  }
}
