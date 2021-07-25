import './card.dart';
import './card_collection.dart';
import './player.dart';

/// The board on which the joker card game is played
///
/// The board is the single source of truth for the joker card game. It holds
/// and controls [Player]s and [Card]s.
class Board {
  /// The pile of [Card]s placed face down from which [Player]s can draw [Card]s
  CardCollection drawPile = CardCollection(label: 'Draw Pile');

  /// The pile of [Card]s placed face up unto which [Player]s discard [Card]s.
  CardCollection discardPile = CardCollection(label: 'Discard Pile');

  /// The [Player]s that take turns to draw or discard [Card]s to or from this
  /// [Board].
  final List<Player> players;

  /// Creates a Board with given [players].
  Board({required this.players}) {
    Deck deck = Deck(includeJokers: true)..shuffle();
    players.forEach((player) {
      deck.deal(player.hand, 5);
      player.hand.sort();
      print(player.hand);
      print('');
    });
    deck.dealAll(drawPile);
  }
}

void main() {
  var obum = Player(name: 'Obum');
  var olisa = Player(name: 'Olisa');
  Board(players: [obum, olisa]);
}
