import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:flutter_test/flutter_test.dart';

const Color amber = ColorSwatch(0xffffc107, <int, Color>{});
const Color black = Color(0xff000000);
const Color black12 = Color(0x1f000000);

void main() {
  test('adds one to input values', () {
      var user = {};
      user["colors"] = [amber.toJson(), amber.toJson()];
      user["gradient"]=LinearGradient(colors: [black, black]).toJson();
      user["decorarionImage"]=DecorationImage(
          colorFilter: ColorFilter.mode(amber, BlendMode.clear),
          fit: BoxFit.fill,
          image: NetworkImage("https://imgur.com/gallery/GurbsrH")
      ).toJson();
      user["boxDecoration"]=BoxDecoration(color: amber).toJson();
      user["textStyle"]=TextStyle(fontWeight: FontWeight.bold, color: black12, letterSpacing: 12).toJson();
      String str = json.encode(user);
      debugPrint(str);
      var res=json.decode(str);
      expect(parseTextStyle(res["textStyle"]),
          TextStyle(fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, color: black12, letterSpacing: 12));
      expect(parseColor(res["colors"][0]), const Color(0xffffc107));
      expect(parseColorFilter(res["decorarionImage"]["colorFilter"]),
          const ColorFilter.mode(Color(0xffffc107), BlendMode.clear));
  });

  test('color round trip', () {
    for (Color color in const [
      Color(0x00000000),
      Color(0x1f000000),
      Color(0x802196f3),
      Color(0xffffc107),
    ]) {
      expect(parseColor(color.toJson()), color);
    }
  });

  test('color filter round trip', () {
    const ColorFilter filter =
        ColorFilter.mode(Color(0x802196f3), BlendMode.multiply);
    expect(filter.toJson(),
        {"color": "802196f3", "mode": "multiply", "type": "ColorFilter"});
    expect(parseColorFilter(filter.toJson()), filter);
  });

  test('blur image filter round trip', () {
    ui.ImageFilter filter =
        ui.ImageFilter.blur(sigmaX: 2, sigmaY: 3, tileMode: TileMode.mirror);
    expect(parseImageFilter(filter.toJson()).toString(), filter.toString());
  });
}
