import 'dart:io';
import '../core/board.dart';
import '../core/card.dart';
import '../core/player.dart';

/// An external player of the joker card game in the terminal.
class ShellPlayer extends Player {
  /// Gets the user choice of from `0` to [limit].
  static int getUserChoice({required int limit}) {
    var line = stdin.readLineSync()?.trim();
    int chosen;
    try {
      chosen = int.parse(line!);

      if (chosen < 0 || chosen > limit) {
        print('Invalid input entered');
        chosen = getUserChoice(limit: limit);
      }
    } on FormatException {
      print('Invalid input entered');
      chosen = getUserChoice(limit: limit);
    }
    return chosen;
  }

  /// Creates and returns a [ShellPlayer] with the given [name].
  ShellPlayer({required name}) : super(name: name);

  @override
  void play(Board board) {
    print('');
    print('Board: ${board.previous}');
    print('Enter 0 for Draw or the number of card to be played');
    hand.sort();
    print(hand);
    int option = getUserChoice(limit: hand.size);

    if (option == 0) {
      draw(board);
    } else {
      Card played = hand.removeAt(option - 1);
      try {
        board.play(this, played);
      } on UnmatchedCardException catch (e) {
        hand.add(played);
        print(e.cause);
        play(board);
      }
    }
  }
}
