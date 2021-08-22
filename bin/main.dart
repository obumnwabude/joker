import 'dart:io';
import 'package:joker/shell.dart' as shell;
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import './help.dart' as help;

void main(List<String> arguments) async {
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
      } catch(e) {
        print('An Error occured!');
        print(e);
        exit(1);
      } 
    }
  }
  shell.ShellGame();
}
