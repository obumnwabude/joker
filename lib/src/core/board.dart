import 'joker_exception.dart';
import 'turn_stack.dart';
import './card.dart';
import './card_collection.dart';
import './game_settings.dart';
import './player.dart';

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
  Card get previous => discardPile[discardPile.size - 1];

  /// The [Turn]s taken on this board
  late final TurnStack turns;

  /// The [GameSettings] used during play on this board.
  GameSettings gameSettings;

  bool _isInSkip = false;

  /// Indicates that the `suit` of the next played [Card] must match the
  /// [commandedSuit].
  bool isInCommand = false;

  /// The suit being requested when this board is [isInCommand].
  int commandedSuit = 0;

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
  Board({required this.gameSettings, required List<Player> players}) {
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
    if (gameSettings.aceSkipsPlayers && previous.rank == 1) _isInSkip = true;
    if (gameSettings.observeBoardJack && previous.rank == 11) {
      isInCommand = true;
      commandedSuit = previous.suit;
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

  /// Removes and adds the topmost [Card] in the [drawPile] to [player]'s hand.
  void draw(Player player) {
    if (drawPile.isEmpty) {
      Card last = discardPile.removeLast();
      discardPile.dealAll(drawPile);
      discardPile.add(last);
      drawPile.shuffle();
    }
    turns.add(Turn(
        action: Action.drew, cards: [drawPile.removeLast()], player: player));
  }

  /// Takes a [card] played by a [player] when taking a [Turn].
  ///
  /// Throws an [UnmatchedCardException] if the played [card] does not match the
  /// [previous] card on the [discardPile].
  void play(Player player, Card card) {
    if (isInCommand) {
      if (card.rank == previous.rank || card.matchSuit(commandedSuit)) {
        turns.add(Turn(action: Action.played, cards: [card], player: player));
        isInCommand = false;
      } else {
        throw UnmatchedCommandedSuitException(
          played: card,
          suit: commandedSuit,
          isJackAllowed: gameSettings.allowJackWhenInCommand,
        );
      }
    } else {
      if (card.matchSuit(previous.suit) ||
          (gameSettings.allowJackWhenInCommand && card.rank == previous.rank)) {
        if (card.rank == 11) {
          turns.add(Turn(
              action: Action.commanded,
              commandedSuit: card.suit,
              cards: [card],
              player: player));
          isInCommand = true;
          commandedSuit = card.suit;
        } else {
          turns.add(Turn(action: Action.played, cards: [card], player: player));
          if (gameSettings.aceSkipsPlayers && previous.rank == 1) {
            _isInSkip = true;
          }
        }
      } else {
        throw UnmatchedCardException(played: card, previous: previous);
      }
    }
  }

  /// Permits [player] to take a [Turn] and ensures game rules are observed.
  enter(Player player) {
    if (_isInSkip) {
      _isInSkip = false;
      turns.add(Turn(action: Action.skipped, cards: [], player: player));
    } else {
      player.play(this);
    }
  }
}

/// Thrown when a [Player] attempts to play a [Card] whose [Card.rank] or
/// [Card.suit] does not match the [Board.previous] [Card] on the [Board].
class UnmatchedCardException implements JokerException {
  final Card played;
  final Card previous;
  String get cause => 'Played "$played" does not match previous "$previous".';
  UnmatchedCardException({required this.played, required this.previous});
}

/// Thrown when a [Player] attempts to play a [Card] whose [Card.suit] does not
/// match the [Board.commandedSuit] on the [Board].
class UnmatchedCommandedSuitException implements JokerException {
  final Card played;
  final int suit;
  final bool isJackAllowed;
  String get cause =>
      'Played "$played" does not match commanded suit: "${Card.suits[suit]}"' +
      (isJackAllowed ? ' or is not a Jack.' : '');
  UnmatchedCommandedSuitException(
      {required this.played, required this.suit, required this.isJackAllowed});
}
