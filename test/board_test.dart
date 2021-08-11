import 'package:test/test.dart';
import 'package:joker/core.dart';
import 'package:joker/shell.dart';

void main() {
  final List<Player> players = [ShellPlayer(name: 'Test1')];
  final GameSettings gS = GameSettings(initialHandSize: 10);
  final Board board = Board(gameSettings: gS, players: players);
  
  test('The Board to start the game when initialized', () {
    expect(board.discardPile.size, 1);
    expect(board.previous, board.discardPile[0]);
    expect(board.drawPile.size, greaterThan(1));
    expect(players[0].hand.size, 10);
  });
}
