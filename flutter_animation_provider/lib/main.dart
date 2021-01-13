import 'package:flutter/material.dart';
import 'package:flutter_animation_provider/AnimationEditor.dart';
import 'package:flutter_animation_provider/AnimationProvider.dart';
import 'package:flutter_animation_provider/IdWidget.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:convert';
import 'PresetAnimations.dart';
import 'NamedAnimation.dart';
import 'package:after_layout/after_layout.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_animation_provider/SampleAnimations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  IdWidget container1 = IdWidget(
    id: "container1",
    style: {"backgroundColor": Colors.green, "opacity": 0.0},
    animationTriggers: {AnimationTrigger.elementScroll: "animation1"},
    child: Container(width: 100, height: 100, child: Text("Hello")),
  );

  var animationPool = {
    "animation1": animation1,
    "animation2": animation2,
    "animation3": animation3,
  };

  @override
  Widget build(BuildContext context) {
    VisibilityDetectorController.instance.updateInterval = Duration(milliseconds: 1);
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {

          print(animationPool["animation1"].toJson());

      return MaterialApp(
          title: 'Flutter Demo',
          home: Scaffold(
              appBar: AppBar(
                title: Text("Home"),
              ),
              body: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: AnimationEditor(
                      animation: animation1,
                      selectedWidget: container1,
                    ),
                  ),
                  Flexible(
                      flex: 4,
                      child: MultiProvider(
                          providers: [
                            ChangeNotifierProvider<AnimationNotifier>(
                                create: (_) => AnimationNotifier(
                                    animationPool: animationPool)),
                          ],
                          child: MyHomePage(
                            child: container1,
                          ))),
                ],
              )));
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.child}) : super(key: key);

  IdWidget child;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AfterLayoutMixin<MyHomePage> {
  ScrollController scrollController;
  ScrollController scrollController2;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController2 = ScrollController();
    /*
    scrollController.addListener(() {
      print(scrollController.offset.toString()+", "+scrollController.position.maxScrollExtent.toString());
      Provider.of<AnimationNotifier>(context, listen: false)
          .animationProgressNotifiers["animation1"]
          .value = scrollController.offset/scrollController.position.maxScrollExtent;
    });
    */
  }

  @override
  void dispose() {
    scrollController.dispose();
    scrollController2.dispose();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    String pageScrollAnimationName="animation3";
    Provider
        .of<AnimationNotifier>(context, listen: false)
        .animationProgressNotifiers[pageScrollAnimationName] =
        ContinuousAnimationProgressNotifier(0.0);
    scrollController2.addListener(() {
      Provider.of<AnimationNotifier>(context, listen: false)
          .animationProgressNotifiers[pageScrollAnimationName]
          .value = scrollController2.offset/scrollController2.position.maxScrollExtent;
    });
    Provider.of<AnimationNotifier>(context, listen: false)
        .updateContinuousAnimationStatus(pageScrollAnimationName, true);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children=[Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Provider.of<AnimationNotifier>(context, listen: false)
                .updateAnimationStatus(
                "animation2", CustomAnimationControl.PLAY);
          },
          tooltip: 'Increment',
          icon: Icon(Icons.play_arrow),
        ),
        IconButton(
          onPressed: () {
            Provider.of<AnimationNotifier>(context, listen: false)
                .updateAnimationStatus(
                "animation2", CustomAnimationControl.STOP);
          },
          tooltip: 'Increment',
          icon: Icon(Icons.stop),
        ),
        IconButton(
          onPressed: () {
            Provider.of<AnimationNotifier>(context, listen: false)
                .updateAnimationStatus(
                "animation2", CustomAnimationControl.PLAY_REVERSE);
          },
          tooltip: 'Increment',
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
        IconButton(
          onPressed: () {
            Provider.of<AnimationNotifier>(context, listen: false)
                .updateAnimationStatus(
                "animation2", CustomAnimationControl.MIRROR);
          },
          tooltip: 'Increment',
          icon: Icon(Icons.repeat),
        ),
      ],
    ),
      Container(
          color: Colors.deepPurpleAccent,
          height: 400,
          child: Center(
            child: widget.child,
          )),
      Container(
        height: 1000,
        color: Colors.greenAccent,
      ),
      Container(
          color: Colors.deepPurpleAccent,
          height: 400,
          child: ParentScroll(
              controller: scrollController2,
              direction: Axis.horizontal,
              child: ListView(
                cacheExtent: 10000,
                scrollDirection: Axis.horizontal,
                controller: scrollController2,
                children: [
                  Container(
                    width: 500,
                    height: 50,
                    color: Colors.amber,
                  ),
                  IdWidget(
                    id: "container2",
                    type: ".container2",
                    //animationTriggers: {AnimationTrigger.elementScroll: "animation3"},
                    style: {"backgroundColor": Colors.white},
                    child: Container(width: 50, child: Text("Again")),
                  ),
                  Container(
                    width: 500,
                    height: 50,
                    color: Colors.amber,
                  ),
                  /*IdWidget(
                        id: "container1",
                        type: ".container2",
                        child: Text("Again"),
                      ),*/
                  IdWidget(
                    id: "container3",
                    type: ".container2",
                    child: Text("Again"),
                  ),
                  Container(
                    width: 500,
                    height: 50,
                    color: Colors.amber,
                  ),
                  IdWidget(
                    type: ".container2",
                    child: Text("Again"),
                  ),
                  Container(
                    width: 500,
                    height: 50,
                    color: Colors.amber,
                  ),
                  IdWidget(
                    id: "container4",
                    child: Text("Again"),
                  ),
                ],
              ))),
      Container(
        height: 1000,
        color: Colors.greenAccent,
      )];
    return ParentScroll(
      controller: scrollController,
      direction: Axis.vertical,
      child: ListView(
        cacheExtent: 10000, ///use large cache extent to solve the varying max scroll extent issue
        controller: scrollController,
        children: children,
      ),
    );
  }
}
