import 'board_state.dart';
import 'board_exceptions.dart';
import 'card.dart';
import 'card_collection.dart';
import 'game_settings.dart';
import 'player.dart';
import 'turn_stack.dart';

/// The board on which the joker card game is played.
///
/// The [discardPile] is the pile of [Card]s onto which [Player]s play [Card]s
/// to empty their [Player.hand]s and win the game.
///
/// The [drawPile] is the pile of [Card]s from which [Player]s draw [Card]s
/// when taking turns, if they don't have a matching [Card] in their
/// [Player.hand]s.
class Board {
  /// The pile of [Card]s placed face down from which [Player]s can draw [Card]s
  final CardCollection drawPile = CardCollection(label: 'Draw Pile');

  /// The pile of [Card]s placed face up unto which [Player]s discard [Card]s.
  final CardCollection discardPile = CardCollection(label: 'Discard Pile');

  /// The [Card] face up on the [discardPile].
  Card get previous => discardPile[discardPile.length - 1];

  /// The [Turn]s taken on this board
  late final TurnStack turns;

  /// The [GameSettings] used during play on this board.
  GameSettings gameSettings;

  /// The current [BoardState]
  BoardState state = BoardState();

  /// Starts the game by dealing [Card]s to all [players]' [Player.hand]s.
  ///
  /// Initializes and shuffles [Deck](s) of [Card]s used for playing on this
  /// [Board]. One or two [Deck]s could be used depending on the
  /// [GameSettings.useTwoDecks] property of the [gameSettings].
  ///
  /// The number of [Card]s dealt to each `player`'s [Player.hand] is specified
  /// by the [GameSettings.initialHandSize] property of [gameSettings]. After
  /// dealing, one [Card] is dealt to the [discardPile], while the other [Card]s
  /// are dealt to the [drawPile].
  Board(List<Player> players, this.gameSettings) {
    Deck deck = Deck(includeJokers: gameSettings.includeJokers);
    if (gameSettings.useTwoDecks) {
      Deck(includeJokers: gameSettings.includeJokers).dealAll(deck);
    }
    deck.shuffle();
    players.forEach((player) {
      deck.deal(player.hand, gameSettings.initialHandSize);
      player.hand.sort();
    });
    deck.deal(discardPile, 1);
    deck.dealAll(drawPile);
    drawPile.shuffle();
    if (gameSettings.aceSkipsPlayers && previous.rank == 1) {
      state = BoardState(isInSkip: true);
    }
    if ((gameSettings.sevenPicksTwo && previous.rank == 7) ||
        (gameSettings.jokerPicksFour && previous.rank == 14)) {
      state = BoardState(
        isInPick: true,
        noCardsToBePicked: previous.rank == 7 ? 2 : 4,
      );
    }
    if (!gameSettings.allowAnyOnBoardJack && previous.rank == 11) {
      state = BoardState(isInCommand: true, commandedSuit: previous.suit);
    }
    turns = TurnStack(this);
  }

  /// Can redo the previous [Turn]
  bool get canRedo => gameSettings.enableUndoRedo ? turns.canRedo : false;

  /// Can undo the previous [Turn]
  bool get canUndo => gameSettings.enableUndoRedo ? turns.canUndo : false;

  /// Undoes the previous [Turn] on the board.
  void undo() {
    if (canUndo) turns.undo();
  }

  /// Reddoes the previously undone [Turn] on the board.
  void redo() {
    if (canRedo) turns.redo();
  }

  /// Reshuffles [discardPile] into [drawPile]
  void _reshuffle() {
    Card last = discardPile.removeLast();
    discardPile.dealAll(drawPile);
    discardPile.add(last);
    drawPile.shuffle();
    turns.reset();
  }

  /// Removes and adds the topmost [Card] in the [drawPile] to [player]'s hand.
  void draw(Player player) {
    if (drawPile.isEmpty) _reshuffle();
    turns.add(Turn(Action.drew, [drawPile.removeLast()], player, state));
  }

  /// Takes a [card] played by a [player] when taking a [Turn].
  ///
  /// Throws an [UnmatchedCardException] if the played [card] does not match the
  /// [previous] card on the [discardPile].
  void play(Player player, Card card) {
    if (state.isInCommand &&
        !(card.matchSuit(state.commandedSuit) ||
            (gameSettings.allowJackWhenInCommand &&
                card.rank == previous.rank))) {
      throw UnmatchedCommandedSuitException(
        played: card,
        suit: state.commandedSuit,
        isJackAllowed: gameSettings.allowJackWhenInCommand,
      );
    } else if (card.rank == previous.rank ||
        card.matchSuit(previous.suit) ||
        (state.isInCommand && card.matchSuit(state.commandedSuit)) ||
        (gameSettings.alwaysAllowJack && card.rank == 11) ||
        // had to use the following combination to permit playing an unmatched
        // card when allowAnyOnBoardJack is true and to attempt to detect that
        // this would be the very first move of the game (though these
        // checks might be a little inaccurate)
        (!canUndo &&
            discardPile.length == 1 &&
            gameSettings.allowAnyOnBoardJack &&
            player.hand.length == gameSettings.initialHandSize - 1)) {
      if (card.rank == 11) {
        // TODO: Check whether to return game play if player's hand is empty
        // at this if block or to maintain the current logic of assigning new
        // board state with card.suit in that case.
        state = BoardState(
          isInCommand: true,
          commandedSuit: player.hand.isEmpty ? card.suit : player.command,
        );
        turns.add(Turn(Action.commanded, [card], player, state));
      } else {
        if (state.isInCommand) state = BoardState();
        if (gameSettings.aceSkipsPlayers && card.rank == 1) {
          state = BoardState(isInSkip: true);
        } else if ((gameSettings.sevenPicksTwo && card.rank == 7) ||
            (gameSettings.jokerPicksFour && card.rank == 14)) {
          state = BoardState(
            isInPick: true,
            noCardsToBePicked: card.rank == 7 ? 2 : 4,
          );
        }
        turns.add(Turn(Action.played, [card], player, state));
      }
    } else {
      throw UnmatchedCardException(played: card, previous: previous);
    }
  }

  /// Permits [player] to take a [Turn] and ensures game rules are observed.
  enter(Player player) {
    if (state.isInSkip) {
      state = BoardState();
      turns.add(Turn(Action.skipped, [], player, state));
    } else if (state.isInPick) {
      if (drawPile.length < state.noCardsToBePicked) _reshuffle();
      List<Card> pickedCards = [];
      int noCardsToBePicked = state.noCardsToBePicked;
      while (noCardsToBePicked > 0) {
        pickedCards.add(drawPile.removeLast());
        noCardsToBePicked--;
      }
      state = BoardState();
      turns.add(Turn(Action.picked, pickedCards, player, state));
    } else {
      player.play(this);
    }
  }
}
