import 'package:test/test.dart';
import 'package:joker/core.dart';

void main() {
  final player = SystemPlayer(name: 'TestSystem');
  final board = Board(gameSettings: GameSettings.defaults(), players: [player]);

  group('System Player', () {
    test('when playing can draw', () {
      List<Card> matchingCards = player.hand
          .where((card) =>
              card.rank == board.previous.rank ||
              card.matchSuit(board.previous))
          .toList();
      // force drawing
      if (!matchingCards.isEmpty) {
        matchingCards
            .forEach((card) => player.hand.removeAt(player.hand.indexOf(card)));
      }

      int oldHandSize = player.hand.size;
      player.play(board);

      expect(player.hand.size, oldHandSize + 1);
    });
    test('can play cards matching to board\'s previous', () {
      List<Card> matchingCards = player.hand
          .where((card) =>
              card.rank == board.previous.rank ||
              card.matchSuit(board.previous))
          .toList()
            ..sort();
      // ensure there is a matching card
      if (matchingCards.isEmpty) {
        player.hand.add(Card.clone(board.previous));
      }

      int oldHandSize = player.hand.size;
      player.play(board);

      expect(player.hand.size, oldHandSize - 1);
    });
  });
}
