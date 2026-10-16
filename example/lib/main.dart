import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Class Parser Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Class Parser Demo'),
    );
  }
}

/// Encodes [value] to a JSON string and decodes it again, like an app that
/// stores the serialized value and loads it later.
dynamic jsonRoundTrip(Object? value) => json.decode(json.encode(value));

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  static const BoxDecoration decoration = BoxDecoration(
    image: DecorationImage(
      colorFilter: ColorFilter.mode(Colors.red, BlendMode.color),
      image: NetworkImage(
          "https://images.unsplash.com/photo-1594482628012-b4276773c61a?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1334&q=80"),
    ),
    gradient: LinearGradient(
      begin: Alignment(0.1, 0.2),
      stops: [0, 1],
      colors: [Colors.amber, Colors.red],
    ),
  );

  /// Each example: a label, the serialized JSON and the parsed value.
  static List<(String, Object?, Object?)> examples() {
    const ColorFilter colorFilter =
        ColorFilter.mode(Colors.red, BlendMode.color);
    const Map<String, dynamic> gradient = {
      "stops": [0, 1],
      "colors": ["ffff5252", "ff69f0ae"],
      "type": "LinearGradient",
      "begin": "topCenter",
      "end": "bottomCenter",
      "tileMode": "clamp"
    };

    return [
      (
        "BoxDecoration",
        decoration.toJson(),
        parseBoxDecoration(jsonRoundTrip(decoration.toJson())),
      ),
      (
        "ColorFilter",
        colorFilter.toJson(),
        parseImageFilter(jsonRoundTrip(colorFilter.toJson())),
      ),
      ("Gradient", gradient, parseGradient(gradient)),
      (
        "Offset",
        Offset.zero.toJson(),
        parseOffset(jsonRoundTrip(Offset.zero.toJson())),
      ),
      (
        "Alignment",
        Alignment.bottomLeft.toJson(),
        parseAlignment(jsonRoundTrip(Alignment.bottomLeft.toJson())),
      ),
      (
        "FontWeight",
        FontWeight.w100.toJson(),
        parseFontWeight(jsonRoundTrip(FontWeight.w100.toJson())),
      ),
      (
        "MainAxisAlignment",
        MainAxisAlignment.center.toJson(),
        parseMainAxisAlignment(
            jsonRoundTrip(MainAxisAlignment.center.toJson())),
      ),
      (
        "Matrix4",
        Matrix4.identity().toJson(),
        parseMatrix4(jsonRoundTrip(Matrix4.identity().toJson())),
      ),
      (
        "Size",
        const Size(1, 2).toJson(),
        parseSize(jsonRoundTrip(const Size(1, 2).toJson())),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration:
                  parseBoxDecoration(jsonRoundTrip(decoration.toJson())),
            ),
          ),
          for (final (String label, Object? jsonValue, Object? parsed)
              in examples())
            ListTile(
              title: Text(label),
              subtitle: Text("JSON: ${json.encode(jsonValue)}\n"
                  "Parsed: $parsed"),
            ),
        ],
      ),
    );
  }
}
