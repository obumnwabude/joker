import 'dart:collection';
import './card.dart';
import './board.dart';
import './player.dart';

/// A turn taken on the [Board].
class Turn {
  String action;
  Card card;
  Board board;
  Player player;

  Turn(
      {required this.action,
      required this.card,
      required this.board,
      required this.player});

  void execute() {
    if (action == 'played') {
      board.discardPile.add(card);
    } else {
      player.hand.add(card);
    }
  }

  void undo() {
    if (action == 'played') {
      player.hand.add(board.discardPile.removeLast());
    } else {
      board.drawPile.add(player.hand.removeAt(player.hand.indexOf(card)));
    }
  }
}

/// Keeps record of [Turn]s on the [Board] and can [undo] or [redo] them.
class TurnStack {
  final Queue<Turn> _history = Queue();
  final Queue<Turn> _redos = Queue();

  /// Can redo the previous turn
  bool get canRedo => _redos.isNotEmpty;

  /// Can undo the previous turn
  bool get canUndo => _history.isNotEmpty;

  /// Add New Turn and Clear Redo Stack
  void add(Turn turn) {
    turn.execute();
    _history.addLast(turn);
    _redos.clear();
  }

  /// Redo Previous Undo
  void redo() {
    if (canRedo) {
      final turn = _redos.removeFirst();
      turn.execute();
      _history.addLast(turn);
    }
  }

  /// Undo Last Action
  void undo() {
    if (canUndo) {
      final turn = _history.removeLast();
      turn.undo();
      _redos.addFirst(turn);
    }
  }
}
