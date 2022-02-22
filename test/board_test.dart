import 'package:test/test.dart';
import 'package:joker/core.dart';

class TestPlayer extends Player {
  TestPlayer() : super(name: 'Test');

  // hard to use a cloned card as one can't tell if the Test SystemPlayer
  // will have a matching card when this test runs.
  void play(Board board) => board.play(this, Card.clone(board.previous));

  @override
  int get command => 1;
}

void main() {
  final player = TestPlayer();

  group('The Board', () {
    late Board board;
    setUp(() {
      board = Board(
        [player],
        // the double copyWith is for test coverage
        GameSettings.defaults().copyWith().copyWith(enableUndoRedo: true),
      );
    });

    test('can be initialized with two decks', () {
      expect(
          Board(
            [],
            GameSettings.defaults()
                .copyWith(useTwoDecks: true, includeJokers: false),
          ).drawPile.size,
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
        unmatchedCard = Card(14, 6);
      else
        unmatchedCard = Card(14, 5);

      try {
        board.play(player, unmatchedCard);
      } catch (e) {
        expect((e as UnmatchedCardException).cause,
            contains(unmatchedCard.toString()));
      }
    });
    test('can accept a playable card by player', () {
      // resolve skip/pick rule to ensure tests always pass.
      if ([1, 7].contains(board.previous.rank)) board.enter(player);

      int oldDiscardPileSize = board.discardPile.size;
      board.enter(player);
      expect(board.discardPile.size, oldDiscardPileSize + 1);
    });
    test('can undo and redo', () {
      board.enter(player);
      board.enter(player);
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
      board.play(player, Card(1, matchingSuit));

      board.enter(player);

      expect(board.turns.last.action, Action.skipped);
    });
    test('can command suit if Jack was played by a player', () {
      // resolve skip/pick rule to ensure tests always pass.
      if ([1, 7].contains(board.previous.rank)) board.enter(player);
      int matchingSuit = board.previous.suit;
      if (matchingSuit == 5)
        matchingSuit = 1;
      else if (matchingSuit == 6) matchingSuit = 2;
      board.play(player, Card(11, matchingSuit));

      expect(board.isInCommand, true);
      expect(board.commandedSuit, 1);

      board.play(player, Card(10, 1));
      expect(board.isInCommand, false);
    });
    test('should throw exception if unmatched card is played when in command',
        () {
      board = Board(
          [player], GameSettings.defaults().copyWith(alwaysAllowJack: true));
      // resolve skip/pick rule to ensure tests always pass.
      if ([1, 7].contains(board.previous.rank)) board.enter(player);
      board.play(player, Card(11, 1));
      Card unmatchedCard = Card(2, 2);

      try {
        board.play(player, unmatchedCard);
      } catch (e) {
        expect((e as UnmatchedCommandedSuitException).cause,
            contains(unmatchedCard.toString()));
      }
    });
    test('should make player pick two cards when seven was played', () {
      // resolve skip/pick rule to ensure tests always pass.
      if ([1, 7].contains(board.previous.rank)) board.enter(player);

      int matchingSuit = board.previous.suit;
      if (matchingSuit == 5)
        matchingSuit = 1;
      else if (matchingSuit == 6) matchingSuit = 2;
      board.play(player, Card(7, matchingSuit));

      int prevSize = player.hand.size;
      board.enter(player);
      expect(player.hand.size, prevSize + 2);
    });
  });
}
