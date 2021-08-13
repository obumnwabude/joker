import './card.dart';

/// A group of cards in the joker card game.
class CardCollection extends Iterable<Card> {
  final String _label;
  final List<Card> _cards = [];

  /// If this CardCollection is empty (has no [Card] in it) or not.
  bool get isEmpty => _cards.length == 0;

  /// The number of [Card]s in this CardCollection.
  int get size => _cards.length;

  /// Creates an empty `CardCollection` with name as [label].
  CardCollection({required String label}) : this._label = label;

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

  /// The [Card] at the given [index] in this CardCollection.
  ///
  /// The index must be a valid index of this CardCollection, which means
  /// that index must be non-negative and less than [size].
  Card operator [](int index) => _cards[index];

  /// Adds the provided [card] to this CardCollection.
  void add(Card card) => _cards.add(card);

  /// Removes and returns the [Card] at position [index] from this
  /// CardCollection.
  Card removeAt(int index) => _cards.removeAt(index);

  /// Removes and returns the last [Card] in this CardCollection.
  Card removeLast() => _cards.removeLast();

  /// Sorts the [Card]s in this CardCollection.
  void sort() => _cards.sort();

  /// Shuffles the [Cards]s this CardCollection.
  void shuffle() => _cards.shuffle();

  /// Deals out the [n] number of [Card]s from this CardCollection to [other].
  ///
  /// Throws an [InsufficientCardsException] if the [size] of this
  /// CardCollection is less than the required [n] cards to be dealt. Also
  /// throws an [ArgumentError] if a negative number is provided as [n].
  void deal(CardCollection other, int n) {
    if (_cards.length < n) {
      throw InsufficientCardsException();
    } else if (n < 0) {
      throw ArgumentError.value(n);
    } else {
      for (int i = n; i > 0; i--) {
        other.add(_cards.removeAt(_cards.length - 1));
      }
    }
  }

  /// Deals out all the [Card]s in this CardCollection into [other].
  void dealAll(CardCollection other) {
    for (int i = _cards.length; i > 0; i--) {
      other.add(_cards.removeAt(i - 1));
    }
  }
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

/// Thrown when there are not enough [Card]s to be [CardCollection.deal]t from
/// a CardCollection.
class InsufficientCardsException implements Exception {
  String cause = 'Not enough cards to deal out';
  InsufficientCardsException();
}
