import 'dart:io';
import '../core/board.dart';
import '../core/card.dart';
import '../core/card_collection.dart';
import '../core/joker_exception.dart';
import '../core/player.dart';

/// An external player of the joker card game in the terminal.
class ShellPlayer implements Player {
  final String name;
  final CardCollection hand;

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
  ShellPlayer()
      : name = 'You',
        hand = CardCollection(label: 'your hand');

  @override
  void draw(Board board) => board.draw(this);

  @override
  void play(Board board) {
    print('');
    print('Board: ${board.previous}');
    print('Enter 0 for Draw or the number of card to be played');
    hand.sort();
    print(hand);
    int option = getUserChoice(limit: hand.size);

    if (option == 0) {
      // The following was not the best solution to show the ShellPlayer the
      // card they board just gave them, but it was the easiest solution.
      CardCollection oldHand = CardCollection(label: 'My Old Hand');
      hand.forEach((card) => oldHand.add(Card.clone(card)));

      // draw from board
      draw(board);

      // determine the newly added card and display
      Card newCard = hand.firstWhere((card) => oldHand.contains(card));
      print('Board gave you $newCard');
    } else {
      Card played = hand.removeAt(option - 1);
      try {
        board.play(this, played);
      } on JokerException catch (e) {
        hand.add(played);
        print(e.cause);
        play(board);
      }
    }
  }
}
