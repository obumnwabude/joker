import 'dart:collection';
import './card.dart';
import './board.dart';
import './player.dart';

/// Player actions on a [Board].
enum Action { commanded, drew, played, skipped }

/// A turn taken on the [Board].
class Turn {
  final Action action;
  final List<Card> cards;
  final Player player;
  final int commandedSuit;

  Turn(
      {this.commandedSuit = 0,
      required this.action,
      required this.cards,
      required this.player}) {
    if (action == Action.commanded &&
        (commandedSuit < 1 || commandedSuit > 4)) {
      throw NoCommandedSuitProvidedException(player);
    }
  }

  void execute(Board board) {
    switch (action) {
      case Action.skipped:
        break;
      case Action.drew:
        player.hand.add(cards[0]);
        break;
      default:
        board.discardPile.add(cards[0]);
    }
  }

  void undo(Board board) {
    switch (action) {
      case Action.skipped:
        break;
      case Action.drew:
        board.drawPile.add(player.hand.removeAt(player.hand.indexOf(cards[0])));
        break;
      default:
        player.hand.add(board.discardPile.removeLast());
    }
  }
}

/// Keeps record of [Turn]s on the [Board] and can [undo] or [redo] them.
class TurnStack {
  final Queue<Turn> _history = Queue();
  final Queue<Turn> _redos = Queue();

  /// The [Board] on which turns taken are recorded in this [TurnStack].
  final Board board;

  /// Can redo the previous turn
  bool get canRedo => _redos.isNotEmpty;

  /// Can undo the previous turn
  bool get canUndo => _history.isNotEmpty;

  /// The last turn taken on the [board]
  Turn get last => _history.last;

  /// Sets up a [TurnStack] on the provided [board].
  TurnStack(this.board);

  /// Add New Turn and Clear Redo Stack
  void add(Turn turn) {
    turn.execute(board);
    _history.addLast(turn);
    _redos.clear();
  }

  /// Redo Previous Undo
  void redo() {
    if (canRedo) _history.addLast(_redos.removeFirst()..execute(board));
  }

  /// Undo Last Action
  void undo() {
    if (canUndo) _redos.addFirst(_history.removeLast()..undo(board));
  }
}

/// Thrown when a [Action.commanded] action is taken but no
/// valid [Turn.commandedSuit] is provided. [Turn.commandedSuit] is valid only
/// when it is between 1 and 4, both ends inclusive.
class NoCommandedSuitProvidedException implements Exception {
  final Player player;
  String get cause => '$player did not specify a suit to command.';
  NoCommandedSuitProvidedException(this.player);
}
