import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortuuid/shortuuid.dart';
import 'AnimationProvider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';
import 'NamedAnimation.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:after_layout/after_layout.dart';

class ParentScroll extends InheritedWidget {
  static of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ParentScroll>();

  final ScrollController controller;
  final Axis direction;

  ParentScroll({
    Key key,
    @required Widget child,
    @required this.controller,
    @required this.direction,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ParentScroll oldWidget) {
    return this.controller != oldWidget.controller ||
        this.direction != oldWidget.direction;
  }
}

class IdWidget extends StatefulWidget {
  String id;
  String type;
  Map<String, dynamic> style;
  Map<AnimationTrigger, String> animationTriggers;
  Widget child;

  IdWidget(
      {Key key,
      this.id,
      this.type,
      this.child,
      this.style = const {},
      this.animationTriggers = const {}})
      : super(key: key);

  @override
  IdWidgetState createState() => IdWidgetState();
}

/*
mixin AnimationProviderStateMixin<T extends StatefulWidget> on State<T> {
  bool usingTypeAnimation = false;
  bool usingTypeContinuousAnimation = false;
}
*/

class IdWidgetState extends State<IdWidget> {
  bool animationFromType = false;
  bool continuousAnimationFromType = false;

  bool isVisible=false;

  double startOffset=0.0;
  double currentOffset=0.0;
  double endOffset=1.0;
  double currentScrollOffset=0.0;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.id),
      onVisibilityChanged: (VisibilityInfo visibilityInfo) {
        //print(widget.id);
        triggerElementScrollAnimation(visibilityInfo);
        triggerElementVisibilityChangeAnimation(visibilityInfo);
      },
      child: buildContinuousAnimationWidget(
          child: buildAnimationWidget(
              child: staticWidgetBuilder(
                  widget.child))),
    );
  }

  void triggerElementVisibilityChangeAnimation(VisibilityInfo visibilityInfo) {
    if (widget.animationTriggers
        .containsKey(AnimationTrigger.elementVisibilityChange)) {
      Provider.of<AnimationNotifier>(context, listen: false)
          .updateAnimationStatus(
          widget.animationTriggers[
          AnimationTrigger.elementVisibilityChange],
          CustomAnimationControl.PLAY);
    }
  }

  void triggerElementScrollAnimation(VisibilityInfo visibilityInfo) {
    if(widget.animationTriggers
        .containsKey(AnimationTrigger.elementScroll)) {
      String elementScrollAnimationName = widget
          .animationTriggers[AnimationTrigger.elementScroll];
      Function scrollProgressCallBack = () {
        if(mounted) {
          Provider
              .of<AnimationNotifier>(context, listen: false)
              .animationProgressNotifiers[elementScrollAnimationName]
              ?.value = (currentOffset - ParentScroll
              .of(context)
              .controller
              .offset + currentScrollOffset) / (endOffset - startOffset);
        }
      };
      if (mounted) {
        if (!isVisible) {
          if (ParentScroll
              .of(context)
              .direction == Axis.vertical) {
            setState(() {
              startOffset = 0.0;
              //endOffset=MediaQuery.of(context).size.height+visibilityInfo.widgetBounds.height;
              endOffset = MediaQuery
                  .of(context)
                  .size
                  .height;
              currentOffset = visibilityInfo.widgetBounds.top;
              currentScrollOffset = ParentScroll
                  .of(context)
                  .controller
                  .offset;
            });
          } else {
            setState(() {
              startOffset = 0.0;
              //endOffset=MediaQuery.of(context).size.width+visibilityInfo.widgetBounds.width;
              endOffset = MediaQuery
                  .of(context)
                  .size
                  .width;
              currentOffset = visibilityInfo.widgetBounds.left;
              currentScrollOffset = ParentScroll
                  .of(context)
                  .controller
                  .offset;
            });
          }
          Provider
              .of<AnimationNotifier>(context, listen: false)
              .animationProgressNotifiers[elementScrollAnimationName] =
              ContinuousAnimationProgressNotifier(
                  (currentOffset) / (endOffset - startOffset));
          Provider.of<AnimationNotifier>(context, listen: false)
              .updateContinuousAnimationStatus(
              elementScrollAnimationName, true);
          (ParentScroll
              .of(context)
              .controller as ScrollController).addListener(
              scrollProgressCallBack);
          setState(() {
            isVisible = true;
          });
        }
      } else {
          Provider
              .of<AnimationNotifier>(context, listen: false)
              .animationProgressNotifiers
              .remove(elementScrollAnimationName);
          Provider.of<AnimationNotifier>(context, listen: false)
              .updateContinuousAnimationStatus(
              widget.animationTriggers[
              elementScrollAnimationName],
              false);

          (ParentScroll
              .of(context)
              .controller as ScrollController).removeListener(
              scrollProgressCallBack);
          setState(() {
            isVisible = false;
          });
      }
    }
  }

  Widget staticWidgetBuilder(Widget child) {
    Matrix4 transform = Matrix4.skew(widget.style["skewX"] ?? 0.0 * pi / 180,
        widget.style["skewY"] ?? 0.0 * pi / 180)
      ..rotateX(widget.style["rotationX"] ?? 0.0 * pi / 180)
      ..rotateY(widget.style["rotationY"] ?? 0.0 * pi / 180)
      ..rotateZ(widget.style["rotationZ"] ?? 0.0 * pi / 180)
      ..scale(widget.style["scaleX"] ?? 1.0, widget.style["scaleY"] ?? 1.0);

    return Transform.translate(
      offset: Offset(widget.style["translationX"] ?? 0.0,
          widget.style["translationY"] ?? 0.0),
      child: Transform(
        transform: transform,
        alignment: FractionalOffset.center,
        child: Container(
            color: widget.style["backgroundColor"] ?? Colors.transparent,
            child: child),
      ),
    );
  }

  MultiTween getMultiTweenFromAnimationSequences(AnimationSequences sequences) {
    return sequences.getAnimationTween(initialValues: {
      AnimationProperty.skewX: widget.style["skewX"] ?? 0.0,
      AnimationProperty.skewY: widget.style["skewY"] ?? 0.0,
      AnimationProperty.scaleX: widget.style["scaleX"] ?? 1.0,
      AnimationProperty.scaleY: widget.style["scaleY"] ?? 1.0,
      AnimationProperty.rotationX: widget.style["rotationX"] ?? 0.0,
      AnimationProperty.rotationY: widget.style["rotationY"] ?? 0.0,
      AnimationProperty.rotationZ: widget.style["rotationZ"] ?? 0.0,
      AnimationProperty.translationX: widget.style["translationX"] ?? 1.0,
      AnimationProperty.translationY: widget.style["translationY"] ?? 1.0,
      AnimationProperty.backgroundColor:
          widget.style["backgroundColor"] ?? Colors.transparent,
      AnimationProperty.opacity: widget.style["opacity"] ?? 1.0,
    });
  }

  Widget buildAnimationWidget({Widget child}) {
    bool hasId = widget.id != null;
    bool hasType = widget.type != null;
    var idAnimatedWidget = hasId
        ? buildAnimationListenerBy(
            classifier: widget.id, usingClass: false, child: child)
        : Container();
    var typeAnimatedWidget = hasType
        ? buildAnimationListenerBy(
            classifier: widget.type, usingClass: true, child: child)
        : Container();
    if (hasId && hasType) {
      return animationFromType ? typeAnimatedWidget : idAnimatedWidget;
    } else if (hasId) {
      return idAnimatedWidget;
    } else if (hasType) {
      return typeAnimatedWidget;
    } else {
      return child;
    }
  }

  Widget buildContinuousAnimationWidget({Widget child}) {
    bool hasId = widget.id != null;
    bool hasType = widget.type != null;
    var idAnimatedWidget = hasId
        ? buildContinuousAnimationListenerBy(
            classifier: widget.id,
            usingClass: false,
            child: child)
        : Container();
    var typeAnimatedWidget = hasType
        ? buildContinuousAnimationListenerBy(
            classifier: widget.type,
            usingClass: true,
            child: child)
        : Container();
    if (hasId && hasType) {
      return continuousAnimationFromType
          ? typeAnimatedWidget
          : idAnimatedWidget;
    } else if (hasId) {
      return idAnimatedWidget;
    } else if (hasType) {
      return typeAnimatedWidget;
    } else {
      return child;
    }
  }

  Widget buildAnimationListenerBy(
      {String classifier, bool usingClass, Widget child}) {
    return Selector<AnimationNotifier,
            Tuple2<CustomAnimationControl, AnimationSequences>>(
        selector: (_, notifier) => Tuple2(
            notifier.currentAnimationsControl[classifier],
            notifier.currentAnimations[classifier]),
        child: child,
        builder: (context, tuple, child) {
          CustomAnimationControl control = tuple?.item1;
          AnimationSequences sequences = tuple?.item2;
          if (control == null || sequences == null) {
            return child;
          }
          animationFromType = usingClass;

          var multiTween = getMultiTweenFromAnimationSequences(sequences);

          return buildCustomAnimation(
              multiTween: multiTween, control: control, child: widget.child);
        });
  }

  Widget buildContinuousAnimationListenerBy(
      {String classifier, bool usingClass, Widget child}) {
    return Selector<AnimationNotifier, AnimationSequences>(
        selector: (_, notifier) =>
            notifier.currentContinuousAnimations[classifier],
        child: child,
        builder: (context, sequences, child) {
          if (sequences == null) {
            return child;
          }
          continuousAnimationFromType = usingClass;
          var multiTween = getMultiTweenFromAnimationSequences(sequences);
          return buildCustomContinuousAnimation(
              classifier: classifier,
              multiTween: multiTween, child: widget.child);
        });
  }

  Widget buildCustomAnimation(
      {Duration delay,
      var multiTween,
      CustomAnimationControl control,
      Widget child}) {
    return CustomAnimation<MultiTweenValues<AnimationProperty>>(
      delay: delay,
      control: control, // <
      duration: multiTween.duration, // -- bind state variable to parameter
      tween: multiTween,
      builder: animatedWidgetBuilder,
      child: child,
    );
  }

  //TODO: currently only use scrollcontrollers
  Widget buildCustomContinuousAnimation({MultiTween multiTween, String classifier, Widget child}) {
    ScrollController controller = ParentScroll.of(context).controller;
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (BuildContext context, Widget child) {
        String currentContinuousAnimationName=Provider.of<AnimationNotifier>(context, listen: false).currentContinuousAnimationNames[classifier];
        print(currentContinuousAnimationName);
        double progress=Provider.of<AnimationNotifier>(context, listen: false).animationProgressNotifiers[currentContinuousAnimationName]?.value??0.0;
        //double progress=controller.offset / controller.position.maxScrollExtent;
        //print(controller.offset.toString()+", "+Provider.of<AnimationNotifier>(context, listen: false).animationProgressNotifiers["animation1"].value.toString());
        //print(widget.id);
        //print(currentOffset.toString()+", "+currentScrollOffset.toString()+", "+startOffset.toString()+", "+endOffset.toString());
        //double progress=(currentOffset+controller.offset-currentScrollOffset)/(endOffset-startOffset);
        print(progress);
        MultiTweenValues values = multiTween
            .transform(progress);
        return animatedWidgetBuilder(context, child, values);
      },
    );
  }

  Widget animatedWidgetBuilder(
      BuildContext context, Widget child, MultiTweenValues values) {

    Matrix4 transform = Matrix4.skew(
        values.getOrElse(AnimationProperty.skewX, widget.style["skewX"] ?? 0.0) *
            pi /
            180,
        values.getOrElse(AnimationProperty.skewY, widget.style["skewY"] ?? 0.0) *
            pi /
            180)
      ..rotateX(values.getOrElse(
              AnimationProperty.rotationX, widget.style["rotationX"] ?? 0.0) *
          pi /
          180)
      ..rotateY(values.getOrElse(
              AnimationProperty.rotationY, widget.style["rotationY"] ?? 0.0) *
          pi /
          180)
      ..rotateZ(values.getOrElse(
              AnimationProperty.rotationZ, widget.style["rotationZ"] ?? 0.0) *
          pi /
          180)
      ..scale(
          values.getOrElse(
              AnimationProperty.scaleX, widget.style["scaleX"] ?? 1.0),
          values.getOrElse(AnimationProperty.scaleY, widget.style["scaleY"] ?? 1.0),
          1.0);

    return Opacity(
        opacity: values.getOrElse(
        AnimationProperty.opacity, widget.style["opacity"] ?? 1.0),
    child: FractionalTranslation(
      translation: Offset(
          values.getOrElse(AnimationProperty.translationX,
              widget.style["translationX"] ?? 0),
          values.getOrElse(AnimationProperty.translationY,
              widget.style["translationY"] ?? 0)),
      child: Transform(
        transform: transform,
        alignment: FractionalOffset.center,
        child: Container(
          width: values.getOrElse(
              AnimationProperty.width, null),
            height: values.getOrElse(
                AnimationProperty.height, null),
            decoration: BoxDecoration(
                color: values.getOrElse(AnimationProperty.backgroundColor,
                    widget.style["backgroundColor"] ?? Colors.transparent),
                gradient: values.getOrElse(AnimationProperty.backgroundGradient,
                    widget.style["backgroundGradient"] ?? null)),
            child: child),
      ),
    ));
  }
}
