import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

const Color red = Color(0xfff44336);
const Color blue = Color(0xff2196f3);
const Color translucent = Color(0x802196f3);

void main() {
  group('LinearGradient', () {
    test('serializes to JSON', () {
      expect(
          json.encode(const LinearGradient(colors: [red, blue]).toJson()),
          '{"colors":["fff44336","ff2196f3"],"type":"LinearGradient",'
          '"begin":"centerLeft","end":"centerRight","tileMode":"clamp"}');
      expect(
          json.encode(const LinearGradient(
            begin: Alignment(0.1, 0.2),
            end: Alignment.bottomRight,
            colors: [red, blue, translucent],
            stops: [0, 0.5, 1],
            tileMode: TileMode.mirror,
          ).toJson()),
          '{"stops":[0.0,0.5,1.0],"colors":["fff44336","ff2196f3","802196f3"],'
          '"type":"LinearGradient","begin":"(0.1, 0.2)","end":"bottomRight",'
          '"tileMode":"mirror"}');
    });

    test('round trips', () {
      for (final Gradient gradient in const [
        LinearGradient(colors: [red, blue]),
        LinearGradient(
          begin: Alignment(0.1, 0.2),
          end: Alignment(0.75, -1 / 3),
          colors: [red, blue, translucent],
          stops: [0, 0.25, 1],
          tileMode: TileMode.repeated,
        ),
      ]) {
        expect(parseGradient(jsonRoundTrip(gradient.toJson())), gradient);
      }
    });

    test('parses integer stops and missing values', () {
      expect(
          parseGradient(const {
            'colors': ['fff44336', 'ff2196f3'],
            'stops': [0, 1],
          }),
          const LinearGradient(colors: [red, blue], stops: [0, 1]));
      expect(parseGradient(null), isNull);
    });
  });

  group('RadialGradient', () {
    test('serializes to JSON', () {
      expect(
          json.encode(const RadialGradient(colors: [red, blue]).toJson()),
          '{"colors":["fff44336","ff2196f3"],"type":"RadialGradient",'
          '"center":"center","radius":0.5,"tileMode":"clamp"}');
    });

    test('round trips', () {
      for (final Gradient gradient in const [
        RadialGradient(colors: [red, blue]),
        RadialGradient(
          center: Alignment(-0.25, 0.5),
          radius: 2,
          colors: [red, blue, translucent],
          stops: [0, 0.25, 1],
          tileMode: TileMode.decal,
        ),
      ]) {
        expect(parseGradient(jsonRoundTrip(gradient.toJson())), gradient);
      }
    });

    test('parses integer and missing values', () {
      expect(
          parseGradient(const {
            'type': 'RadialGradient',
            'colors': ['fff44336', 'ff2196f3'],
            'radius': 1,
          }),
          const RadialGradient(colors: [red, blue], radius: 1));
      expect(
          parseGradient(const {
            'type': 'RadialGradient',
            'colors': ['fff44336', 'ff2196f3'],
          }),
          const RadialGradient(colors: [red, blue]));
    });
  });

  group('SweepGradient', () {
    test('serializes to JSON', () {
      expect(
          json.encode(const SweepGradient(
                  colors: [red, blue], startAngle: 0.5, endAngle: 3)
              .toJson()),
          '{"colors":["fff44336","ff2196f3"],"type":"SweepGradient",'
          '"center":"center","startAngle":0.5,"endAngle":3.0,'
          '"tileMode":"clamp"}');
    });

    test('round trips', () {
      for (final Gradient gradient in const [
        SweepGradient(colors: [red, blue]),
        SweepGradient(
          center: Alignment.topLeft,
          startAngle: 0.25,
          endAngle: math.pi,
          colors: [red, blue, translucent],
          stops: [0, 0.25, 1],
          tileMode: TileMode.mirror,
        ),
      ]) {
        expect(parseGradient(jsonRoundTrip(gradient.toJson())), gradient);
      }
    });

    test('parses integer and missing values', () {
      expect(
          parseGradient(const {
            'type': 'SweepGradient',
            'colors': ['fff44336', 'ff2196f3'],
            'startAngle': 1,
            'endAngle': 2,
          }),
          const SweepGradient(colors: [red, blue], startAngle: 1, endAngle: 2));
      expect(
          parseGradient(const {
            'type': 'SweepGradient',
            'colors': ['fff44336', 'ff2196f3'],
          }),
          const SweepGradient(colors: [red, blue]));
    });
  });

  group('Shadow', () {
    test('serializes to JSON', () {
      expect(
          json.encode(const Shadow(
                  color: translucent, offset: Offset(1, 2), blurRadius: 3)
              .toJson()),
          '{"color":"802196f3","offset":{"dx":1.0,"dy":2.0},"blurRadius":3.0}');
    });

    test('round trips', () {
      for (final Shadow shadow in const [
        Shadow(),
        Shadow(color: translucent, offset: Offset(1, -2), blurRadius: 3.5),
      ]) {
        expect(parseShadow(jsonRoundTrip(shadow.toJson())), shadow);
      }
    });

    test('serializes a BoxShadow as a Shadow', () {
      const BoxShadow boxShadow = BoxShadow(
          color: red, offset: Offset(1, 2), blurRadius: 3, spreadRadius: 4);
      expect(boxShadow.toJson(), {
        'color': 'fff44336',
        'offset': {'dx': 1.0, 'dy': 2.0},
        'blurRadius': 3.0,
      });
      expect(parseShadow(jsonRoundTrip(boxShadow.toJson())),
          const Shadow(color: red, offset: Offset(1, 2), blurRadius: 3));
    });

    test('parses integer and missing values', () {
      expect(
          parseShadow(const {
            'offset': {'dx': 1, 'dy': 2},
            'blurRadius': 3,
          }),
          const Shadow(
              color: Color(0x00000000), offset: Offset(1, 2), blurRadius: 3));
      expect(parseShadow(const {}), const Shadow(color: Color(0x00000000)));
      expect(parseShadow(null), isNull);
    });
  });

  group('ImageProvider', () {
    test('serializes a NetworkImage', () {
      expect(
          json.encode(const NetworkImage('https://example.com/a.png', scale: 2)
              .toJson()),
          '{"type":"NetworkImage","url":"https://example.com/a.png",'
          '"scale":2.0}');
    });

    test('serializes an AssetImage', () {
      expect(
          json.encode(
              const AssetImage('images/a.png', package: 'pkg').toJson()),
          '{"type":"AssetImage","assetName":"images/a.png","package":"pkg"}');
      expect(json.encode(const AssetImage('images/a.png').toJson()),
          '{"type":"AssetImage","assetName":"images/a.png","package":null}');
    });

    test('round trips', () {
      for (final ImageProvider image in const [
        NetworkImage('https://example.com/a.png'),
        NetworkImage('https://example.com/a.png', scale: 2.5),
        AssetImage('images/a.png'),
        AssetImage('images/a.png', package: 'pkg'),
      ]) {
        expect(parseImageProvider(jsonRoundTrip(image.toJson())), image);
      }
    });

    test('parses an integer or missing NetworkImage scale', () {
      expect(
          parseImageProvider(const {
            'type': 'NetworkImage',
            'url': 'https://example.com/a.png',
            'scale': 2,
          }),
          const NetworkImage('https://example.com/a.png', scale: 2));
      expect(
          parseImageProvider(const {
            'type': 'NetworkImage',
            'url': 'https://example.com/a.png',
          }),
          const NetworkImage('https://example.com/a.png'));
    });

    test('serializes unsupported providers to an empty map', () {
      final ImageProvider image = MemoryImage(Uint8List(0));
      expect(image.toJson(), isEmpty);
      expect(parseImageProvider(image.toJson()), isNull);
      expect(parseImageProvider(null), isNull);
    });
  });

  group('DecorationImage', () {
    test('serializes to JSON', () {
      expect(
          json.encode(const DecorationImage(
            image: NetworkImage('https://example.com/a.png'),
          ).toJson()),
          '{"image":{"type":"NetworkImage","url":"https://example.com/a.png",'
          '"scale":1.0},"alignment":"center","repeat":"noRepeat","scale":1.0}');
      expect(
          json.encode(const DecorationImage(
            image: AssetImage('a.png'),
            colorFilter: ColorFilter.mode(red, BlendMode.color),
            fit: BoxFit.cover,
            alignment: Alignment(0.5, -0.5),
            repeat: ImageRepeat.repeatX,
            scale: 2,
          ).toJson()),
          '{"image":{"type":"AssetImage","assetName":"a.png","package":null},'
          '"colorFilter":{"color":"fff44336","mode":"color","type":"ColorFilter"},'
          '"fit":"cover","alignment":"(0.5, -0.5)","repeat":"repeatX",'
          '"scale":2.0}');
    });

    test('round trips', () {
      for (final DecorationImage image in const [
        DecorationImage(image: NetworkImage('https://example.com/a.png')),
        DecorationImage(
          image: AssetImage('a.png', package: 'pkg'),
          colorFilter: ColorFilter.mode(translucent, BlendMode.multiply),
          fit: BoxFit.fitHeight,
          alignment: Alignment.bottomLeft,
          repeat: ImageRepeat.repeat,
          scale: 0.5,
        ),
      ]) {
        expect(parseDecorationImage(jsonRoundTrip(image.toJson())), image);
      }
    });

    test('drops a color filter that cannot be serialized', () {
      const DecorationImage image = DecorationImage(
        image: AssetImage('a.png'),
        colorFilter: ColorFilter.srgbToLinearGamma(),
      );
      expect(parseDecorationImage(jsonRoundTrip(image.toJson())),
          const DecorationImage(image: AssetImage('a.png')));
    });

    test('parses null and JSON without a supported image to null', () {
      expect(parseDecorationImage(null), isNull);
      expect(parseDecorationImage(const {}), isNull);
      expect(
          parseDecorationImage(jsonRoundTrip(
              DecorationImage(image: MemoryImage(Uint8List(0))).toJson())),
          isNull);
    });
  });

  group('BoxDecoration', () {
    test('serializes color, gradient and image', () {
      expect(json.encode(const BoxDecoration().toJson()), '{}');
      expect(json.encode(const BoxDecoration(color: red).toJson()),
          '{"color":"fff44336"}');
      expect(
          json.encode(const BoxDecoration(
            color: red,
            gradient: LinearGradient(colors: [red, blue]),
            image: DecorationImage(image: AssetImage('a.png')),
          ).toJson()),
          '{"color":"fff44336","gradient":{"colors":["fff44336","ff2196f3"],'
          '"type":"LinearGradient","begin":"centerLeft","end":"centerRight",'
          '"tileMode":"clamp"},"image":{"image":{"type":"AssetImage",'
          '"assetName":"a.png","package":null},"alignment":"center",'
          '"repeat":"noRepeat","scale":1.0}}');
    });

    test('round trips', () {
      for (final BoxDecoration decoration in const [
        BoxDecoration(),
        BoxDecoration(color: translucent),
        BoxDecoration(
          color: red,
          gradient: SweepGradient(colors: [red, blue]),
          image: DecorationImage(
            image: NetworkImage('https://example.com/a.png'),
            fit: BoxFit.contain,
          ),
        ),
      ]) {
        expect(
            parseBoxDecoration(jsonRoundTrip(decoration.toJson())), decoration);
      }
    });

    test('parses null to null', () {
      expect(parseBoxDecoration(null), isNull);
    });
  });
}
