import './board.dart';
import './game_settings.dart';
import './player.dart';

/// Contains the entry point for the joker card game.
class Game {
  /// The [Player]s that play this `Game`.
  final List<Player> players = [Player(name: 'Obum'), Player(name: 'Olisa')];

  Game() {
    Board(gameSettings: GameSettings(initialHandSize: 5), players: players);
    players.forEach((player) {
      print(player.hand);
      print('');
    });
  }
}

main() => Game();
