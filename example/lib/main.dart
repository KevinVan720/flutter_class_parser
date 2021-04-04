import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print(Offset.zero.toJson());

    BoxDecoration decoration = BoxDecoration(
        image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.red, BlendMode.color),
            image: NetworkImage(
                "https://images.unsplash.com/photo-1594482628012-b4276773c61a?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1334&q=80")),
        gradient: LinearGradient(
            begin: Alignment(0.1, 0.2),
            stops: [0, 1],
            colors: [Colors.amber, Colors.red]));
    debugPrint(parseBoxDecoration(json.decode(json.encode(decoration.toJson())))
        .toString());

    print(ColorFilter.mode(Colors.red, BlendMode.color).toJson());
    print(parseImageFilter(json.decode(
        json.encode(ColorFilter.mode(Colors.red, BlendMode.color).toJson()))));

    debugPrint(parseGradient({
      "stops": [0, 1],
      "colors": ["ffff5252", "ff69f0ae"],
      "type": "LinearGradient",
      "begin": "topCenter",
      "end": "bottomCenter",
      "tileMode": "clamp"
    }).toString());

    debugPrint(
        parseAlignment(json.decode(json.encode(Alignment.bottomLeft.toJson())))
            .toString());

    debugPrint(
        parseFontWeight(json.decode(json.encode(FontWeight.w100.toJson())))
            .toString());

    debugPrint(parseMainAxisAlignment(
            json.decode(json.encode(MainAxisAlignment.center.toJson())))
        .toString());

    debugPrint(
        parseMatrix4(json.decode(json.encode(Matrix4.identity().toJson())))
            .toString());

    print(parseSize(json.decode(json.encode(Size(1, 2).toJson()))).toJson());

    debugPrint(parseSize({
      "width": 1,
      "height": 2,
    }).toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: decoration,
            ),
          ],
        ),
      ),
    );
  }
}
