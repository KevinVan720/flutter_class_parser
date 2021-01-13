import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_provider/AnimationProvider.dart';
import 'package:flutter_animation_provider/IdWidget.dart';
import 'package:flutter_animation_provider/PresetAnimations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:tuple/tuple.dart';
import 'NamedAnimation.dart';
import 'dart:math';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'BlockGradientPicker.dart';

class AnimationEditor extends StatefulWidget {
  NamedAnimation animation;
  IdWidget selectedWidget;

  AnimationEditor({this.animation, this.selectedWidget});

  @override
  _AnimationEditorState createState() => _AnimationEditorState();
}

class _AnimationEditorState extends State<AnimationEditor> {
  final double lineHeight = 48;
  final double lineMargin = 9;
  final double chipWidth = 80;
  final double horizontalMargin = 8;
  final double borderRadius = 6;
  final double touchWidth = 30;

  Tuple4<String, AnimationProperty, int, int> draggingInfo;

  NamedAnimation animation;
  final minMillisecondToWidth = 0.05;
  final maxMillisecondToWidth = 0.3;
  double millisecondToWidth = 0.08;


  @override
  void initState() {
    animation = widget.animation;
    if (animation is ProgressAnimation)
      (animation as ProgressAnimation).rescaleTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<double> timeStamps = animation.getAllTimeStamps();

    List<Widget> animationTitles = [];
    animationTitles.add(Container(
      height: lineHeight,
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: chipWidth,
            alignment: Alignment.centerLeft,
            child: Text(
              animation is ProgressAnimation ? "Progress" : "Timeline",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            width: chipWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildAddAnimationButton(),
                GestureDetector(
                    onTap: () {
                      if (millisecondToWidth > minMillisecondToWidth) {
                        setState(() {
                          millisecondToWidth -= 0.01;
                        });
                      }
                    },
                    child: Icon(MdiIcons.magnifyMinusOutline)),
                GestureDetector(
                    onTap: () {
                      if (millisecondToWidth < maxMillisecondToWidth) {
                        setState(() {
                          millisecondToWidth += 0.01;
                        });
                      }
                    },
                    child: Icon(MdiIcons.magnifyPlusOutline)),
              ],
            ),
          ),
        ],
      ),
    ));

    animation.sequences.forEach((name, value) {
      List<Widget> animationPropertyWidgets = [];
      value.sequences.forEach((property, sequence) {
        animationPropertyWidgets.add(
          buildChip(
              text: property.toJson(),
              color: Colors.black54,
              textColor: Colors.white),
        );
      });
      animationTitles.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildChip(
                text: name, color: Colors.grey[300], textColor: Colors.black),
            Container(
              width: horizontalMargin,
            ),
            Column(
              children: animationPropertyWidgets,
            )
          ],
        ),
      ));
    });

    List<Widget> animationsSequencesWidgets = buildAnimationSequencesWidget();

    int maxTimeLine = ((animation is ProgressAnimation
        ? ProgressAnimation.progressMaxTime
        : timeStamps.last) /
        1000)
        .ceil();
    animationsSequencesWidgets.insert(0, buildTimeLine(maxTimeLine));

    return Container(
      //height: 500,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Row(
          children: [
            Column(
              children: animationTitles,
            ),
            Container(
              width: MediaQuery.of(context).size.width -
                  2 * chipWidth -
                  8 * horizontalMargin,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: animationsSequencesWidgets,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChip({String text, Color color, Color textColor}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: lineMargin),
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
      height: lineHeight - 2 * lineMargin,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ]),
      child: Container(
        width: chipWidth,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            text,
            overflow: TextOverflow.fade,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }

  List<Widget> buildAnimationSequencesWidget() {

    List<Widget> animationsSequencesWidgets = [];

    animation.sequences.forEach((name, value) {
      value.sequences.forEach((property, sequence) {
        List<Widget> animationSequenceWidgets = [];

        double time = 0.0;
        double maxTimeStamp = sequence.getAllTimeStamps().last;

        Type type = AnimationPropertyTypeMap[property];

        double maxValue, minValue, startValue, endValue;
        Color startColor, endColor;
        Gradient startGradient, endGradient;

        if (type == double) {
          double initValue = widget.selectedWidget.style[property.toJson()] ??
              AnimationPropertyDefaultInitMap[property];
          maxValue = sequence.getMaxValue(initialValue: initValue);
          minValue = sequence.getMinValue(initialValue: initValue);
          startValue = (initValue - minValue) / (maxValue - minValue);

        }
        if (type == Color) {
          startColor = widget.selectedWidget.style[property] ??
              AnimationPropertyDefaultInitMap[property];
        }

        if (type == Gradient) {
          startGradient = widget.selectedWidget.style[property] ??
              AnimationPropertyDefaultInitMap[property];
        }

        for (int index = 0; index < sequence.animationData.length; index++) {
          var data = sequence.animationData[index];
          time += data.delay.inMilliseconds;

          if (type == double) {
            endValue = (data.value - minValue) / (maxValue - minValue);
          }
          if (type == Color) {
            endColor = data.value;
          }
          if (type == Gradient) {
            endGradient = data.value;
          }

          animationSequenceWidgets.add(Positioned(
              left: time * millisecondToWidth,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  int dt = (details.delta.dx/ millisecondToWidth).round();
                  setState(() {
                    draggingInfo = Tuple4(name, property, index, 0);
                    if (data.delay.inMilliseconds +
                        dt >
                        0) {
                      ///taking care of the next data
                      if (index < sequence.animationData.length - 1 &&
                          (sequence.animationData[index + 1].delay
                              .inMilliseconds -
                              dt >
                              0)) {
                          data.delay += Duration(
                              milliseconds: dt);
                          sequence.animationData[index + 1].delay -= Duration(
                              milliseconds: dt);
                      }

                      ///last one
                      else if (index == sequence.animationData.length - 1 &&
                          (animation is TimedAnimation ||
                              maxTimeStamp + dt <
                                  ProgressAnimation.progressMaxTime)) {
                          data.delay += Duration(
                              milliseconds: dt);
                      }
                    }
                  });
                },
                onHorizontalDragEnd: (DragEndDetails detail) {
                  onDragEnd(data);
                },
                onTap: () {
                  showActionEditor(
                      previousValue: index==0? widget.selectedWidget.style[property.toJson()]:animation.sequences[name].sequences[property]
                          .animationData[index-1].value,
                      onPreviousValueChanged: (value) {
                        setState(() {
                          if(index==0) {
                            widget.selectedWidget.style[property.toJson()]=value;
                          }
                          else{
                            animation.sequences[name].sequences[property]
                                .animationData[index-1].value=value;
                          }
                        });

                      },
                      inputData: data,
                      onDataChanged: (newData) {
                        setState(() {
                          animation.sequences[name].sequences[property]
                              .animationData[index] = newData;
                        });
                      },
                      onDataDelete: () {
                        setState(() {
                          animation
                              .sequences[name].sequences[property].animationData
                              .removeAt(index);
                          if (animation.sequences[name].sequences[property]
                              .animationData.isEmpty) {
                            animation.sequences[name].sequences
                                .remove(property);
                          }
                        });
                      });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    ///shadow when resizing the animation duration
                    Positioned(
                      left: touchWidth / 2,
                      top: 0,
                      bottom: 0,
                      child: Container(
                          width: touchWidth / 2,
                          height: lineHeight - 2 * lineMargin,
                          decoration: new BoxDecoration(
                              color: Colors.transparent,
                              boxShadow: draggingInfo ==
                                  Tuple4(name, property, index, -1)
                                  ? [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ]
                                  : null)),
                    ),
                    ///shadow when resizing the animation duration
                    Positioned(
                      right: touchWidth / 2,
                      top: 0,
                      bottom: 0,
                      child: Container(
                          width: touchWidth / 2,
                          height: lineHeight - 2 * lineMargin,
                          decoration: new BoxDecoration(
                              color: Colors.transparent,
                              //shape: BoxShape.circle,
                              boxShadow: draggingInfo ==
                                  Tuple4(name, property, index, 1)
                                  ? [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ]
                                  : null)),
                    ),
                    Container(
                      width: data.duration.inMilliseconds * millisecondToWidth -
                          2 +
                          touchWidth,
                      height: lineHeight - 2 * lineMargin,
                      //color: Colors.redAccent,
                    ),
                    ///actual animation bar
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.6),
                          border: Border.all(
                            width: 2,
                            color: Colors.black87,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          boxShadow:
                          draggingInfo == Tuple4(name, property, index, 0)
                              ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(
                                  5, 5), // changes position of shadow
                            ),
                          ]
                              : null),
                      width:
                      data.duration.inMilliseconds * millisecondToWidth - 2,
                      height: lineHeight - 2 * lineMargin,
                      child: type == double
                          ? CustomPaint(
                        painter: DoubleCurvePainter(
                          startScale: startValue,
                          endScale: endValue,
                          curve: data.curve,
                        ),
                      )
                          : type == Color
                          ? CustomPaint(
                        painter: ColorCurvePainter(
                          startColor: startColor,
                          endColor: endColor,
                          curve: data.curve,
                        ),
                      )
                          : type == Gradient
                          ? LoopAnimation<Gradient>(
                        tween: GradientTween(
                            begin: startGradient,
                            end: endGradient),
                        builder: (context, child, value) {
                          // <-- mandatory
                          return Container(
                            decoration:
                            BoxDecoration(gradient: value),
                          );
                        },
                        duration: data.duration,
                        curve: data.curve,
                      )
                          : Container(),
                    ),
                    ///Left handle for resizing
                    Positioned(
                        left: 1,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (DragUpdateDetails details) {
                            int dt = (details.delta.dx/ millisecondToWidth).round();
                            setState(() {
                              draggingInfo = Tuple4(name, property, index, -1);
                              if (data.delay.inMilliseconds +
                                  dt >
                                  0 &&
                                  (data.duration.inMilliseconds -
                                      dt >
                                      min(100, 10 / minMillisecondToWidth))) {
                                  data.delay += Duration(
                                      milliseconds:
                                      dt);
                                  data.duration -= Duration(
                                      milliseconds:
                                      dt);
                              }
                            });
                          },
                          onHorizontalDragEnd: (DragEndDetails detail) {
                            onDragEnd(data);
                          },
                          child: dragIndicatorDot(),
                        )),

                    ///right handle
                    Positioned(
                        right: 1,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (DragUpdateDetails details) {
                            int dt = (details.delta.dx/ millisecondToWidth).round();
                            setState(() {
                              draggingInfo = Tuple4(name, property, index, 1);
                              if (data.duration.inMilliseconds +
                                  dt >
                                  min(100, 10 / minMillisecondToWidth)) {
                                ///taking care of the next data
                                if (index < sequence.animationData.length - 1 &&
                                    (sequence.animationData[index + 1].delay
                                        .inMilliseconds -
                                        dt >
                                        0)) {
                                    data.duration += Duration(
                                        milliseconds:
                                        dt);
                                    sequence.animationData[index + 1].delay -=
                                        Duration(
                                            milliseconds:
                                            dt);
                                }
                                ///last one
                                else if (index ==
                                    sequence.animationData.length - 1 &&
                                    (animation is TimedAnimation ||
                                        (sequence.getAllTimeStamps().last +
                                            dt) <
                                            ProgressAnimation.progressMaxTime)) {
                                    data.duration += Duration(
                                        milliseconds:
                                        dt);
                                }
                              }
                            });
                          },
                          onHorizontalDragEnd: (DragEndDetails detail) {
                            onDragEnd(data);
                          },
                          child: dragIndicatorDot(),
                        )),
                    draggingInfo == Tuple4(name, property, index, -1) ||
                        draggingInfo == Tuple4(name, property, index, 0)
                        ? Positioned(
                      left: 0,
                      top: -30,
                      child: timeToolTip(getDisplayTime(time)),
                    )
                        : Container(),
                    draggingInfo == Tuple4(name, property, index, 1) ||
                        draggingInfo == Tuple4(name, property, index, 0)
                        ? Positioned(
                      right: 0,
                      top: -30,
                      child: timeToolTip(getDisplayTime(
                          time + data.duration.inMilliseconds)),
                    )
                        : Container(),
                  ],
                ),
              )));

          time += data.duration.inMilliseconds;
          startValue = endValue;
          if (type == Color) {
            startColor = endColor;
          }
          if (type == Gradient) {
            startGradient = endGradient;
          }
        }
        animationsSequencesWidgets.add(Container(
            margin: EdgeInsets.symmetric(vertical: lineMargin),
            width: time * millisecondToWidth + 10,
            height: lineHeight - 2 * lineMargin,
            child: Stack(
              clipBehavior: Clip.none,
              children: animationSequenceWidgets,
            )));
      });
    });

    return animationsSequencesWidgets;
  }

  void onDragEnd(AnimationData data) {
    setState(() {
      data.delay = Duration(
          milliseconds: (data.delay.inMilliseconds / 100).round() * 100);
      data.duration = Duration(
          milliseconds: (data.duration.inMilliseconds / 100).round() * 100);
      draggingInfo = null;
    });
  }

  Widget timeToolTip(String text) {
    return Material(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(text, style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget dragIndicatorDot() {
    return Container(
      width: touchWidth,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Container(
          width: 6,
          height: 6,
          decoration: new BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
          )),
    );
  }

  Widget buildAddAnimationButton() {
    return GestureDetector(
        onTap: () {
          Widget dataEditingPanel = SingleChildScrollView(
            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
            child: Container(
              child: AddNewAnimation(
                selectedWidget: "container1",
                animationSequences: animation.sequences["container1"],
                onFinishEditing: (AnimationSequences animationSequences,
                    Map<AnimationProperty, dynamic> initialValues) {
                  setState(() {
                    animation.sequences["container1"] = animationSequences;
                    if (animation is ProgressAnimation) {
                      animation.sequences["container1"]
                          .rescaleTime(ProgressAnimation.progressMaxTime);
                    }
                    print(animation.toJson());
                    print(initialValues);
                    widget.selectedWidget.style.addAll(initialValues
                        .map((key, value) => MapEntry(key.toJson(), value)));
                  });
                },
              ),
            ),
          );
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: dataEditingPanel, actions: <Widget>[]);
              });
        },
        child: Icon(MdiIcons.plus));
  }

  String getDisplayTime(double time) {
    return animation is TimedAnimation
        ? (time / 1000).toStringAsFixed(0) + "s"
        : (time / 100).toStringAsFixed(0) + "%";
  }

  Widget buildTimeLine(int maxTime) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(
          left: touchWidth / 2, top: lineMargin, bottom: lineMargin),
      padding: EdgeInsets.symmetric(horizontal: 2),
      width: maxTime * 1000 * millisecondToWidth,
      height: lineHeight - 2 * lineMargin,
      color: Colors.amber,
      child: CustomPaint(
        painter: TimeLinePainter(maxTime: maxTime),
        child: Stack(
          children: List.generate(
              maxTime,
              (index) => AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  left: 0.5 + index * 1000 * millisecondToWidth,
                  top: 1,
                  child: Text(getDisplayTime(index * 1000.0)))),
        ),
      ),
    );
  }

  void showActionEditor(
      {dynamic previousValue,
      Function onPreviousValueChanged,
      AnimationData inputData,
      Function onDataChanged,
      Function onDataDelete}) {
    Function onFinishEditing;
    onFinishEditing = () => Navigator.of(context).pop();

    Widget dataEditingPanel = SingleChildScrollView(
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
      child: Container(
        child: ActionEditor(
          previousValue: previousValue,
          onPreviousValueChanged: onPreviousValueChanged,
          data: inputData,
          onDataChanged: onDataChanged,
          onFinishEditing: onFinishEditing,
          onDataDelete: onDataDelete,
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: dataEditingPanel, actions: <Widget>[]);
        });
  }
}

class AddNewAnimation extends StatefulWidget {
  AnimationSequences animationSequences;
  String selectedWidget;
  //Function onDataAdded;
  //Function onPresetAdded;
  Function onFinishEditing;

  AddNewAnimation(
      {this.selectedWidget, this.animationSequences, this.onFinishEditing});

  @override
  _AddNewAnimationState createState() => _AddNewAnimationState();
}

class _AddNewAnimationState extends State<AddNewAnimation> {
  AnimationSequences animationSequences;
  AnimationProperty selectedProperty;
  Map<AnimationProperty, dynamic> initValues = {};
  PresetAnimation selectedPresetAnimation;

  @override
  void initState() {
    animationSequences = widget.animationSequences;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      child: ListView(
        children: [
          Text(widget.selectedWidget),
          DropdownButton<AnimationProperty>(
              hint: Text("Select a property"),
              value: selectedProperty,
              onChanged: (AnimationProperty prop) {
                setState(() {
                  selectedProperty = prop;
                  selectedPresetAnimation = null;
                });
              },
              items: AnimationProperty.values
                  .map<DropdownMenuItem<AnimationProperty>>(
                      (AnimationProperty prop) {
                return DropdownMenuItem<AnimationProperty>(
                  value: prop,
                  child: Text(prop.toJson()),
                );
              }).toList()),
          DropdownButton<PresetAnimation>(
              hint: Text("Select a preset animation"),
              value: selectedPresetAnimation,
              onChanged: (PresetAnimation animation) {
                setState(() {
                  selectedPresetAnimation = animation;
                  selectedProperty = null;
                });
              },
              items: presetAnimationsMap.values
                  .map<DropdownMenuItem<PresetAnimation>>(
                      (PresetAnimation animation) {
                return DropdownMenuItem<PresetAnimation>(
                  value: animation,
                  child: Text(animation.name),
                );
              }).toList()),
          selectedPresetAnimation != null
              ? buildPresetAnimationOptions()
              : Container(),
          Row(
            children: [
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    //widget.onFinishEditing();
                  }),
              TextButton(
                child: Text("Save"),
                onPressed: () {
                  if (selectedProperty != null) {
                    Type type = AnimationPropertyTypeMap[selectedProperty];
                    if (animationSequences.sequences[selectedProperty] ==
                        null) {
                      if (type == double) {
                        animationSequences.sequences[selectedProperty] =
                            AnimationSequence<double>(animationData: []);
                      }
                      if (type == Color) {
                        animationSequences.sequences[selectedProperty] =
                            AnimationSequence<Color>(animationData: []);
                      }
                      if (type == Gradient) {
                        animationSequences.sequences[selectedProperty] =
                            AnimationSequence<Gradient>(animationData: []);
                      }
                    }
                    animationSequences.sequences[selectedProperty]
                      ..add(
                          duration: Duration(seconds: 1),
                          value: AnimationPropertyDefaultInitMap[
                              selectedProperty]);
                    initValues[selectedProperty] =
                        AnimationPropertyDefaultInitMap[selectedProperty];
                    widget.onFinishEditing(animationSequences, initValues);
                    Navigator.of(context).pop();
                  } else {
                    animationSequences =
                        selectedPresetAnimation.getAnimationSequences();
                    initValues = selectedPresetAnimation.getInitValues();
                    widget.onFinishEditing(animationSequences, initValues);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildPresetAnimationOptions() {
    List<Widget> options = [];
    selectedPresetAnimation.optionTypes.forEach((name, type) {
      if (type == bool) {
        options.add(Row(
          children: [
            Text(name),
            Switch(
              value: selectedPresetAnimation.options[name],
              onChanged: (value) {
                setState(() {
                  selectedPresetAnimation.options[name] = value;
                });
              },
            ),
          ],
        ));
      }
      if (type == Alignment) {
        options.add(Row(
          children: [
            Text(name),
            DropdownButton<Alignment>(
                value: selectedPresetAnimation.options[name],
                onChanged: (Alignment align) {
                  setState(() {
                    selectedPresetAnimation.options[name] = align;
                  });
                },
                items: [
                  Alignment.topLeft,
                  Alignment.topCenter,
                  Alignment.topRight,
                  Alignment.centerLeft
                ].map<DropdownMenuItem<Alignment>>((Alignment align) {
                  return DropdownMenuItem<Alignment>(
                    value: align,
                    child: Text(align.toString()),
                  );
                }).toList())
          ],
        ));
      }
    });

    return Column(
      children: options,
    );
  }
}

class ActionEditor extends StatefulWidget {
  dynamic previousValue;
  Function onPreviousValueChanged;
  AnimationData data;
  Function onDataChanged;
  Function onFinishEditing;
  Function onDataDelete;
  ActionEditor(
      {this.previousValue,
      this.onPreviousValueChanged,
      this.data,
      this.onDataChanged,
      this.onFinishEditing,
      this.onDataDelete});

  @override
  _ActionEditorState createState() => _ActionEditorState();
}

class _ActionEditorState extends State<ActionEditor> {
  dynamic previousValue;
  AnimationData data;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    previousValue = widget.previousValue;
    data = widget.data;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    widgets.add(Row(
      children: [
        TextButton(
            child: Text("Cancel"),
            onPressed: () {
              widget.onFinishEditing();
            }),
        TextButton(
          child: Text("Save"),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              widget.onPreviousValueChanged(previousValue);
              widget.onDataChanged(data);
              widget.onFinishEditing();
            }
          },
        ),
        TextButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            widget.onDataDelete();
            widget.onFinishEditing();
          },
        ),
      ],
    ));

    widgets.add(
      Row(
        children: [
          Text("Duration:"),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(4),
                height: 40,
                child: stringEditWidget(
                    initValue: (data.duration.inMilliseconds / 1000)
                        .toStringAsFixed(2),
                    onChanged: (text) {
                      double newDuration = double.tryParse(text);
                      if (newDuration != null) {
                        setState(() {
                          data.duration = Duration(
                              milliseconds: (newDuration * 1000).round());
                          //widget.onDataChanged(data);
                        });
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    })),
          ),
        ],
      ),
    );

    widgets.add(dataEditor(
      headerText: "From:",
        value: previousValue,
        onChanged: (value) {
          setState(() {
            previousValue = value;
          });
        }));


    widgets.add(dataEditor(
      headerText: "To:",
        value: data.value,
        onChanged: (value) {
          setState(() {
            data.value = value;
          });
        }));

    return Container(
      width: 400,
      height: 500,
      child: Form(
          key: _formKey,
          child: ListView(
            children: widgets,
          )),
    );
  }

  Widget dataEditor({String headerText, dynamic value, Function onChanged}) {
    if (value is double) {
      return Row(
        children: [
          Text(headerText),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(4),
                height: 40,
                child: stringEditWidget(
                    initValue: value.toString(),
                    onChanged: (text) {
                      double newValue = double.tryParse(text);
                      if (newValue != null) {
                        onChanged(newValue);
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    })),
          ),
        ],
      );
    }

    if (value is Color) {
      return Row(
        children: [
          Text("Value:"),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(4),
                height: 40,
                child: colorEditWidget(
                  context: context,
                  currentColor: value,
                  onChanged: onChanged,
                )),
          ),
        ],
      );
    }

    if (value is Gradient) {
      return Row(
        children: [
          Text("Value:"),
          Expanded(
              child: BottomSheetGradientPicker(
                currentGradient: value,
                gradientChanged: onChanged,
              )),
        ],
      );
    }
    return Container();
  }
}

class BottomSheetGradientPicker extends StatefulWidget {
  BottomSheetGradientPicker({
    Key key,
    this.headText = "Color",
    this.currentGradient,
    @required this.gradientChanged,
  }) : super(key: key);

  final String headText;
  final Gradient currentGradient;
  final ValueChanged<Gradient> gradientChanged;

  @override
  _BottomSheetGradientPicker createState() => _BottomSheetGradientPicker();
}

class _BottomSheetGradientPicker extends State<BottomSheetGradientPicker> {
  Gradient currentGradient;

  @override
  void initState() {
    currentGradient = widget.currentGradient ??
        LinearGradient(
            tileMode: TileMode.clamp,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.lightBlue, Colors.amber],
            stops: [0, 0.8, 1]);
    super.initState();
  }

  void changeGradient(Gradient gradient) {
    setState(() => currentGradient = gradient);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            height: 50,
            child: Text(
              widget.headText + ": ",
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
                onTap: showGradientPicker,
                child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(gradient: currentGradient),
                    )),
          ),
        ],
    );
  }

  void showGradientPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: BlockGradientPicker(
              pickerGradient: currentGradient,
              onGradientChanged: changeGradient,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() {
                  widget.gradientChanged(currentGradient);
                });
                Navigator.of(context)?.pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class TimeLinePainter extends CustomPainter {
  int maxTime;
  TimeLinePainter({this.maxTime});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2;

    final path = new Path();

    double dx = size.width / maxTime / 10;
    double x = 0;
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), paint);
    for (int i = 0; i < maxTime * 10 + 1; i++) {
      if (i % 10 == 0) {
        canvas.drawLine(
            Offset(x, size.height), Offset(x, size.height - 10), paint);
      }
      canvas.drawLine(
          Offset(x, size.height), Offset(x, size.height - 5), paint);
      x += dx;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DoubleCurvePainter extends CustomPainter {
  double startScale;
  double endScale;
  Curve curve;
  DoubleCurvePainter({this.startScale, this.endScale, this.curve});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint.color = Colors.green;
    paint.style = PaintingStyle.fill;

    final path = new Path();

    double dx = size.width / 100;
    double x1, y1, x2, y2;
    x1 = 0.0;
    y1 = size.height - size.height * startScale;

    path..moveTo(x1, y1);
    for (int i = 0; i < 100; i++) {
      x2 = x1 + dx;
      y2 = size.height -
          (size.height * startScale +
              size.height *
                  (endScale - startScale) *
                  curve.transform(x1 / size.width));
      path..lineTo(x2, y2);
      //canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      x1 = x2;
      y1 = y2;
    }
    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height - size.height * startScale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ColorCurvePainter extends CustomPainter {
  Color startColor;
  Color endColor;
  Curve curve;
  ColorCurvePainter({this.startColor, this.endColor, this.curve});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint.style = PaintingStyle.fill;

    ColorTween tween = ColorTween(begin: startColor, end: endColor);

    final path = new Path();
    double dx = size.width / 100;
    double x;
    x = 0.0;
    for (int i = 0; i < 100; i++) {
      paint.color = tween.transform(curve.transform(x / size.width));
      canvas.drawRect(Rect.fromLTRB(x, size.height, x + dx * 1.1, 0), paint);
      x += dx;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
