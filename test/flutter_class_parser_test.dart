import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  test('adds one to input values', () {
      var user = {};
      user["colors"] = [Colors.amber.toJson(), Colors.amber.toJson()];
      user["gradient"]=LinearGradient(colors: [Colors.black, Colors.black]).toJson();
      user["decorarionImage"]=DecorationImage(
          colorFilter: ColorFilter.mode(Colors.amber, BlendMode.clear),
          fit: BoxFit.fill,
          image: NetworkImage("https://imgur.com/gallery/GurbsrH")
      ).toJson();
      user["boxDecoration"]=BoxDecoration(color: Colors.amber, gradient: LinearGradient(colors: [Colors.black, Colors.black]),
          image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.amber, BlendMode.clear),
              fit: BoxFit.fill,
              image: NetworkImage("https://imgur.com/gallery/GurbsrH")
          )).toJson();
      user["textStyle"]=TextStyle(fontWeight: FontWeight.bold, color: Colors.black12, letterSpacing: 12).toJson();
      String str = json.encode(user);
      debugPrint(str);
      var res=json.decode(str);
      expect(parseTextStyle(res["textStyle"]).toString(), "TextStyle(inherit: true, color: Color(0x1f000000), weight: 700, style: normal, letterSpacing: 12.0)");
      expect(parseBoxDecoration(res["boxDecoration"]).toString(),
          '''BoxDecoration(color: Color(0xffffc107), image: DecorationImage(NetworkImage(\"https://imgur.com/gallery/GurbsrH\", scale: 1.0), ColorFilter.mode(Color(0xffffc107), BlendMode.clear), BoxFit.fill, Alignment.center, scale: 1.0), gradient: LinearGradient(Alignment.centerLeft, Alignment.centerRight, [Color(0xff000000), Color(0xff000000)], null, TileMode.clamp))''');
  });
}
