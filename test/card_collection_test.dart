import 'package:test/test.dart';
import 'package:joker/joker.dart';

void main() {
  group('CardCollections', () {
    final cc = CardCollection(label: 'test');
    final c1 = Card(rank: 1, suit: 4);
    final d1 = Card(rank: 1, suit: 2);
    cc.add(c1);
    cc.add(d1);
    test('are not empty when a card is added', () {
      expect(cc.isEmpty, false);
      expect(cc.size, 2);
    });
    test('can display their contents', () {
      expect(cc.toString(), matches(RegExp(c1.toString())));
    });
    test('are iterable', () {
      int size = 0;
      final ccIt = cc.iterator;
      while (ccIt.moveNext()) size++;
      expect(size, cc.size);
    });
    test('can be shuffled and can be sorted', () {
      cc.shuffle();
      cc.sort();
      expect(cc[0], d1);
    });
    test('can deal cards to other CardCollections', () {
      int size = cc.size;
      final cc2 = CardCollection(label: 'test2');
      try {
        cc.deal(cc2, 4);
      } on InsufficientCardsException {
        cc.deal(cc2, 1);
        cc.dealAll(cc2);
      }
      expect(cc2.size, size);
    });
  });

  group('Decks', () {
    test('can be created with or without Joker cards', () {
      final deckWithJs = Deck(includeJokers: true);
      final deckWithoutJs = Deck(includeJokers: false);
      expect(deckWithJs.size, 54);
      expect(deckWithoutJs.size, 52);
    });
  });
}
