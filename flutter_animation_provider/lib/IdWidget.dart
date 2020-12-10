import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortuuid/shortuuid.dart';
import 'AnimationProvider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:tuple/tuple.dart';

class IdWidget extends StatefulWidget {
  String id;
  String type;

  IdWidget({Key key, this.type}) : super(key: key) {
    id = ShortUuid.shortv4();
  }

  @override
  _IdWidgetState createState() => _IdWidgetState();
}

class _IdWidgetState extends State<IdWidget> {
  @override
  Widget build(BuildContext context) {
    return Selector<AnimationNotifier, Tuple2<CustomAnimationControl, AnimationSequence>>(
        selector: (_, notifier) => Tuple2(notifier.currentAnimationsControl[widget.type], notifier.currentAnimations[widget.type]),
        child: Container(
          color: Colors.amber,
          child: Text("Anime"),
        ),
        builder: (context, tuple, child) {
          if (tuple == null || tuple.item2==null) {
            return child;
          }
          return CustomAnimation<MultiTweenValues<AnimationProperties>>(
            delay: tuple.item2?.delay,
            control: tuple.item1, // <-- bind state variable to parameter
            tween: tuple.item2?.getAnimationTween({AnimationProperties.width: 10.0, AnimationProperties.height: 50.0,}),
            builder: (context, child, value) {
              return Transform.translate(
                // <-- animation that moves childs from left to right
                offset: Offset(0, 0),
                child: Container(
                    width: value.get(AnimationProperties.width),
                    height: value.get(AnimationProperties.height),
                    child: child),
              );
            },
            child: Container(
                width: 10,
                height: 50,
                child: child),
          );
        });
  }
}
