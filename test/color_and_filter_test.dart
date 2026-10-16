import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('Color', () {
    test('serializes to unpadded lowercase ARGB hex', () {
      expect(const Color(0xff2196f3).toJson(), 'ff2196f3');
      expect(const Color(0x802196F3).toJson(), '802196f3');
      expect(const Color(0x0f000000).toJson(), 'f000000');
      expect(const Color(0x000000ff).toJson(), 'ff');
      expect(const Color(0x00000000).toJson(), '0');
    });

    test('serializes a ColorSwatch as its primary color', () {
      const Color swatch = ColorSwatch(0xffffc107, <int, Color>{});
      expect(swatch.toJson(), 'ffffc107');
    });

    test('serializes colors created from floating point components', () {
      expect(const Color.from(alpha: 1, red: 1, green: 0, blue: 0).toJson(),
          'ffff0000');
      expect(const Color.fromARGB(0x80, 0x12, 0x34, 0x56).toJson(), '80123456');
    });

    test('round trips', () {
      for (final Color color in const [
        Color(0x00000000),
        Color(0x0000ff00),
        Color(0x1f000000),
        Color(0x802196f3),
        Color(0xffffc107),
        Color(0xffffffff),
      ]) {
        expect(parseColor(jsonRoundTrip(color.toJson())), color);
      }
    });

    test('parses padded and upper case hex', () {
      expect(parseColor('0000ff00'), const Color(0x0000ff00));
      expect(parseColor('FF2196F3'), const Color(0xff2196f3));
    });

    test('parses null to null and invalid strings to white', () {
      expect(parseColor(null), isNull);
      expect(parseColor('not a color'), const Color(0xffffffff));
      expect(parseColor(''), const Color(0xffffffff));
    });
  });

  group('ColorFilter', () {
    test('serializes a mode filter', () {
      const ColorFilter filter =
          ColorFilter.mode(Color(0x802196f3), BlendMode.multiply);
      expect(filter.toJson(),
          {'color': '802196f3', 'mode': 'multiply', 'type': 'ColorFilter'});
      expect(json.encode(filter.toJson()),
          '{"color":"802196f3","mode":"multiply","type":"ColorFilter"}');
    });

    test('serializes the color as eight hex digits like older versions', () {
      // Before Flutter 3.27 the color was taken from the "Color(0x0000ff00)"
      // debug string, so it was always zero padded to eight digits.
      expect(
          const ColorFilter.mode(Color(0x0000ff00), BlendMode.src)
              .toJson()['color'],
          '0000ff00');
      expect(
          const ColorFilter.mode(Color(0x00000000), BlendMode.clear)
              .toJson()['color'],
          '00000000');
    });

    test('serializes the primary color of a ColorSwatch', () {
      const ColorFilter filter = ColorFilter.mode(
          ColorSwatch(0xffffc107, <int, Color>{}), BlendMode.color);
      expect(filter.toJson(),
          {'color': 'ffffc107', 'mode': 'color', 'type': 'ColorFilter'});
    });

    test('round trips mode filters', () {
      for (final BlendMode mode in BlendMode.values) {
        for (final Color color in const [
          Color(0x00000000),
          Color(0x0000ff00),
          Color(0x802196f3),
          Color(0xffffc107),
        ]) {
          final ColorFilter filter = ColorFilter.mode(color, mode);
          expect(parseColorFilter(jsonRoundTrip(filter.toJson())), filter);
        }
      }
    });

    test('round trips matrix filters', () {
      const ColorFilter greyscale = ColorFilter.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0, //
        0, 0, 0, 1, 0, //
      ]);
      expect(greyscale.toJson()['type'], 'ColorFilter');
      expect(parseColorFilter(jsonRoundTrip(greyscale.toJson())), greyscale);

      const ColorFilter invert = ColorFilter.matrix(<double>[
        -1, 0, 0, 0, 255, //
        0, -1, 0, 0, 255, //
        0, 0, -1, 0, 255, //
        0, 0, 0, 1, 0, //
      ]);
      expect(parseColorFilter(jsonRoundTrip(invert.toJson())), invert);
    });

    test('parses legacy and partial JSON', () {
      expect(parseColorFilter(const {'color': 'ff2196f3', 'mode': 'multiply'}),
          const ColorFilter.mode(Color(0xff2196f3), BlendMode.multiply));
      expect(parseColorFilter(const {'color': 'ff2196f3'}),
          const ColorFilter.mode(Color(0xff2196f3), BlendMode.src));
      expect(parseColorFilter(const {'mode': 'multiply'}),
          const ColorFilter.mode(Color(0x00000000), BlendMode.multiply));
    });

    test('parses null and empty JSON to null', () {
      expect(parseColorFilter(null), isNull);
      // Unsupported filters serialize to an empty map. Parsing it used to
      // return a transparent BlendMode.src filter that erased the image.
      const ColorFilter gamma = ColorFilter.linearToSrgbGamma();
      expect(gamma.toJson(), isEmpty);
      expect(parseColorFilter(jsonRoundTrip(gamma.toJson())), isNull);
      expect(parseColorFilter(const {}), isNull);
    });
  });

  group('ImageFilter', () {
    test('serializes a blur filter', () {
      final ui.ImageFilter filter = ui.ImageFilter.blur(
          sigmaX: 2, sigmaY: 3.5, tileMode: TileMode.mirror);
      expect(filter.toJson(), {
        'sigmaX': 2.0,
        'sigmaY': 3.5,
        'tileMode': 'mirror',
        'type': 'ImageFilter',
      });
      expect(json.encode(filter.toJson()),
          '{"sigmaX":2.0,"sigmaY":3.5,"tileMode":"mirror","type":"ImageFilter"}');
    });

    test('round trips blur filters', () {
      for (final TileMode tileMode in TileMode.values) {
        final ui.ImageFilter filter =
            ui.ImageFilter.blur(sigmaX: 1.25, sigmaY: 0, tileMode: tileMode);
        expect(parseImageFilter(jsonRoundTrip(filter.toJson())), filter);
      }
    });

    test('round trips a blur filter without a tile mode', () {
      final ui.ImageFilter filter = ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4);
      expect(parseImageFilter(jsonRoundTrip(filter.toJson())), filter);
    });

    test('serializes and parses a ColorFilter used as an ImageFilter', () {
      const ui.ImageFilter filter =
          ColorFilter.mode(Color(0xff2196f3), BlendMode.color);
      expect(filter.toJson(),
          {'color': 'ff2196f3', 'mode': 'color', 'type': 'ColorFilter'});
      expect(parseImageFilter(jsonRoundTrip(filter.toJson())), filter);
    });

    test('serializes unsupported filters to an empty map', () {
      final ui.ImageFilter matrix =
          ui.ImageFilter.matrix(Matrix4.identity().storage);
      expect(matrix.toJson(), isEmpty);
      expect(parseImageFilter(matrix.toJson()), isNull);
      final ui.ImageFilter composed = ui.ImageFilter.compose(
          outer: ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1), inner: matrix);
      expect(composed.toJson(), isEmpty);
    });

    test('parses hand written JSON with integer values', () {
      expect(
          parseImageFilter(const {
            'type': 'ImageFilter',
            'sigmaX': 2,
            'sigmaY': 3,
            'tileMode': 'decal',
          }),
          ui.ImageFilter.blur(sigmaX: 2, sigmaY: 3, tileMode: TileMode.decal));
      expect(parseImageFilter(const {'type': 'ImageFilter', 'sigmaX': 2}),
          ui.ImageFilter.blur(sigmaX: 2, sigmaY: 0, tileMode: TileMode.clamp));
    });

    test('parses null and unknown JSON to null', () {
      expect(parseImageFilter(null), isNull);
      expect(parseImageFilter(const {}), isNull);
      expect(parseImageFilter(const {'type': 'ImageFilter'}), isNull);
      expect(parseImageFilter(const {'type': 'Unknown', 'sigmaX': 1}), isNull);
    });
  });
}
