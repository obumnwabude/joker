import 'package:joker/shell.dart' as shell;
import './help.dart' as help;

void main(List<String> arguments) {
  if (['help', '--help', '-h'].any(arguments.contains)) {
    print(help.text);
  } else
    shell.ShellGame();
}
