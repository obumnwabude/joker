import '../core/board.dart';
import '../core/card.dart';
import '../core/game.dart';
import '../core/game_settings.dart';
import '../core/system_player.dart';
import '../core/turn_stack.dart';
import './shell_player.dart';

/// Contains the entry point for the joker card game.
class ShellGame extends Game {
  ShellGame(GameSettings gameSettings) {
    var players = [ShellPlayer(), SystemPlayer(name: 'Computer')];
    var board = Board(gameSettings: gameSettings, players: players);
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

      if (board.isInCommand) {
        print('Board is in command. Play requested suit: ' +
            '"${Card.suits[board.commandedSuit]}" or draw');
      }
      board.enter(players[playerIndex]);
      if (board.turns.last.action == Action.skipped) {
        if (players[playerIndex] is ShellPlayer) {
          print('You have been skipped');
        } else {
          print('${players[playerIndex].name} has been skipped');
        }
      } else if (players[playerIndex] is SystemPlayer) {
        if (board.turns.last.action == Action.drew) {
          print('${players[playerIndex].name} drew a card from board');
        } else if (board.turns.last.action == Action.played) {
          print('${players[playerIndex].name} played "${board.previous}"');
        }
      }
      playerIndex = playerIndex == 0 ? 1 : 0;
    }

    print('');
    print(
        '${players.firstWhere((player) => player.hand.isEmpty).name} won the game');
  }
}
