import 'package:test/test.dart';
import 'package:joker/core.dart';

void main() {
  group('CardCollections', () {
    late CardCollection cc;
    final c1 = Card(1, 4);
    final d2 = Card(2, 2);

    setUp(() {
      cc = CardCollection(label: 'test');
      cc.add(c1);
      cc.add(d2);
    });

    test('are not empty when a card is added', () {
      expect(cc.isEmpty, false);
      expect(cc.length, 2);
    });
    test('can display their contents', () {
      expect(cc.toString(), matches(RegExp(c1.toString())));
    });
    test('are iterable', () {
      int length = 0;
      final ccIt = cc.iterator;
      while (ccIt.moveNext()) length++;
      expect(length, cc.length);
    });
    test('can detect the index of provided card arguments', () {
      expect(cc.indexOf(c1), 0);
    });
    test('can have cards removed from them', () {
      final copiedLastCard = Card.clone(cc[cc.length - 1]);
      final lastCard1 = cc.removeLast();
      final copiedRemovedCard = Card.clone(cc[cc.length - 1]);
      final lastCard2 = cc.removeAt(cc.length - 1);
      expect(copiedLastCard, lastCard1);
      expect(copiedRemovedCard, lastCard2);
      cc.add(lastCard1);
      cc.add(lastCard2);
    });
    test('can be shuffled and can be sorted', () {
      cc.shuffle();
      cc.sort();
      expect(cc[0], d2);
    });
    test('can deal cards to other CardCollections', () {
      int length = cc.length;
      final cc2 = CardCollection(label: 'test2');
      try {
        cc.deal(cc2, 4);
      } on InsufficientCardsException {}
      try {
        cc.deal(cc2, -1);
      } on ArgumentError {
        cc.deal(cc2, 1);
        cc.dealAll(cc2);
      }
      expect(cc2.length, length);
    });
  });

  group('Decks', () {
    test('can be created with or without Joker cards', () {
      final deckWithJs = Deck(includeJokers: true);
      final deckWithoutJs = Deck(includeJokers: false);
      expect(deckWithJs.length, 54);
      expect(deckWithoutJs.length, 52);
    });
  });
}
