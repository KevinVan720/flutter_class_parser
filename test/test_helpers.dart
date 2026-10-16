import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

/// Encodes [value] to a JSON string and decodes it again, like an app that
/// stores the serialized value and loads it later.
///
/// Note that `json.decode` yields an `int` for numbers written without a
/// fraction (for example `1`), so parsers must not assume `double`s.
dynamic jsonRoundTrip(Object? value) => json.decode(json.encode(value));

/// Checks the common contract of the enum serializers: `toJson` returns the
/// enum value's name and the parser turns it back into the same value.
void testEnumParsing<T extends Enum>(
  String description,
  List<T> values,
  String Function(T value) toJson,
  T? Function(String? string) parse,
) {
  group(description, () {
    test('toJson returns the name of the value', () {
      for (final T value in values) {
        expect(toJson(value), value.name);
      }
    });

    test('round trips every value through JSON', () {
      for (final T value in values) {
        expect(parse(jsonRoundTrip(toJson(value)) as String), value);
      }
    });

    test('parses null and unknown strings to null', () {
      expect(parse(null), isNull);
      expect(parse(''), isNull);
      expect(parse('notAValue'), isNull);
      expect(parse('$T.${values.first.name}'), isNull);
    });
  });
}
