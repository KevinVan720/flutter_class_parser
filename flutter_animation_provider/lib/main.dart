import 'package:flutter/material.dart';
import 'package:flutter_animation_provider/AnimationProvider.dart';
import 'package:flutter_animation_provider/IdWidget.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    var animationPool={
      "animation1" : {
        "container1" : AnimationSequence(
            delay: Duration(seconds: 1),
            sequence: {
              AnimationProperties.width: [
                AnimationData<double>(duration: Duration(seconds: 1), value: 10.9, ),
                AnimationData<double>(duration: Duration(seconds: 1), value: 50.9, ),
                AnimationData<double>(duration: Duration(seconds: 1), value: 100.9, )
              ],
              AnimationProperties.height: [
                AnimationData<double>(duration: Duration(seconds: 1), value: 100.9, ),
                AnimationData<double>(duration: Duration(seconds: 1), value: 50.9, ),
                AnimationData<double>(duration: Duration(seconds: 1), value: 10.0, )
              ],
              AnimationProperties.backgroundColor: [
                AnimationData<Color>(duration: Duration(seconds: 1), value: Colors.amber, ),
                AnimationData<Color>(duration: Duration(seconds: 1), value: Colors.red, ),
                AnimationData<Color>(duration: Duration(seconds: 1), value: Colors.yellow, )
              ]
            }
        )
      }
    };


    debugPrint(json.encode(animationPool["animation1"]["container1"].toJson()));
    //debugPrint(json.encode(animationPool.map((animationName, animation) => MapEntry(animationName, animation.map((applier, sequence) => MapEntry(applier, sequence.toJson()))))));

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
        home: MultiProvider(providers: [
          ChangeNotifierProvider<AnimationNotifier>(
              create: (_) => AnimationNotifier(animationPool: animationPool)),
        ], child: MyHomePage(title: 'Flutter Demo Home Page')));
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(Duration(seconds: 1).toString());
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Provider.of<AnimationNotifier>(context, listen: false).updateStatus("animation1", CustomAnimationControl.PLAY);
              },
              tooltip: 'Increment',
              icon: Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: () {
                Provider.of<AnimationNotifier>(context, listen: false).updateStatus("animation1", CustomAnimationControl.STOP);
              },
              tooltip: 'Increment',
              icon: Icon(Icons.stop),
            ),
            IconButton(
              onPressed: () {
                Provider.of<AnimationNotifier>(context, listen: false).updateStatus("animation1", CustomAnimationControl.PLAY_REVERSE);
                },
              tooltip: 'Increment',
              icon: Icon(Icons.arrow_back_ios_rounded),
            ),
            IconButton(
              onPressed: () {
                Provider.of<AnimationNotifier>(context, listen: false).updateStatus("animation1", CustomAnimationControl.MIRROR);
              },
              tooltip: 'Increment',
              icon: Icon(Icons.repeat),
            ),
            IdWidget(type: "container1"),
            IdWidget(type: "container2"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<AnimationNotifier>(context, listen: false).updateStatus("animation1", CustomAnimationControl.PLAY);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
