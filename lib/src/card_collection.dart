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

  /// Adds the provided [card] to this [CardCollection].
  void add(Card card) => _cards.add(card);
}