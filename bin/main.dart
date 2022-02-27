import 'dart:io';
import 'package:args/args.dart';
import 'package:joker/core.dart';
import 'package:joker/shell.dart' as shell;
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import './help.dart' as help;

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    shell.ShellGame(GameSettings.defaults());
  } else {
    for (int i = 0; i < arguments.length; i++) {
      if (['help', '--help', '-h'].contains(arguments[i])) {
        print(help.text);
        exit(0);
      } else if (['version', '--version', '-v'].contains(arguments[i])) {
        try {
          File f = new File(
              join(dirname(Platform.script.toFilePath()), '../pubspec.yaml'));
          String text = await f.readAsString();
          Map yaml = loadYaml(text);
          print('Joker');
          print('Version ${yaml['version']}');
          exit(0);
        } catch (e) {
          print('An Error occured!');
          print(e);
          exit(1);
        }
      }
    }

    final parser = ArgParser()
      ..addOption(
        'hand-size',
        allowed: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
        defaultsTo: '5',
      )
      ..addFlag('undo-redo', defaultsTo: false)
      ..addFlag('use-two-decks', negatable: false, defaultsTo: false)
      ..addFlag('include-jokers', negatable: false, defaultsTo: true)
      ..addFlag('ace-skips-players', negatable: false, defaultsTo: true)
      ..addFlag('allow-any-on-board-jack', negatable: false, defaultsTo: true)
      ..addFlag(
        'allow-jack-when-in-command',
        negatable: false,
        defaultsTo: true,
      )
      ..addFlag('always-allow-jack', negatable: false, defaultsTo: true)
      ..addFlag('seven-picks-two', negatable: false, defaultsTo: true)
      ..addFlag('joker-picks-four', negatable: false, defaultsTo: true);
    final results = parser.parse(arguments);
    final gameSettings = GameSettings(
      aceSkipsPlayers: results['ace-skips-players'],
      allowAnyOnBoardJack: results['allow-any-on-board-jack'],
      allowJackWhenInCommand: results['allow-jack-when-in-command'],
      alwaysAllowJack: !results['always-allow-jack'],
      enableUndoRedo: results['undo-redo'],
      includeJokers: results['include-jokers'],
      initialHandSize: int.parse(results['hand-size']),
      jokerPicksFour: results['joker-picks-four'],
      sevenPicksTwo: results['seven-picks-two'],
      useTwoDecks: results['use-two-decks'],
    );
    shell.ShellGame(gameSettings);
  }
}
