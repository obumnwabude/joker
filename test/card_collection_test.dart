import 'package:test/test.dart';
import 'package:joker/joker.dart';

void main() {
  final cc = CardCollection(label: 'test');
  final c1 = Card(rank: 1, suit: 4);
  cc.add(c1);

  group('CardCollections', () {
    test('are not empty when a card is added', () {
      expect(cc.empty, false);
      expect(cc.size, 1);
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
  });
}
