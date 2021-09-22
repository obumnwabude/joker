import './board.dart';
import './card.dart';
import './player.dart';

/// A computerised player
class SystemPlayer extends Player {
  /// Creates and returns a [SystemPlayer] with the given [name].
  SystemPlayer({required name}) : super(name: name);

  @override
  void play(Board board) {
    List<Card> matchingCards = hand
        .where((card) =>
            card.rank == board.previous.rank || card.matchSuit(board.previous))
        .toList()
          ..sort();

    if (matchingCards.isEmpty) {
      draw(board);
    } else {
      board.play(this, hand.removeAt(hand.indexOf(matchingCards.last)));
    }
  }
}
