import 'package:spacemesh_reward_tracker/extensions/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('capitalize', () {
    test('capitalizes a lower-case word', () {
      const word = 'hello';
      expect(word.capitalize(), 'Hello');
    });

    test('leaves an already capitalized word unchanged', () {
      const word = 'Hello';
      expect(word.capitalize(), 'Hello');
    });

    test('capitalizes an upper-case word', () {
      const word = 'HELLO';
      expect(word.capitalize(), 'HELLO');
    });

    test('returns an empty string unchanged', () {
      const word = '';
      expect(word.capitalize(), '');
    });

    test('capitalizes a word with mixed case', () {
      const word = 'hElLo';
      expect(word.capitalize(), 'HElLo');
    });
  });
}
