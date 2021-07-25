import 'package:test/test.dart';
import 'package:joker/joker.dart';

void main() {
  final cc = CardCollection(label: 'test');
  final c1 = Card(rank: 1, suit: 4);
  final d1 = Card(rank: 1, suit: 2);
  cc.add(c1);
  cc.add(d1);

  group('CardCollections', () {
    test('are not empty when a card is added', () {
      expect(cc.empty, false);
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
    test('can be sorted', () {
      cc.sort();
      expect(cc[0], d1);
    });
  });
}
