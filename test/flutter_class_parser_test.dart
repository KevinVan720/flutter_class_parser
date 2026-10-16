import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:flutter_test/flutter_test.dart';

const Color amber = ColorSwatch(0xffffc107, <int, Color>{});
const Color black = Color(0xff000000);
const Color black12 = Color(0x1f000000);

void main() {
  test('round trips a JSON document with nested values', () {
    final Map<String, dynamic> document = {
      'colors': [amber.toJson(), black.toJson()],
      'gradient': const LinearGradient(colors: [black, amber]).toJson(),
      'decorationImage': const DecorationImage(
        colorFilter: ColorFilter.mode(amber, BlendMode.clear),
        fit: BoxFit.fill,
        image: NetworkImage('https://example.com/image.png'),
      ).toJson(),
      'boxDecoration': const BoxDecoration(color: amber).toJson(),
      'textStyle': const TextStyle(
              fontWeight: FontWeight.bold, color: black12, letterSpacing: 12)
          .toJson(),
      'transform': Matrix4.rotationZ(0.25).toJson(),
      'padding': const EdgeInsets.symmetric(horizontal: 8).toJson(),
      'curve': Curves.easeInOut.toJson(),
      'cursor': SystemMouseCursors.click.toJson(),
    };

    final Map<String, dynamic> decoded = json.decode(json.encode(document));

    expect((decoded['colors'] as List).map((color) => parseColor(color)),
        [const Color(0xffffc107), black]);
    expect(parseGradient(decoded['gradient']),
        const LinearGradient(colors: [black, Color(0xffffc107)]));
    expect(
        parseDecorationImage(decoded['decorationImage']),
        const DecorationImage(
          colorFilter: ColorFilter.mode(Color(0xffffc107), BlendMode.clear),
          fit: BoxFit.fill,
          image: NetworkImage('https://example.com/image.png'),
        ));
    expect(parseBoxDecoration(decoded['boxDecoration']),
        const BoxDecoration(color: Color(0xffffc107)));
    expect(
        parseTextStyle(decoded['textStyle']),
        const TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            color: black12,
            letterSpacing: 12));
    expect(parseMatrix4(decoded['transform']), Matrix4.rotationZ(0.25));
    expect(parseEdgeInsets(decoded['padding']),
        const EdgeInsets.symmetric(horizontal: 8));
    expect(parseCurve(decoded['curve']), Curves.easeInOut);
    expect(parseSystemMouseCursor(decoded['cursor']), SystemMouseCursors.click);
  });

  test('parses JSON stored by earlier versions', () {
    // Output of version 0.2.5 on Flutter 3.x for the values below.
    final Map<String, dynamic> stored = json.decode('''
{
  "gradient": {"stops": [0.0, 1.0], "colors": ["ffff5252", "ff69f0ae"],
    "type": "LinearGradient", "begin": "topCenter", "end": "(0.5, -0.5)",
    "tileMode": "clamp"},
  "image": {"image": {"type": "AssetImage", "assetName": "a.png",
    "package": null}, "colorFilter": {"color": "0000ff00", "mode": "srcOver",
    "type": "ColorFilter"}, "fit": "cover", "alignment": "center",
    "repeat": "noRepeat", "scale": 1.0},
  "blur": {"sigmaX": 2.0, "sigmaY": 3.0, "tileMode": "mirror",
    "type": "ImageFilter"},
  "textStyle": {"color": "ff000000", "fontSize": 14.0, "fontWeight": "w700",
    "fontStyle": "italic", "decoration": "underline"}
}
''');

    expect(
        parseGradient(stored['gradient']),
        const LinearGradient(
          stops: [0, 1],
          colors: [Color(0xffff5252), Color(0xff69f0ae)],
          begin: Alignment.topCenter,
          end: Alignment(0.5, -0.5),
        ));
    expect(
        parseDecorationImage(stored['image']),
        const DecorationImage(
          image: AssetImage('a.png'),
          colorFilter: ColorFilter.mode(Color(0x0000ff00), BlendMode.srcOver),
          fit: BoxFit.cover,
        ));
    expect(parseImageFilter(stored['blur']),
        ui.ImageFilter.blur(sigmaX: 2, sigmaY: 3, tileMode: TileMode.mirror));
    expect(
        parseTextStyle(stored['textStyle']),
        const TextStyle(
          color: black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ));
  });

  group('MapToJsonTypeExtension', () {
    test('toJson returns the map itself', () {
      final Map<String, int> map = {'a': 1};
      expect(identical(map.toJson(), map), isTrue);
    });

    test('updateNotNull only adds values that are not null', () {
      final Map<String, int?> map = {};
      map.updateNotNull('a', null);
      map.updateNotNull('b', 1);
      expect(map, {'b': 1});
    });
  });

  test('stripFirstDot removes everything up to the first dot', () {
    expect('BlendMode.srcOver'.stripFirstDot(), 'srcOver');
    expect('a.b.c'.stripFirstDot(), 'b.c');
    expect('noDot'.stripFirstDot(), 'noDot');
  });
}
