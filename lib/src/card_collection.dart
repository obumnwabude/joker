import './card.dart';

/// A group of cards in the joker card game.
class CardCollection extends Iterable<Card> {
  String _label;
  List<Card> _cards;

  /// If this [CardCollection] is empty (has no [Card] in it) or not.
  bool get empty => _cards.length == 0;

  /// The number of [Card]s in this [CardCollection].
  int get size => _cards.length;

  /// Creates an empty `CardCollection` with name as [label].
  CardCollection({required String label})
      : this._label = label,
        _cards = [];

  @override
  String toString() {
    String desc = 'Cards in $_label:';
    _cards
        .asMap()
        .forEach((index, card) => desc += '\n  ${++index}. ${card.toString()}');
    return desc;
  }

  @override
  Iterator<Card> get iterator => _cards.iterator;

  /// The [Card] at the given [index] in this [CardCollection].
  ///
  /// The index must be a valid index of this [CardCollection], which means
  /// that index must be non-negative and less than [size].
  Card operator [](int index) => _cards[index];

  /// Adds the provided [card] to this [CardCollection].
  void add(Card card) => _cards.add(card);

  /// Sorts the [Card]s in this [CardCollection].
  void sort() => _cards.sort();

  /// Shuffles the [Cards]s this [CardCollection].
  void shuffle() => _cards.shuffle();
}

/// A standard pack of 52 playing cards (or 54 if two joker cards are included).
class Deck extends CardCollection {
  Deck({required bool includeJokers})
      : super(label: 'Deck (with${includeJokers ? '' : 'out'} Jokers)') {
    for (int suit = 1; suit < 5; suit++) {
      for (int rank = 1; rank < 14; rank++) {
        _cards.add(Card(rank: rank, suit: suit));
      }
    }
    if (includeJokers) {
      _cards.add(Card(rank: 14, suit: 5));
      _cards.add(Card(rank: 14, suit: 6));
    }
  }
}
