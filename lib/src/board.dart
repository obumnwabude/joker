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

  /// Starts the game by dealing [Card]s to all [players]' [Player.hand]s.
  ///
  /// Initializes and shuffles [Deck](s) of [Card]s used for playing on this 
  /// [Board]. One or two [Deck]s could be used depending on the 
  /// [GameSettings.useTwoDecks] property of the [gameSettings].
  ///
  /// The number of [Card]s dealt to each `player's` [Player.hand] is specified 
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
  }
}
 