import 'NamedAnimation.dart';
import 'package:flutter/material.dart';

Map<String, PresetAnimation> presetAnimationsMap={
  "Fade": FadeAnimation(),
  "Slide": SlideAnimation(),
};

abstract class PresetAnimation {
  String name;
  Duration delay;
  Duration duration;
  Map<String, dynamic> options;
  Map<String, Type> optionTypes;

  AnimationSequences getAnimationSequences();

  Map<AnimationProperty, dynamic> getInitValues();

}

class FadeAnimation extends PresetAnimation{
    FadeAnimation() {
      name="Fade";
      optionTypes={"Direction": bool};
      options={"Direction": true};
    }

    AnimationSequences getAnimationSequences() {
      return AnimationSequences(sequences: {
      AnimationProperty.opacity: AnimationSequence<double>()..add(value:
      options["Direction"]==true? 1.0 : 0.0
      )
      });
    }

    Map<AnimationProperty, dynamic> getInitValues() {
      return {
        AnimationProperty.opacity: options["Direction"]==true? 0.0 : 1.0
      };
    }

}

class SlideAnimation extends PresetAnimation{
  SlideAnimation() {
    name="Slide";
    optionTypes={"Direction": bool, "From": Alignment};
    options={"Direction": true, "From": Alignment.centerLeft};
  }

  AnimationSequences getAnimationSequences() {
    double finalX=options["Direction"]==true? 0.0 : (options["From"] as Alignment).x*100;
    double finalY=options["Direction"]==true? 0.0 : (options["From"] as Alignment).y*100;
    return AnimationSequences(sequences: {
      AnimationProperty.opacity: AnimationSequence<double>()..add(value:
      options["Direction"]==true? 1.0 : 0.0
      ),
      AnimationProperty.translationX: AnimationSequence<double>()..add(value:finalX,
      ),
      AnimationProperty.translationY: AnimationSequence<double>()..add(value:finalY,
      ),
    });
  }

  Map<AnimationProperty, dynamic> getInitValues() {
    double initX=options["Direction"]==true? (options["From"] as Alignment).x*100 : 0.0;
    double initY=options["Direction"]==true? (options["From"] as Alignment).y*100 : 0.0;
    return {
      AnimationProperty.opacity: options["Direction"]==true? 0.0 : 1.0,
      AnimationProperty.translationX: initX,
      AnimationProperty.translationY: initY,
    };
  }

}