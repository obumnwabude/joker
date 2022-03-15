/// Contains flags and values that indicate the [Board]'s next action.
class BoardState {
  final bool isInCommand;
  final bool isInPick;
  final bool isInSkip;
  final int commandedSuit;
  final int noCardsToBePicked;
  BoardState({
    this.commandedSuit = 0,
    this.isInCommand = false,
    this.isInPick = false,
    this.isInSkip = false,
    this.noCardsToBePicked = 0,
  }) {
    assert((!isInCommand && commandedSuit == 0) ||
        (isInCommand && (commandedSuit >= 1 && commandedSuit <= 4)));
    assert((!isInPick && noCardsToBePicked == 0) ||
        (isInPick && noCardsToBePicked > 0));
  }
}
