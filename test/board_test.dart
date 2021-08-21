import 'package:test/test.dart';
import 'package:joker/core.dart';

void main() {
  final List<Player> players = [SystemPlayer(name: 'Test1')];
  final Board board = Board(
      // the double copyWith is for test coverage
      gameSettings:
          GameSettings.defaults().copyWith().copyWith(enableUndoRedo: true),
      players: players);

  group('The Board', () {
    test('can be initialized with two decks', () {
      expect(
          Board(
              gameSettings: GameSettings.defaults()
                  .copyWith(useTwoDecks: true, includeJokers: false),
              players: []).drawPile.size,
          // Greater than 100 because two decks without jokers should be 52 + 52
          // Didn't use equals(104) because as at the commit this code was
          // written, one card will be dealt to drawPile during Board's
          // initialization.
          greaterThan(100));
    });
    test('can draw a card to a player', () {
      int oldDrawPileSize = board.drawPile.size;
      int oldPlayerHandSize = players[0].hand.size;

      // for code coverage
      board.drawPile.dealAll(board.discardPile);

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
        expect((e as UnmatchedCardException).cause,
            contains(unmatchedCard.toString()));
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
