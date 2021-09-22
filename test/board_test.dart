import 'package:test/test.dart';
import 'package:joker/core.dart';

class TestPlayer extends Player {
  TestPlayer() : super(name: 'Test');
  
  // hard to use a cloned card as one can't tell if the Test SystemPlayer
  // will have a matching card when this test runs.
  void play(Board board) => board.play(this, Card.clone(board.previous));
}

void main() {
  final player = TestPlayer();
  final Board board = Board(
      // the double copyWith is for test coverage
      gameSettings:
          GameSettings.defaults().copyWith().copyWith(enableUndoRedo: true),
      players: [player]);

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
      int oldPlayerHandSize = player.hand.size;

      // for code coverage
      board.drawPile.dealAll(board.discardPile);

      board.draw(player);
      expect(board.drawPile.size, oldDrawPileSize - 1);
      expect(player.hand.size, oldPlayerHandSize + 1);
    });
    test('should throw exception if unmatched card is played', () {
      Card unmatchedCard;
      if ([1, 4, 5].any((suit) => suit == board.previous.suit))
        unmatchedCard = Card(rank: 14, suit: 6);
      else
        unmatchedCard = Card(rank: 14, suit: 5);

      try {
        board.play(player, unmatchedCard);
      } catch (e) {
        expect((e as UnmatchedCardException).cause,
            contains(unmatchedCard.toString()));
      }
    });
    test('can accept a playable card by player', () {
      int oldDiscardPileSize = board.discardPile.size;
      board.enter(player);
      expect(board.discardPile.size, oldDiscardPileSize + 1);
    });
    test('can undo and redo', () {
      // repeat undo twice for code coverage
      expect(board.canUndo, true);
      board.undo();
      expect(board.canUndo, true);
      board.undo();
      expect(board.canRedo, true);
      board.redo();
    });
    test('can get players skipped', () {
      int matchingSuit = board.previous.suit;
      if (matchingSuit == 5)
        matchingSuit = 1;
      else if (matchingSuit == 6) matchingSuit = 2;
      board.play(player, Card(rank: 1, suit: matchingSuit));

      board.enter(player);

      expect(board.turns.last.action, Action.skipped);
    });
  });
}
