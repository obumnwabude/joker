import 'dart:io';

import '../core/board.dart';
import '../core/card.dart';
import '../core/player.dart';

/// A player of the joker card game.
class ShellPlayer extends Player {
  /// Creates and returns a [ShellPlayer] with the given [name].
  ShellPlayer({required name}) : super(name: name);

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

  @override
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
