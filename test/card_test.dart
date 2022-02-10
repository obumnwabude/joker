import 'package:test/test.dart';
import 'package:joker/core.dart';

void main() {
  final s1 = Card(rank: 1, suit: 4);
  final b14 = Card(rank: 14, suit: 5);
  final h6 = Card(rank: 6, suit: 3);
  final r14 = Card(rank: 14, suit: 6);
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
