import 'package:test/test.dart';
import 'package:joker/joker.dart';

void main() {
  test('Players can be created', () {
    expect(Player(name: 'test').name, 'test');
  });
}
