import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('TextStyle', () {
    const TextStyle fullStyle = TextStyle(
      color: Color(0xff2196f3),
      backgroundColor: Color(0x1f000000),
      fontSize: 14.5,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
      letterSpacing: 1.25,
      wordSpacing: 2,
      textBaseline: TextBaseline.ideographic,
      height: 1.5,
      decoration: TextDecoration.underline,
      decorationColor: Color(0xfff44336),
      decorationStyle: TextDecorationStyle.wavy,
      decorationThickness: 3,
      fontFamily: 'Roboto',
    );

    test('serializes to JSON', () {
      expect(json.encode(const TextStyle().toJson()), '{}');
      expect(
          json.encode(fullStyle.toJson()),
          '{"color":"ff2196f3","backgroundColor":"1f000000","fontSize":14.5,'
          '"fontWeight":"w600","fontStyle":"italic","letterSpacing":1.25,'
          '"wordSpacing":2.0,"textBaseline":"ideographic","height":1.5,'
          '"decoration":"underline","decorationColor":"fff44336",'
          '"decorationStyle":"wavy","decorationThickness":3.0,'
          '"fontFamily":"Roboto"}');
    });

    test('round trips all serialized properties', () {
      expect(parseTextStyle(jsonRoundTrip(fullStyle.toJson())), fullStyle);
    });

    test('round trips combined decorations', () {
      final TextStyle style = TextStyle(
        decoration: TextDecoration.combine(
            [TextDecoration.overline, TextDecoration.lineThrough]),
        fontStyle: FontStyle.normal,
      );
      expect(parseTextStyle(jsonRoundTrip(style.toJson())), style);
    });

    test('parses a missing font style as FontStyle.normal', () {
      // Established behavior: the parser always sets a font style.
      const TextStyle style = TextStyle(color: Color(0x1f000000));
      expect(parseTextStyle(jsonRoundTrip(style.toJson())),
          style.copyWith(fontStyle: FontStyle.normal));
    });

    test('parses JSON with only some properties', () {
      expect(parseTextStyle(const {}),
          const TextStyle(fontStyle: FontStyle.normal));
      expect(
          parseTextStyle(const {'fontWeight': 'w700', 'letterSpacing': 12}),
          const TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              letterSpacing: 12));
    });

    test('parses integer values', () {
      expect(
          parseTextStyle(const {
            'fontSize': 14,
            'letterSpacing': 1,
            'wordSpacing': 2,
            'height': 3,
            'decorationThickness': 4,
          }),
          const TextStyle(
            fontSize: 14,
            letterSpacing: 1,
            wordSpacing: 2,
            height: 3,
            decorationThickness: 4,
            fontStyle: FontStyle.normal,
          ));
    });

    test('parses null to null', () {
      expect(parseTextStyle(null), isNull);
    });
  });
}
