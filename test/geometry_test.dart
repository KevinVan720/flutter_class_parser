import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('Offset', () {
    test('serializes dx and dy', () {
      expect(const Offset(1.5, -2).toJson(), {'dx': 1.5, 'dy': -2.0});
      expect(
          json.encode(const Offset(1.5, -2).toJson()), '{"dx":1.5,"dy":-2.0}');
    });

    test('round trips', () {
      for (final Offset offset in const [
        Offset.zero,
        Offset(1, 2),
        Offset(-0.25, 1e6),
      ]) {
        expect(parseOffset(jsonRoundTrip(offset.toJson())), offset);
      }
    });

    test('parses integers and missing values', () {
      expect(parseOffset(const {'dx': 1, 'dy': 2}), const Offset(1, 2));
      expect(parseOffset(const {'dx': 3}), const Offset(3, 0));
      expect(parseOffset(const {}), Offset.zero);
      expect(parseOffset(null), isNull);
    });
  });

  group('Size', () {
    test('serializes width and height', () {
      expect(json.encode(const Size(10, 20.5).toJson()),
          '{"width":10.0,"height":20.5}');
    });

    test('round trips', () {
      for (final Size size in const [Size.zero, Size(1, 2), Size(0.5, 300)]) {
        expect(parseSize(jsonRoundTrip(size.toJson())), size);
      }
    });

    test('parses integers and missing values', () {
      expect(parseSize(const {'width': 1, 'height': 2}), const Size(1, 2));
      expect(parseSize(const {'height': 2}), const Size(0, 2));
      expect(parseSize(null), isNull);
    });
  });

  group('Rect', () {
    test('serializes left, right, top and bottom', () {
      expect(json.encode(const Rect.fromLTRB(1, 2, 3, 4).toJson()),
          '{"left":1.0,"right":3.0,"top":2.0,"bottom":4.0}');
    });

    test('round trips', () {
      for (final Rect rect in const [
        Rect.zero,
        Rect.fromLTRB(1, 2, 3, 4),
        Rect.fromLTRB(-10.5, -20, 0.25, 7),
      ]) {
        expect(parseRect(jsonRoundTrip(rect.toJson())), rect);
      }
    });

    test('parses integers and missing values', () {
      expect(parseRect(const {'left': 1, 'top': 2, 'right': 3, 'bottom': 4}),
          const Rect.fromLTRB(1, 2, 3, 4));
      expect(parseRect(const {'right': 3, 'bottom': 4}),
          const Rect.fromLTRB(0, 0, 3, 4));
      expect(parseRect(null), isNull);
    });
  });

  group('EdgeInsets', () {
    test('serializes left, right, top and bottom', () {
      expect(json.encode(const EdgeInsets.fromLTRB(1, 2, 3, 4).toJson()),
          '{"left":1.0,"right":3.0,"top":2.0,"bottom":4.0}');
    });

    test('round trips', () {
      for (final EdgeInsets insets in const [
        EdgeInsets.zero,
        EdgeInsets.all(8),
        EdgeInsets.fromLTRB(1, 2, 3.5, 4),
        EdgeInsets.symmetric(horizontal: 12, vertical: 0.5),
      ]) {
        expect(parseEdgeInsets(jsonRoundTrip(insets.toJson())), insets);
      }
    });

    test('parses integers and missing values', () {
      expect(
          parseEdgeInsets(const {'left': 1, 'top': 2, 'right': 3, 'bottom': 4}),
          const EdgeInsets.fromLTRB(1, 2, 3, 4));
      expect(
          parseEdgeInsets(const {'left': 8}), const EdgeInsets.only(left: 8));
      expect(parseEdgeInsets(null), isNull);
    });

    test('parseEdgeInsetsGeometry parses "left,top,right,bottom" strings', () {
      expect(parseEdgeInsetsGeometry('1,2,3,4'),
          const EdgeInsets.fromLTRB(1, 2, 3, 4));
      expect(parseEdgeInsetsGeometry(' 1.5, 2 , 3,4.25 '),
          const EdgeInsets.fromLTRB(1.5, 2, 3, 4.25));
      expect(parseEdgeInsetsGeometry(null), isNull);
      expect(parseEdgeInsetsGeometry(''), isNull);
      expect(parseEdgeInsetsGeometry('   '), isNull);
    });
  });

  group('Radius', () {
    test('serializes x and y', () {
      expect(json.encode(const Radius.elliptical(1, 2.5).toJson()),
          '{"x":1.0,"y":2.5}');
    });

    test('round trips', () {
      for (final Radius radius in const [
        Radius.zero,
        Radius.circular(4),
        Radius.elliptical(1, 2.5),
      ]) {
        expect(parseRadius(jsonRoundTrip(radius.toJson())), radius);
        expect(
            RadiusToJsonExtension.fromJson(
                jsonRoundTrip(radius.toJson()) as Map<String, dynamic>),
            radius);
      }
    });

    test('parses integers and missing values', () {
      expect(
          parseRadius(const {'x': 1, 'y': 2}), const Radius.elliptical(1, 2));
      expect(RadiusToJsonExtension.fromJson(const {'x': 1, 'y': 2}),
          const Radius.elliptical(1, 2));
      expect(parseRadius(const {'x': 3}), const Radius.elliptical(3, 0));
      expect(parseRadius(null), isNull);
    });
  });

  group('BorderRadius', () {
    test('serializes each corner', () {
      const BorderRadius radius = BorderRadius.only(
        topLeft: Radius.circular(1),
        topRight: Radius.elliptical(2, 3),
        bottomLeft: Radius.zero,
        bottomRight: Radius.circular(4.5),
      );
      expect(
          json.encode(radius.toJson()),
          '{"topLeft":{"x":1.0,"y":1.0},"topRight":{"x":2.0,"y":3.0},'
          '"bottomLeft":{"x":0.0,"y":0.0},"bottomRight":{"x":4.5,"y":4.5}}');
    });

    test('round trips', () {
      for (final BorderRadius radius in [
        BorderRadius.zero,
        BorderRadius.circular(12),
        const BorderRadius.vertical(top: Radius.elliptical(1, 2)),
      ]) {
        expect(parseBorderRadius(jsonRoundTrip(radius.toJson())), radius);
      }
    });

    test('parses missing corners as zero', () {
      expect(
          parseBorderRadius(const {
            'topLeft': {'x': 1, 'y': 1},
          }),
          const BorderRadius.only(topLeft: Radius.circular(1)));
      expect(parseBorderRadius(const {}), BorderRadius.zero);
      expect(parseBorderRadius(null), isNull);
    });
  });

  group('Matrix4', () {
    test('serializes the column major storage', () {
      final Matrix4 matrix = Matrix4.translationValues(1, 2, 3);
      expect(matrix.toJson(), [
        1.0, 0.0, 0.0, 0.0, //
        0.0, 1.0, 0.0, 0.0, //
        0.0, 0.0, 1.0, 0.0, //
        1.0, 2.0, 3.0, 1.0, //
      ]);
    });

    test('round trips', () {
      for (final Matrix4 matrix in [
        Matrix4.identity(),
        Matrix4.zero(),
        Matrix4.rotationZ(0.5),
        Matrix4.diagonal3Values(2, 3.25, 1),
        Matrix4.translationValues(-1.5, 2, 0),
      ]) {
        expect(parseMatrix4(jsonRoundTrip(matrix.toJson())), matrix);
      }
    });

    test('parses integer values', () {
      // JSON written by hand or produced on the web has no ".0" suffixes.
      expect(
          parseMatrix4(
              json.decode('[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 2, 3, 1]')),
          Matrix4.translationValues(1, 2, 3));
    });

    test('parses null to null', () {
      expect(parseMatrix4(null), isNull);
    });
  });
}
