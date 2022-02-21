import '../core/board.dart';
import '../core/card.dart';
import '../core/game.dart';
import '../core/game_settings.dart';
import '../core/system_player.dart';
import '../core/player.dart';
import '../core/turn_stack.dart';
import './shell_player.dart';

/// Contains the entry point for the joker card game.
class ShellGame extends Game {
  ShellGame(GameSettings gameSettings) {
    List<Player> players = [ShellPlayer(), SystemPlayer(name: 'Computer')];
    Board board = Board(players, gameSettings);
    int i = 0;

    while (!(players.any((player) => player.hand.isEmpty))) {
      if (players[i] is ShellPlayer) {
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
            i = i == 0 ? 1 : 0;
          }
        }
      }

      if (board.isInCommand) {
        print('Board is in command. Play requested suit: ' +
            '"${Card.suits[board.commandedSuit]}" or draw');
      }
      board.enter(players[i]);
      if (board.turns.last.action == Action.skipped) {
        if (players[i] is ShellPlayer) {
          print('You have been skipped');
        } else {
          print('${players[i].name} has been skipped');
        }
      } else if (board.turns.last.action == Action.picked) {
        int no = board.turns.last.cards.length;
        print('${players[i].name} picked $no cards.');
      } else if (players[i] is SystemPlayer) {
        if (board.turns.last.action == Action.drew) {
          print('${players[i].name} drew a card from board');
        } else if (board.turns.last.action == Action.played) {
          print('${players[i].name} played "${board.previous}"');
        }
      }
      i = i == 0 ? 1 : 0;
    }

    print('');
    print(
        '${players.firstWhere((player) => player.hand.isEmpty).name} won the game');
  }
}
