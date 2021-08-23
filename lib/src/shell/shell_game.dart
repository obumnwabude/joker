import '../core/board.dart';
import '../core/game.dart';
import '../core/game_settings.dart';
import '../core/system_player.dart';
import './shell_player.dart';

/// Contains the entry point for the joker card game.
class ShellGame extends Game {
  ShellGame() {
    var players = [ShellPlayer(), SystemPlayer(name: 'Computer')];
    var board =
        Board(gameSettings: GameSettings.defaults(), players: players);
    var playerIndex = 0;

    while (!(players.any((player) => player.hand.isEmpty))) {
      if (players[playerIndex] is ShellPlayer) {
        while (board.canUndo || board.canRedo) {
          print('');
          Map<int, String> commands = {0: 'Play'};
          if (board.canUndo) commands[commands.length] = 'Undo';
          if (board.canRedo) commands[commands.length] = 'Redo';
          print('Enter number of what you want to do');
          commands.forEach((key, value) => print('  $key. $value'));
          int option = ShellPlayer.getUserChoice(limit: commands.length - 1);

          if (option == 0) {
            break;
          } else {
            if (commands[option] == 'Undo') board.undo();
            if (commands[option] == 'Redo') board.redo();
            print('Board: ${board.previous}');
            playerIndex = playerIndex == 0 ? 1 : 0;
          }
        }
      }

      players[playerIndex].play(board);
      playerIndex = playerIndex == 0 ? 1 : 0;
    }

    print('');
    print(
        '${players.firstWhere((player) => player.hand.isEmpty).name} won the game');
  }
}
