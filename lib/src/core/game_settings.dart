import './board.dart';

/// The settings used to play on the [Board] at each game.
class GameSettings {
  final bool aceSkipsPlayers;
  final bool allowJackWhenInCommand;
  final bool enableUndoRedo;
  final bool includeJokers;
  final int initialHandSize;
  final bool observeBoardJack;
  final bool useTwoDecks;

  GameSettings({
    required this.allowJackWhenInCommand,
    required this.aceSkipsPlayers,
    required this.enableUndoRedo,
    required this.includeJokers,
    required this.initialHandSize,
    required this.observeBoardJack,
    required this.useTwoDecks,
  });

  factory GameSettings.defaults() => GameSettings(
        aceSkipsPlayers: true,
        allowJackWhenInCommand: true,
        enableUndoRedo: false,
        includeJokers: true,
        initialHandSize: 5,
        observeBoardJack: true,
        useTwoDecks: false,
      );

  GameSettings copyWith({
    bool? aceSkipsPlayers,
    bool? allowJackWhenInCommand,
    bool? enableUndoRedo,
    bool? includeJokers,
    int? initialHandSize,
    bool? observeBoardJack,
    bool? useTwoDecks,
  }) {
    return GameSettings(
      aceSkipsPlayers: aceSkipsPlayers ?? this.aceSkipsPlayers,
      allowJackWhenInCommand:
          allowJackWhenInCommand ?? this.allowJackWhenInCommand,
      enableUndoRedo: enableUndoRedo ?? this.enableUndoRedo,
      includeJokers: includeJokers ?? this.includeJokers,
      initialHandSize: initialHandSize ?? this.initialHandSize,
      observeBoardJack: observeBoardJack ?? this.observeBoardJack,
      useTwoDecks: useTwoDecks ?? this.useTwoDecks,
    );
  }
}
