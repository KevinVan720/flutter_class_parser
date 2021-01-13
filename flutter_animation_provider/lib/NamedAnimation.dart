import 'package:flutter/material.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter_class_parser/toJson.dart';
import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'package:cssstylewidget/cssstylewidget.dart';

//TODO: Add preset animations,
//TODO: Deal with initial values,

enum AnimationTrigger {
  elementClick,
  elementVisibilityChange,
  elementScroll,
  pageScroll,
  pageLoad,
}

extension AnimationTriggerToJson on AnimationTrigger {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

AnimationTrigger parseAnimationTrigger(String str) {
  switch (str) {
    case "elementClick":
      return AnimationTrigger.elementClick;
    case "elementVisibilityChange":
      return AnimationTrigger.elementVisibilityChange;
    case "elementScroll":
      return AnimationTrigger.elementScroll;
    case "pageScroll":
      return AnimationTrigger.pageScroll;
    case "pageLoad":
      return AnimationTrigger.pageLoad;
    default:
      return null;
  }
}

enum AnimationProperty {
  width,
  height,

  backgroundColor,
  backgroundGradient,
  opacity,

  //borderColor,
  //borderThickness,
  //elevation,

  fontSize,
  textColor,

  scaleX,
  scaleY,
  rotationX,
  rotationY,
  rotationZ,
  skewX,
  skewY,
  translationX,
  translationY,
}

const Map<AnimationProperty, Type> AnimationPropertyTypeMap = {
  AnimationProperty.width: double,
  AnimationProperty.height: double,
  AnimationProperty.backgroundColor: Color,
  AnimationProperty.backgroundGradient: Gradient,
  AnimationProperty.opacity: double,
  AnimationProperty.fontSize: double,
  AnimationProperty.textColor: Color,
  AnimationProperty.scaleX: double,
  AnimationProperty.scaleY: double,
  AnimationProperty.rotationX: double,
  AnimationProperty.rotationY: double,
  AnimationProperty.rotationZ: double,
  AnimationProperty.skewX: double,
  AnimationProperty.skewY: double,
  AnimationProperty.translationX: double,
  AnimationProperty.translationY: double,
};

const Map<AnimationProperty, dynamic> AnimationPropertyDefaultInitMap = {
  AnimationProperty.width: 1.0,
  AnimationProperty.height: 1.0,
  AnimationProperty.backgroundColor: Colors.white,
  AnimationProperty.backgroundGradient: LinearGradient(
    colors: [Colors.blue, Colors.green],
  ),
  AnimationProperty.opacity: 1.0,
  AnimationProperty.fontSize: 1.0,
  AnimationProperty.textColor: Colors.black,
  AnimationProperty.scaleX: 1.0,
  AnimationProperty.scaleY: 1.0,
  AnimationProperty.rotationX: 0.0,
  AnimationProperty.rotationY: 0.0,
  AnimationProperty.rotationZ: 0.0,
  AnimationProperty.skewX: 0.0,
  AnimationProperty.skewY: 0.0,
  AnimationProperty.translationX: 0.0,
  AnimationProperty.translationY: 0.0,
};

extension AnimationPropertyToJson on AnimationProperty {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

AnimationProperty parseAnimationProperty(String str) {
  switch (str) {
    case "width":
      return AnimationProperty.width;
    case "height":
      return AnimationProperty.height;
    case "fontSize":
      return AnimationProperty.fontSize;
    case "textColor":
      return AnimationProperty.textColor;
    case "backgroundColor":
      return AnimationProperty.backgroundColor;
    case "backgroundGradient":
      return AnimationProperty.backgroundGradient;
    case "opacity":
      return AnimationProperty.opacity;
    case "scaleX":
      return AnimationProperty.scaleX;
    case "scaleY":
      return AnimationProperty.scaleY;
    case "rotationX":
      return AnimationProperty.rotationX;
    case "rotationY":
      return AnimationProperty.rotationY;
    case "rotationZ":
      return AnimationProperty.rotationZ;
    case "translationX":
      return AnimationProperty.translationX;
    case "translationY":
      return AnimationProperty.translationY;
    default:
      return null;
  }
}

class GradientTween extends Tween<Gradient> {
  /// Provide a begin and end Gradient. To fade between.
  GradientTween({
    Gradient begin,
    Gradient end,
  }) : super(begin: begin, end: end);

  @override
  Gradient lerp(double t) => Gradient.lerp(begin, end, t);
}

class AnimationData<T> {
  Duration duration;
  Duration delay;
  Curve curve;
  T value;

  AnimationData(
      {this.duration = const Duration(seconds: 1),
      this.delay = const Duration(seconds: 0),
      this.curve = Curves.linear,
      this.value});

  AnimationData.fromJson(Map map) {
    duration = Duration(milliseconds: map["duration"]);
    delay = Duration(milliseconds: map["delay"]);
    curve = parseCurve(map["curve"]);
    value = parse(map["value"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["duration"] = duration.inMilliseconds;
    rst["delay"] = delay.inMilliseconds;
    rst["curve"] = curve.toJson();
    rst["value"] = convert(value);
    return rst;
  }

  dynamic convert(T value) {
    if (T == double) {
      return value;
    }
    if (T == Color) {
      return (value as Color).toJson();
    }
    if (T == Gradient) {
      return (value as Gradient).toJson();
    }
  }

  dynamic parse(dynamic value) {
    if (T == double) {
      return value;
    }
    if (T == Color) {
      return parseColor(value);
    }
    if (T == Gradient) {
      return parseGradient(value);
    }
  }
}


class AnimationSequence<T> {
  List<AnimationData<T>> animationData = [];

  AnimationSequence({this.animationData});

  AnimationSequence.fromJson(Map map) {
    animationData = (map["animationData"] as List)
        .map((e) => AnimationData<T>.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["animationData"] = animationData.map((e) => e.toJson()).toList();
    return rst;
  }

  void add(
      {Duration duration = const Duration(seconds: 1),
      Duration delay = const Duration(seconds: 0),
      Curve curve = Curves.linear,
      @required T value}) {
    if (animationData == null) animationData = [];
    animationData.add(AnimationData<T>(
        duration: duration, delay: delay, curve: curve, value: value));
  }

  double getMaxValue({double initialValue = -double.infinity}) {
    double max = initialValue;
    if (T == double) {
      animationData.forEach((element) {
        if ((element.value as double) > max) {
          max = element.value as double;
        }
      });
    }
    return max;
  }

  double getMinValue({initialValue = double.infinity}) {
    double min = initialValue;
    if (T == double) {
      animationData.forEach((element) {
        if ((element.value as double) < min) {
          min = element.value as double;
        }
      });
    }
    return min;
  }

  List<double> getAllTimeStamps() {
    double time = 0.0;
    List<double> timeStamps = [time];
    animationData.forEach((data) {
      time += data.delay.inMilliseconds;
      if (!timeStamps.contains(time)) {
        timeStamps.add(time);
      }
      time += data.duration.inMilliseconds;
      if (!timeStamps.contains(time)) {
        timeStamps.add(time);
      }
    });
    timeStamps.sort();
    return timeStamps;
  }
}

class AnimationSequences {
  Map<AnimationProperty, AnimationSequence> sequences;

  AnimationSequences({this.sequences});

  AnimationSequences.fromJson(Map map) {
    sequences = (map["sequences"] as Map).map((key, value) {
      AnimationProperty property = parseAnimationProperty(key);
      Type type = AnimationPropertyTypeMap[property];
      if (type == Color) {
        return MapEntry(property, AnimationSequence<Color>.fromJson(value));
      }
      if(type==Gradient) {
        return MapEntry(property, AnimationSequence<Gradient>.fromJson(value));
      }

      return MapEntry(property, AnimationSequence<double>.fromJson(value));
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["sequences"] =
        sequences.map((key, value) => MapEntry(key.toJson(), value.toJson()));

    return rst;
  }

  void extend(AnimationSequences secondSequence) {
    double currentMaxTime = 0;
    sequences.forEach((key, value) {
      double maxTime = value.getAllTimeStamps().last;
      if (maxTime > currentMaxTime) {
        currentMaxTime = maxTime;
      }
    });

    secondSequence.sequences.forEach((key, value) {
      if (!sequences.containsKey(key)) {
        if (AnimationPropertyTypeMap[key] == double)
          sequences[key] = AnimationSequence<double>(animationData: []);
        if (AnimationPropertyTypeMap[key] == Color)
          sequences[key] = AnimationSequence<Color>(animationData: []);
        if (AnimationPropertyTypeMap[key] == Gradient)
          sequences[key] = AnimationSequence<Gradient>(animationData: []);
      }

      value.animationData[0].delay += Duration(
          milliseconds:
              (currentMaxTime - sequences[key].getAllTimeStamps().last)
                  .round());
      sequences[key].animationData.addAll(value.animationData);
    });
  }

  getAnimationTween({Map<AnimationProperty, dynamic> initialValues}) {
    MultiTween multiTween = MultiTween<AnimationProperty>();
    sequences.forEach((property, animationSequence) {
      var animations = animationSequence.animationData;
      dynamic begin, end;
      begin = initialValues[property] ?? AnimationPropertyDefaultInitMap[property];
      for (int index = 0; index < animations.length; index++) {
        end = animations[index].value;
        Tween delayTween;
        Tween tween;
        if (AnimationPropertyTypeMap[property] == Color) {
          delayTween = ColorTween(begin: begin, end: begin);
          tween = ColorTween(begin: begin, end: end);
        } else if (AnimationPropertyTypeMap[property] == Gradient) {
          delayTween = GradientTween(begin: begin, end: begin);
          tween = GradientTween(begin: begin, end: end);
        } else {
          delayTween = Tween(begin: begin, end: begin);
          tween = Tween(begin: begin, end: end);
        }
        if (animations[index].delay.inMilliseconds > 0) {
          multiTween.add(property, delayTween, animations[index].delay);
        }
        multiTween.add(property, tween, animations[index].duration,
            animations[index].curve);
        begin = end;
      }
    });
    return multiTween;
  }

  List<double> getAllTimeStamps() {
    List<double> timeStamps = [];
    sequences.forEach((property, sequence) {
      sequence.getAllTimeStamps().forEach((time) {
        if (!timeStamps.contains(time)) {
          timeStamps.add(time);
        }
      });
    });
    timeStamps.sort();
    return timeStamps;
  }

  void rescaleTime(double maxTime) {
    double currentMaxTime = getAllTimeStamps().last;
    sequences.forEach((property, sequence) {
      sequence.animationData.forEach((data) {
        data.delay = Duration(
            milliseconds:
                (data.delay.inMilliseconds / currentMaxTime * maxTime).round());
        data.duration = Duration(
            milliseconds:
                (data.duration.inMilliseconds / currentMaxTime * maxTime)
                    .round());
      });
    });
  }
}

/*
enum AnimationType { timed, progress }

extension AnimationTypeToJson on AnimationType {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

AnimationType parseAnimationType(String str) {
  switch (str) {
    case "event":
      return AnimationType.timed;
    case "progress":
      return AnimationType.progress;
    default:
      return null;
  }
}
*/

abstract class NamedAnimation {
  Map<String, AnimationSequences> sequences;

  NamedAnimation({this.sequences});

  NamedAnimation.fromJson(Map map) {
    sequences = (map["sequences"] as Map).map((key, value) {
      return MapEntry(key, AnimationSequences.fromJson(value));
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["sequences"] =
        sequences.map((key, value) => MapEntry(key, value.toJson()));
    return rst;
  }

  List<double> getAllTimeStamps() {
    List<double> timeStamps = [];
    sequences.forEach((name, value) {
      value.getAllTimeStamps().forEach((time) {
        if (!timeStamps.contains(time)) {
          timeStamps.add(time);
        }
      });
    });
    timeStamps.sort();
    return timeStamps;
  }
}

class TimedAnimation extends NamedAnimation{

  TimedAnimation({sequences}) : super(sequences:sequences);

  TimedAnimation.fromJson(Map map) {

    sequences = (map["sequences"] as Map).map((key, value) {
      return MapEntry(key, AnimationSequences.fromJson(value));
    });
  }
}

class ProgressAnimation extends NamedAnimation{

  static const double progressMaxTime=10000;

  double startOffset;
  double endOffset;

  ProgressAnimation({sequences, this.startOffset, this.endOffset}) : super(sequences:sequences);

  ProgressAnimation.fromJson(Map map) {
    startOffset=map["startOffset"];
    endOffset=map["endOffset"];
    sequences = (map["sequences"] as Map).map((key, value) {
      return MapEntry(key, AnimationSequences.fromJson(value));
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["startOffset"]=startOffset;
    rst["endOffset"]=endOffset;
    rst["sequences"] =
        sequences.map((key, value) => MapEntry(key, value.toJson()));
    return rst;
  }

  void rescaleTime() {
    sequences.forEach((name, value) {
      value.rescaleTime(progressMaxTime);
    });
  }
}

class ContinuousAnimationProgressNotifier extends ValueNotifier<double>{

  ContinuousAnimationProgressNotifier(value): super(value);

  @override
  double get value => super.value;

  @override
  set value(double newValue) {
    if (super.value == newValue)
      return;
    super.value = newValue.clamp(0.0, 1.0);
    notifyListeners();
  }
}
