/// A card object representing a real life playing card like Ace of Clubs.
class Card implements Comparable<Card> {
  /// Holds the rank of this [Card].
  ///
  /// Runs from `1` to `14`. `1` for `Ace`, `2` to `10` for their respective
  /// numbers, `11` for `Jack`, `12` for `Queen`, `13` for `King`, and `14` for
  /// `Joker` card.
  final int rank;

  /// Holds the suit of the [Card].
  ///
  /// Runs from `1` to `6`. `1` for `Clubs`, `2` to `Diamonds`, `3` for
  /// `Hearts`, `4` for `Spades`, `5` for `Black`, and `6` for `Red`.
  ///
  /// These last two suits are for the two `Joker` cards with the black and red
  /// colors. During card matching in the game, the `Black` suit matches with
  /// both `Clubs` and `Spades`, while the `Red` suit matches with both
  /// `Diamonds` and `Hearts`.
  final int suit;

  /// List of all [rank] names. Useful for [toString].
  static final List<String> ranks = [
    '',
    'Ace',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'Jack',
    'Queen',
    'King',
    'Joker'
  ];

  /// List of all [suit] names. Useful for [toString].
  static final List<String> suits = [
    '',
    'Clubs',
    'Diamonds',
    'Hearts',
    'Spades',
    'Black',
    'Red'
  ];

  /// Creates and returns a [Card] whose [rank] and [suit] are immutable.
  ///
  /// The [rank] should be a number from `1` to `14`. `1` for `Ace`, `2` to `10`
  /// for their respective numbers, `11` for `Jack`, `12` for `Queen`, `13` for
  /// `King`, and `14` for `Joker` card.
  ///
  /// The [suit] should be a number from `1` to `6`. `1` for `Clubs`, `2` to
  /// `Diamonds`, `3` for `Hearts`, `4` for `Spades`, `5` for `Black`, and `6`
  /// for `Red`.
  Card(this.rank, this.suit);

  /// Creates and returns a [Card] whose [rank] and [suit] are those of [other].
  factory Card.clone(Card other) => Card(other.rank, other.suit);

  @override
  String toString() {
    if (rank == 14)
      return '${suits[suit]} ${ranks[rank]}';
    else
      return '${ranks[rank]} of ${suits[suit]}';
  }

  @override
  bool operator ==(Object other) {
    if (other is Card)
      return rank == other.rank && suit == other.suit;
    else
      return false;
  }

  @override
  int get hashCode => rank * suit;

  @override
  int compareTo(Card other) {
    if (suit > other.suit) {
      return 1;
    } else if (suit < other.suit) {
      return -1;
    } else if (rank > other.rank) {
      return 1;
    } else if (rank < other.rank) {
      return -1;
    } else {
      return 0;
    }
  }

  /// Checks if the [suit] of this [Card] matches [other].
  ///
  /// In addition to exact [suit] matching, the `Black` [suit] matches `Clubs`
  /// and `Spades` while the `Red` [suit] matches the `Diamonds` and the
  /// `Hearts` suit.
  bool matchSuit(int other) {
    if (suit == other) return true;
    if (suit == 5 || other == 5) {
      if (other == 1 || suit == 1) return true;
      if (other == 4 || suit == 4) return true;
    }
    if (suit == 6 || other == 6) {
      if (other == 2 || suit == 2) return true;
      if (other == 3 || suit == 3) return true;
    }
    return false;
  }
}
