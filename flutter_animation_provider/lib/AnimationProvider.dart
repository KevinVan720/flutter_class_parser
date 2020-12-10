import 'package:flutter/material.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter_class_parser/toJson.dart';

enum AnimationProperties {
  width,
  height,
  backgroundColor,
  opacity,

  rotationX,
  rotationY,
  rotationZ,
  skewX,
  skewY,
  translationX,
  translationY,

  fontSize,
  textPrintPercent,
}

class AnimationData<T> {
  Duration duration;
  Curve curve;
  T value;

  AnimationData(
      {this.duration = const Duration(seconds: 1),
      this.curve = Curves.linear,
      this.value});

  AnimationData.fromJson(Map map, String type) {
    duration = Duration(milliseconds: map["duration"]);
    curve = parseCurve(map["curve"]);
    value = parse(map["value"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["duration"] = duration.inMilliseconds;
    rst["curve"] = curve.toJson();
    rst["value"] = convert(value);
    print(curve.toJson());
    return rst;
  }

  dynamic convert(T value) {
    if (T == double) {
      return value;
    }
    if (T == Color) {
      return (value as Color).toJson();
    }
  }

  dynamic parse(dynamic value) {
    if (T is double) {
      return value;
    }
    if (T is Color) {
      return parseColor(value);
    }
  }
}

class AnimationSequence {
  Duration delay;
  Map<AnimationProperties, List<AnimationData>> sequence;
  //CustomAnimationControl status;

  AnimationSequence({this.delay, this.sequence});

  getAnimationTween(Map<AnimationProperties, dynamic> initialValues) {
    MultiTween tween = MultiTween<AnimationProperties>();
    sequence.forEach((property, animations) {
      int index = 0;
      dynamic begin, end;
      begin = initialValues[property];
      for (; index < animations.length - 1; index++) {
        end = animations[index].value;
        tween.add(property, Tween(begin: begin, end: end),
            animations[index].duration, animations[index].curve);
        begin = end;
      }
    });
    return tween;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["delay"] = delay.inMilliseconds;
    rst["sequence"] = sequence.map((key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()));
    return rst;
  }

}

class AnimationNotifier extends ChangeNotifier {
  Map<String, Map<String, AnimationSequence>> animationPool = {};

  Map<String, AnimationSequence> currentAnimations = {};
  Map<String, CustomAnimationControl> currentAnimationsControl = {};

  AnimationNotifier({this.animationPool});

  void updateStatus(String animationId, CustomAnimationControl newStatus) {
    animationPool[animationId].forEach((key, value) {
      currentAnimations[key] = value;
      currentAnimationsControl[key] = newStatus;
    });

    notifyListeners();
  }
}
