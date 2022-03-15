import 'card.dart';
import 'board.dart';
import 'joker_exception.dart';
import 'player.dart';

/// Thrown when a [Player] attempts to play a [Card] whose [Card.rank] or
/// [Card.suit] does not match the [Board.previous] [Card] on the [Board].
class UnmatchedCardException implements JokerException {
  final Card played;
  final Card previous;
  String get cause => 'Played "$played" does not match previous "$previous".';
  UnmatchedCardException({required this.played, required this.previous});
}

/// Thrown when a [Player] attempts to play a [Card] whose [Card.suit] does not
/// match the [Board.state.commandedSuit] on the [Board].
class UnmatchedCommandedSuitException implements JokerException {
  final Card played;
  final int suit;
  final bool isJackAllowed;
  String get cause =>
      'Played "$played" does not match commanded suit: "${Card.suits[suit]}"' +
      (isJackAllowed ? ' or is not a Jack.' : '');
  UnmatchedCommandedSuitException({
    required this.played,
    required this.suit,
    required this.isJackAllowed,
  });
}
