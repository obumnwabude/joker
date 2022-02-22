import './board.dart';
import './card.dart';
import './player.dart';

/// A computerised player
class SystemPlayer extends Player {
  /// Creates and returns a [SystemPlayer] with the given [name].
  SystemPlayer({required name}) : super(name: name);

  @override
  void play(Board board) {
    Iterable<Card> matchingCards;
    if (board.isInCommand) {
      matchingCards = hand.where((card) => card.matchSuit(board.commandedSuit));
    } else {
      matchingCards = hand.where((card) =>
          card.matchSuit(board.previous.suit) ||
          (card.rank == board.previous.rank));
    }

    matchingCards = matchingCards.toList()..sort();
    if (matchingCards.isEmpty) {
      draw(board);
    } else {
      board.play(this, hand.removeAt(hand.indexOf(matchingCards.last)));
    }
  }

  @override
  int get command {
    if (hand.isEmpty) return 1;
    if (hand.length == 1) return hand[0].suit;
    final suitQtys = [0, 0, 0, 0, 0];
    hand.forEach((c) {
      if (c.suit == 5 || c.suit == 6) return;
      suitQtys[c.suit] = suitQtys[c.suit] + 1;
    });
    final highest = suitQtys.reduce((curr, next) => curr > next ? curr : next);
    return suitQtys.indexOf(highest);
  }
}
