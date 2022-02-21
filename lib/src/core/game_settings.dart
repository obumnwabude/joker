import './board.dart';

/// The settings used to play on the [Board] at each game.
class GameSettings {
  final bool aceSkipsPlayers;
  final bool allowJackWhenInCommand;
  final bool alwaysAllowJack;
  final bool enableUndoRedo;
  final bool includeJokers;
  final int initialHandSize;
  final bool observeBoardJack;
  final bool sevenPicksTwo;
  final bool useTwoDecks;

  GameSettings({
    required this.aceSkipsPlayers,
    required this.allowJackWhenInCommand,
    required this.alwaysAllowJack,
    required this.enableUndoRedo,
    required this.includeJokers,
    required this.initialHandSize,
    required this.observeBoardJack,
    required this.sevenPicksTwo,
    required this.useTwoDecks,
  });

  factory GameSettings.defaults() => GameSettings(
        aceSkipsPlayers: true,
        allowJackWhenInCommand: true,
        alwaysAllowJack: false,
        enableUndoRedo: false,
        includeJokers: true,
        initialHandSize: 5,
        observeBoardJack: true,
        sevenPicksTwo: true,
        useTwoDecks: false,
      );

  GameSettings copyWith({
    bool? aceSkipsPlayers,
    bool? allowJackWhenInCommand,
    bool? alwaysAllowJack,
    bool? enableUndoRedo,
    bool? includeJokers,
    int? initialHandSize,
    bool? observeBoardJack,
    bool? sevenPicksTwo,
    bool? useTwoDecks,
  }) {
    return GameSettings(
      aceSkipsPlayers: aceSkipsPlayers ?? this.aceSkipsPlayers,
      allowJackWhenInCommand:
          allowJackWhenInCommand ?? this.allowJackWhenInCommand,
      alwaysAllowJack: alwaysAllowJack ?? this.alwaysAllowJack,
      enableUndoRedo: enableUndoRedo ?? this.enableUndoRedo,
      includeJokers: includeJokers ?? this.includeJokers,
      initialHandSize: initialHandSize ?? this.initialHandSize,
      observeBoardJack: observeBoardJack ?? this.observeBoardJack,
      sevenPicksTwo: sevenPicksTwo ?? this.sevenPicksTwo,
      useTwoDecks: useTwoDecks ?? this.useTwoDecks,
    );
  }
}
