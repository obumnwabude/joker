import 'package:test/test.dart';
import 'package:joker/core.dart';

void main() {
  final s1 = Card(1, 4);
  final b14 = Card(14, 5);
  final h6 = Card(6, 3);
  final r14 = Card(14, 6);
  final s1Cloned = Card.clone(s1);

  group('Cards', () {
    test('are properly represented in String format', () {
      expect(s1.toString(), 'Ace of Spades');
      expect(r14.toString(), 'Red Joker');
    });
    test('have Black and Red suits matching appropriately', () {
      expect(s1.matchSuit(b14.suit), true);
      expect(h6.matchSuit(r14.suit), true);
    });
    test('when cloned should be equal', () {
      expect(s1.rank, s1Cloned.rank);
      expect(s1.suit, s1Cloned.suit);
      expect(s1 == s1Cloned, true);
      expect(s1.hashCode, s1Cloned.hashCode);
    });
  });
}
