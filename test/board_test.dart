import 'package:test/test.dart';
import 'package:joker/core.dart';

void main() {
  final List<Player> players = [SystemPlayer(name: 'Test1')];
  final Board board = Board(
      gameSettings: GameSettings.defaults()
          .copyWith(initialHandSize: 10, enableUndoRedo: true),
      players: players);

  group('The Board', () {
    test('should start the game when initialized', () {
      expect(board.discardPile.size, 1);
      expect(board.previous, board.discardPile[0]);
      expect(board.drawPile.size, greaterThan(1));
      expect(players[0].hand.size, 10);
    });
    test('can draw a card to a player', () {
      int oldDrawPileSize = board.drawPile.size;
      int oldPlayerHandSize = players[0].hand.size;
      board.draw(players[0]);
      expect(board.drawPile.size, oldDrawPileSize - 1);
      expect(players[0].hand.size, oldPlayerHandSize + 1);
    });
    test('should throw exception if unmatched card is played', () {
      Card unmatchedCard;
      if ([1, 4, 5].any((suit) => suit == board.previous.suit))
        unmatchedCard = Card(rank: 14, suit: 6);
      else
        unmatchedCard = Card(rank: 14, suit: 5);

      try {
        board.play(players[0], unmatchedCard);
      } catch (e) {
        expect(e, isA<UnmatchedCardException>());
      }
    });
    test('can accept a playable card by player', () {
      int oldDiscardPileSize = board.discardPile.size;
      // hard to use a cloned card as one can't tell if the Test SystemPlayer
      // will have a matching card when this test runs.
      board.play(players[0], Card.clone(board.previous));
      expect(board.discardPile.size, oldDiscardPileSize + 1);
    });
    test('can undo and redo', () {
      expect(board.canUndo, true);
      board.undo();
      expect(board.canRedo, true);
      board.redo();
    });
  });
}
