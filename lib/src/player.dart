import './card_collection.dart';

/// A player of the joker card game.
class Player {
  final String name;
  final CardCollection hand;

  /// Creates and returns a [Player] with the given [name].
  Player({required this.name})
      : this.hand = CardCollection(label: '${name}\'s Hand');
}
