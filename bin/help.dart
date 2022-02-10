const text = '''
Joker is a shedding type of card game where two or more players take turns to 
play a matching card on a board and aim at emptying the cards in their hands. 
The winner of the game is the first player who finishes their hand.

RULES:
- The game starts by dealing out a specific number of cards to each player and 
  then dealing out one to the board.
- Players then take turns by playing a matching card of choice onto the board.
- The played card's rank or suit must match the rank or suit of the card last 
  played on the board. The player taking a turn will have to draw a card from 
  the board if the player doesn't have a matching card in their hand.
- The first player to finish the cards in their hand wins the game.
- The Ace card skips the next player.
- The Jack card puts the board in command mode and the player must command a 
  particular suit of choice. Next players must play the commanded suit or 
  another Jack card.

USAGE: joker
       joker [commands] [options]

Use without arguments to start playing against Computer with default options. 

COMMANDS:
  help, --help, or -h
  Displays this help information.
  
  version, --version, or -v
  Displays the current version of joker.
  
OPTIONS:    
  --hand-size
  Sets the initial hand size for game play. Accepts any whole number from 1 to 10.
  
  --undo-redo/--no-undo-redo
  Enable undoing and redoing during game play.
  
  --include-jokers
  Whether to include the red and black joker cards in the game or not.
  
  --use-two-decks
  Whether to use two decks of cards in the game. Some cards will appear twice if this flag is used.

  --ace-skips-players
  Whether if a played Ace skips the next player to take turn.
  
  --observe-board-jack
  Whether to observe the suit of the Jack card played by the board on first dealing.
  
  --allow-jack-when-in-command
  Whether to permit players to change the card being commanded with a Jack of a different suit.
  
  --always-allow-jack
  Whether to permit Jack cards playing at anytime on the board, irrespective of the board's current suit.''';
