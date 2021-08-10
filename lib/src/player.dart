import 'dart:io';
import './board.dart';
import './card.dart';
import './card_collection.dart';

/// A player of the joker card game.
class Player {
  final String name;
  final CardCollection hand;

  /// Creates and returns a [Player] with the given [name].
  Player({required this.name})
      : this.hand = CardCollection(label: '${name}\'s Hand');

  int _inputHandler() {
    var line = stdin.readLineSync()?.trim();
    int chosen;
    try {
      chosen = int.parse(line!);
    } on FormatException {
      chosen = _inputHandler();
    }
    return chosen;
  }

  /// Adds the [drawn] card to [hand].
  void draw(Card drawn) => hand.add(drawn);

  /// When this `Player` takes a turn on the [board].
  void play(Board board) {
    print('');
    print('Board: ${board.previous}');
    print('Enter 0 for Draw or the number of card to be played');
    hand.sort();
    print(hand);
    int option;
    do {
      option = _inputHandler();
      if (option < 0 || option > hand.size) {
        print('Please enter 0 to Draw or the number of the card to be played');
      }
    } while (option < 0 || option > hand.size);
    if (option == 0) {
      draw(board.draw());
    } else {
      Card played = hand.removeAt(option - 1);
      try {
        board.play(played);
      } on UnmatchedCardException catch (e) {
        hand.add(played);
        print(e.cause);
        play(board);
      }
    }
  }
}
