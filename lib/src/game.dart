import './board.dart';
import './game_settings.dart';
import './player.dart';

/// Contains the entry point for the joker card game.
class Game {
  Game() {
    var players = [Player(name: 'Obum'), Player(name: 'Olisa')];
    var board =
        Board(gameSettings: GameSettings(initialHandSize: 1), players: players);
    var playerIndex = 0;

    while (!(players.any((player) => player.hand.isEmpty))) {
      players[playerIndex].play(board);
      if (playerIndex == 0)
        playerIndex = 1;
      else
        playerIndex = 0;
    }

    print('');
    print('${players[playerIndex].name} won the game');
  }
}

main() => Game();
