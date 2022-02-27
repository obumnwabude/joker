import 'dart:collection';
import './card.dart';
import './board.dart';
import './player.dart';

/// Player actions on a [Board].
enum Action { commanded, drew, picked, played, skipped }

/// A turn taken on the [Board].
class Turn {
  final Action action;
  final List<Card> cards;
  final Player player;
  final BoardState state;

  Turn(this.action, this.cards, this.player, this.state);

  void execute(Board board) {
    switch (action) {
      case Action.skipped:
        break;
      case Action.drew:
      case Action.picked:
        cards.forEach((c) => player.hand.add(c));
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
      case Action.picked:
        cards.forEach((c) =>
            board.drawPile.add(player.hand.removeAt(player.hand.indexOf(c))));
        break;
      default:
        player.hand.add(board.discardPile.removeLast());
    }
    board.state = state;
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

  /// Clears undos and redos
  void reset() {
    _history.clear();
    _redos.clear();
  }
}
