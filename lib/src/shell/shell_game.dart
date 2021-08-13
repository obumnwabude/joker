import '../core/board.dart';
import '../core/game.dart';
import '../core/game_settings.dart';
import '../core/system_player.dart';
import './shell_player.dart';

/// Contains the entry point for the joker card game.
class ShellGame extends Game {
  ShellGame() {
    var players = [ShellPlayer(name: 'Obum'), SystemPlayer(name: 'System')];
    var board =
        Board(gameSettings: GameSettings(initialHandSize: 5), players: players);
    var playerIndex = 0;

    while (!(players.any((player) => player.hand.isEmpty))) {
      players[playerIndex].play(board);
      if (playerIndex == 0)
        playerIndex = 1;
      else
        playerIndex = 0;
    }

    print('');
    print(
        '${players.firstWhere((player) => player.hand.isEmpty).name} won the game');
  }
}
