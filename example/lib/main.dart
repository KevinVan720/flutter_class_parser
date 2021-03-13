import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_class_parser/parse_json.dart';
import 'package:flutter_class_parser/to_json.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                "https://images.unsplash.com/photo-1594482628012-b4276773c61a?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1334&q=80")),
        gradient: LinearGradient(
            begin: Alignment(0.1, 0.2),
            stops: [0, 1],
            colors: [Colors.amber, Colors.red]));
    debugPrint(parseBoxDecoration(json.decode(json.encode(decoration.toJson())))
        .toString());

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

    debugPrint(
        parseSize(json.decode(json.encode(Size(1, 2).toJson()))).toString());

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
