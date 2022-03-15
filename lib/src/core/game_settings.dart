import 'board.dart';

/// The settings used to play on the [Board] at each game.
class GameSettings {
  final bool aceSkipsPlayers;
  final bool allowAnyOnBoardJack;
  final bool allowJackWhenInCommand;
  final bool alwaysAllowJack;
  final bool enableUndoRedo;
  final bool includeJokers;
  final int initialHandSize;
  final bool jokerPicksFour;
  final bool sevenPicksTwo;
  final bool useTwoDecks;

  GameSettings({
    required this.aceSkipsPlayers,
    required this.allowAnyOnBoardJack,
    required this.allowJackWhenInCommand,
    required this.alwaysAllowJack,
    required this.enableUndoRedo,
    required this.includeJokers,
    required this.initialHandSize,
    required this.jokerPicksFour,
    required this.sevenPicksTwo,
    required this.useTwoDecks,
  });

  factory GameSettings.defaults() => GameSettings(
        aceSkipsPlayers: true,
        allowAnyOnBoardJack: true,
        allowJackWhenInCommand: true,
        alwaysAllowJack: false,
        enableUndoRedo: false,
        includeJokers: true,
        initialHandSize: 5,
        jokerPicksFour: true,
        sevenPicksTwo: true,
        useTwoDecks: false,
      );

  GameSettings copyWith({
    bool? aceSkipsPlayers,
    bool? allowAnyOnBoardJack,
    bool? allowJackWhenInCommand,
    bool? alwaysAllowJack,
    bool? enableUndoRedo,
    bool? includeJokers,
    int? initialHandSize,
    bool? jokerPicksFour,
    bool? sevenPicksTwo,
    bool? useTwoDecks,
  }) {
    return GameSettings(
      aceSkipsPlayers: aceSkipsPlayers ?? this.aceSkipsPlayers,
      allowAnyOnBoardJack: allowAnyOnBoardJack ?? this.allowAnyOnBoardJack,
      allowJackWhenInCommand:
          allowJackWhenInCommand ?? this.allowJackWhenInCommand,
      alwaysAllowJack: alwaysAllowJack ?? this.alwaysAllowJack,
      enableUndoRedo: enableUndoRedo ?? this.enableUndoRedo,
      includeJokers: includeJokers ?? this.includeJokers,
      initialHandSize: initialHandSize ?? this.initialHandSize,
      jokerPicksFour: jokerPicksFour ?? this.jokerPicksFour,
      sevenPicksTwo: sevenPicksTwo ?? this.sevenPicksTwo,
      useTwoDecks: useTwoDecks ?? this.useTwoDecks,
    );
  }
}
