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
  Board({required GameSettings gameSettings, required List<Player> players}) {
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
  }

  /// Removes and returns the topmost [Card] in the [drawPile].
  Card draw() {
    if (drawPile.isEmpty) {
      Card last = discardPile.removeLast();
      discardPile.dealAll(drawPile);
      discardPile.add(last);
      drawPile.shuffle();
    } 
    return drawPile.removeLast();
  }

  /// Takes a [card] played by a [Player] when taking a turn.
  /// 
  /// Throws an [UnmatchedCardException] if the played [card] does not match the
  /// [previous] card on the [discardPile].
  void play(Card card) {
    if (card.rank == previous.rank || card.matchSuit(previous)) {
      discardPile.add(card);
    } else {
      throw UnmatchedCardException(played: card, previous: previous);
    }
  }
}

/// Thrown when a [Player] attempts to play a [Card] that whose [Card.rank] or
/// [Card.suit] does not match the [Board.previous] [Card] on the [Board].
class UnmatchedCardException implements Exception {
  final Card played;
  final Card previous;
  String get cause => 'Played "$played" does not match previous "$previous".';
  UnmatchedCardException({required this.played, required this.previous});
}
 