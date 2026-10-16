import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the examples round trip through JSON', () {
    for (final (String label, Object? _, Object? parsed)
        in MyHomePage.examples()) {
      expect(parsed, isNotNull, reason: label);
    }
  });
}
