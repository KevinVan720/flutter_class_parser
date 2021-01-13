import 'package:flutter_animation_provider/PresetAnimations.dart';

import 'NamedAnimation.dart';
import 'package:flutter/material.dart';

/*
ProgressAnimation animation1 = ProgressAnimation(
    sequences: {
      "container1": AnimationSequences(sequences: {
        AnimationProperty.rotationZ: AnimationSequence<double>()
          ..add(
            duration: Duration(seconds: 1),
            value: 1.0,
          )
          ..add(
            duration: Duration(seconds: 1),
            value: 50.0,
          )
          ..add(
              duration: Duration(seconds: 3),
              //delay: Duration(seconds: 2),
              value: 200.0,
              curve: Curves.bounceIn),
        AnimationProperty.backgroundGradient: AnimationSequence<Gradient>()
          ..add(
            duration: Duration(seconds: 1),
            value: LinearGradient(
              colors: [Colors.red, Colors.blue, Colors.greenAccent],
              stops: [0.1, 0.4, 0.8],
            ),
          )
          ..add(
            duration: Duration(seconds: 1),
            value: LinearGradient(
              colors: [
                Colors.blue[900],
                Colors.greenAccent,
                Colors.purpleAccent
              ],
              stops: [0.3, 0.7, 0.8],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
            ),
          ),
        AnimationProperty.height: AnimationSequence<double>()
          ..add(
            duration: Duration(seconds: 1),
            value: 20.0,
          )
          ..add(
            duration: Duration(seconds: 2),
            value: 100.0,
          )
          ..add(
              duration: Duration(seconds: 3),
              //delay: Duration(seconds: 2),
              value: 200.0,
              curve: Curves.bounceIn),
      }),
    });
 */
ProgressAnimation animation1=ProgressAnimation(
  sequences: {
    "container1": FadeAnimation().getAnimationSequences()
  }
);

TimedAnimation animation2 = TimedAnimation(
    sequences: {
      "container3": AnimationSequences(sequences: {
        AnimationProperty.translationY: AnimationSequence<double>()
          ..add(
            duration: Duration(seconds: 2),
            value: 0.0,
          )
          ..add(
            duration: Duration(seconds: 1),
            value: -1.0,
          )
          ..add(
              duration: Duration(seconds: 3),
              delay: Duration(seconds: 2),
              value: -2.0,
              curve: Curves.bounceIn),
        AnimationProperty.backgroundColor: AnimationSequence<Color>()
          ..add(
            delay: Duration(seconds: 1),
            duration: Duration(seconds: 2),
            value: Colors.redAccent,
          )
          ..add(
            duration: Duration(seconds: 5),
            value: Colors.yellow,
          )
          ..add(
              duration: Duration(seconds: 5),
              delay: Duration(milliseconds: 500),
              value: Colors.greenAccent,
              curve: Curves.bounceIn),
        AnimationProperty.backgroundGradient:
        AnimationSequence<Gradient>()
          ..add(
            duration: Duration(seconds: 2),
            value: LinearGradient(
              colors: [Colors.red, Colors.blue, Colors.greenAccent],
              stops: [0.1, 0.4, 0.8],
            ),
          )
          ..add(
            duration: Duration(seconds: 1),
            value: LinearGradient(
              colors: [
                Colors.blue[900],
                Colors.greenAccent,
                Colors.purpleAccent
              ],
              stops: [0.3, 0.7, 0.8],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
            ),
          )
      }),
    });

ProgressAnimation animation3 = ProgressAnimation(
    sequences: {
      "container2": AnimationSequences(sequences: {
        AnimationProperty.rotationZ: AnimationSequence<double>()
          ..add(
            duration: Duration(seconds: 1),
            value: 1.0,
          )
          ..add(
            duration: Duration(seconds: 1),
            value: 50.0,
          )
          ..add(
              duration: Duration(seconds: 3),
              //delay: Duration(seconds: 2),
              value: 200.0,
              curve: Curves.bounceIn),
        AnimationProperty.backgroundColor: AnimationSequence<Color>()
          ..add(
            delay: Duration(seconds: 1),
            duration: Duration(seconds: 2),
            value: Colors.redAccent,
          )
          ..add(
            duration: Duration(seconds: 5),
            value: Colors.yellow,
          )
          ..add(
              duration: Duration(seconds: 5),
              delay: Duration(milliseconds: 500),
              value: Colors.greenAccent,
              curve: Curves.bounceIn),
        AnimationProperty.backgroundGradient: AnimationSequence<Gradient>()
          ..add(
            duration: Duration(seconds: 5),
            value: LinearGradient(
              colors: [Colors.red, Colors.blue, Colors.greenAccent],
              stops: [0.1, 0.4, 0.8],
            ),
          )
          ..add(
            duration: Duration(seconds: 3),
            value: LinearGradient(
              colors: [
                Colors.blue[900],
                Colors.greenAccent,
                Colors.purpleAccent
              ],
              stops: [0.3, 0.7, 0.8],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
            ),
          )
      })
    });