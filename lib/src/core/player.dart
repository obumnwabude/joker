import 'board.dart';
import 'card.dart';
import 'card_collection.dart';

/// A player of the joker card game.
abstract class Player {
  final String name;
  final CardCollection hand;

  /// Creates and returns a [Player] with the given [name].
  Player({required this.name})
      : this.hand = CardCollection(label: '${name}\'s Hand');

  /// Returns the commanded [Card.suit] of choice when a `Jack` was played
  int get command;

  /// Draws a [Card] from [board].
  void draw(Board board) => board.draw(this);

  /// When this `Player` takes a turn on the [board].
  void play(Board board);
}
