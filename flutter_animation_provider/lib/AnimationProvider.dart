import 'package:flutter/material.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:simple_animations/simple_animations.dart';
import 'NamedAnimation.dart';

class AnimationNotifier extends ChangeNotifier {
  Map<String, NamedAnimation> animationPool = {};

  Map<String, String> currentAnimationNames= {};
  Map<String, AnimationSequences> currentAnimations = {};
  Map<String, CustomAnimationControl> currentAnimationsControl = {};

  Map<String, AnimationSequences> currentContinuousAnimations = {};
  Map<String, String> currentContinuousAnimationNames= {};
  Map<String, ContinuousAnimationProgressNotifier> animationProgressNotifiers ={};
  AnimationNotifier({this.animationPool});

  void updateAnimationStatus(
      String animationId, CustomAnimationControl newStatus) {
    animationPool[animationId]?.sequences?.forEach((applier, value) {
      currentAnimations[applier] = value;
      currentAnimationsControl[applier] = newStatus;
    });
    notifyListeners();
  }
  
  void updateContinuousAnimationStatus(String animationId, bool running) {
    animationPool[animationId]?.sequences?.forEach((applier, value) {
      if (running) {
        currentContinuousAnimationNames[applier]=animationId;
        currentContinuousAnimations[applier] = value;
      } else {
        currentContinuousAnimationNames.remove(applier);
        currentContinuousAnimations.remove(applier);
      }
    });
    notifyListeners();
  }
}
