
import 'dart:math';
import 'package:flutter/material.dart';
//import 'material_design_icons_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_class_parser/parseJson.dart';
import 'package:cssstylewidget/cssstylewidget.dart';

const double mobileScreenWidthTypical=400;

Widget stringEditWidget(
    {String initValue, Function onChanged, String Function(String) validator}) {
  return SizedBox(
    width: 250,
    child: TextFormField(
      initialValue: initValue,
      validator: validator,
      decoration: InputDecoration(
          filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
      onChanged: onChanged,
    ),
  );
}

Widget colorEditWidget({BuildContext context, Color currentColor, Function onChanged}) {
  currentColor = currentColor ?? Colors.black;
  return SizedBox(
    width: 250,
    child: RaisedButton(
      elevation: 3.0,
      onPressed: () {
        showMaterialColorPicker(
            context: context,
            selectedColor: currentColor,
            onChanged: onChanged
        );
      },
      child: const Text('Change me'),
      color: currentColor,
      textColor: const Color(0xff000000),
    ),
  );
}

class CustomRawIconButton extends StatelessWidget {
  void Function() onTap;
  Icon icon;
  Color color;
  double size;
  bool isDisabled;

  CustomRawIconButton(
      {@required this.icon,
        this.color = Colors.grey,
        @required this.onTap,
        this.size = 24,
        this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: !isDisabled ? onTap : null,
      child: icon,
      shape: new CircleBorder(),
      elevation: !isDisabled ? 3.0 : 0.0,
      fillColor: !isDisabled ? color : Colors.grey,
      constraints: BoxConstraints.tight(Size(size, size)),
      padding: const EdgeInsets.all(0.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class BottomDropdownButton extends StatefulWidget {
  final String headText;
  final String value;
  final ValueChanged valueChanged;
  final List<String> items;

  BottomDropdownButton({
    @required this.headText,
    this.value,
    @required this.valueChanged,
    @required this.items,
  });

  @override
  _BottomDropdownButton createState() => _BottomDropdownButton();
}

class _BottomDropdownButton extends State<BottomDropdownButton> {
  String _value;

  @override
  void initState() {
    _value = widget.value ?? widget.items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.headText + ": ",
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black38,
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            //width: 106,
            height: 40,
            padding: EdgeInsets.only(left: 4),
            margin: EdgeInsets.only(left: 4),
            child: DropdownButton<String>(
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.1),
              //isDense: true,
              //isExpanded: true,
              iconSize: 18,
              underline: Container(),
              value: _value,
              onChanged: (String value) {
                setState(() {
                  _value = value ?? widget.items[0];
                  widget.valueChanged(_value);
                });
              },
              items: widget.items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      );
  }
}

class BlockGradientPicker extends StatefulWidget {
  const BlockGradientPicker({
    Key key,
    @required this.pickerGradient,
    @required this.onGradientChanged,
  }) : super(key: key);

  final Gradient pickerGradient;
  final ValueChanged<Gradient> onGradientChanged;

  @override
  State<StatefulWidget> createState() => _BlockGradientPickerState();
}

class _BlockGradientPickerState extends State<BlockGradientPicker> {

  double maxSliderWidth = 240;
  double sliderHeight = 24;
  double blockWidth=20;

  int selectIndex = 0;

  List<Color> colors;
  List<double> stops;
  Alignment alignment1;
  Alignment alignment2;
  double radius = 1;
  double startAngle=0;
  double endAngle=360;

  TileMode tileMode;

  //double focalRadius = 1;

  Gradient currentGradient;
  int gradientType;

  @override
  void initState() {
    currentGradient = widget.pickerGradient;

    colors = currentGradient.colors;
    stops = currentGradient.stops??List<double>.generate(colors.length, (int index) => index/(colors.length-1));
    if (currentGradient is LinearGradient) {
      alignment1 = (currentGradient as LinearGradient).begin as Alignment;
      alignment2 = (currentGradient as LinearGradient).end as Alignment;
      tileMode=(currentGradient as LinearGradient).tileMode;
      gradientType = 0;
    } else if(currentGradient is RadialGradient){
      alignment1 = (currentGradient as RadialGradient).center as Alignment;
      alignment2 = Alignment.bottomRight;
      radius = (currentGradient as RadialGradient).radius;
      tileMode=(currentGradient as RadialGradient).tileMode;
      gradientType = 1;
    }else{
      alignment1 = (currentGradient as SweepGradient).center as Alignment;
      alignment2 = Alignment.bottomRight;
      tileMode=(currentGradient as SweepGradient).tileMode;
      startAngle = (currentGradient as SweepGradient).startAngle/pi*180;
      endAngle = (currentGradient as SweepGradient).endAngle/pi*180;
      gradientType = 2;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    List<Widget> sliderChildren = [
      Container(
        alignment: Alignment.centerLeft,
        width: maxSliderWidth,
        height: sliderHeight,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          stops: stops,
          colors: colors,
        )),
      )
    ];

    for (int i = 0; i < colors.length; i++) {
      bool selected=selectIndex == i;
      sliderChildren.add(Positioned(
        left: stops[i] * (maxSliderWidth-blockWidth),
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            _handleTapDown(details, i);
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            _handleHorizontalDrag(details, i);
          },
          child: Container(
            decoration: selected ?BoxDecoration(
                border:
                Border.all(
                  color: Colors.redAccent.withOpacity(0.8),
                  width:  2,
                )
            ): null,
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(
                          color: selected ? Colors.white70 : Colors.black54,
                          width: 1,
                        )
              ),
              width: blockWidth,
              height: sliderHeight+6,
              child: Container(
                decoration: BoxDecoration(
                    color: colors[i],
                    border:
                    selected ? Border.all(
                      color: Colors.black54,
                      width:  1,
                    ): null
                ),
              ),
            ),
          ),
        ),
      ));
    }

    Widget stopsWidget = Container(
      padding: EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              width: maxSliderWidth+4,
              height: sliderHeight+12,
              margin: EdgeInsets.only(left: 10),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: sliderChildren,
              )),
          Divider(),
          CustomRawIconButton(
            icon: Icon(MdiIcons.plus,size: 18,),
            color: Colors.greenAccent,
            onTap: () {
              setState(() {
                colors.add(Colors.white);
                stops.add(1);
                updateGradient();
              });
            },
          ),
          Divider(),
          CustomRawIconButton(
            icon: Icon(MdiIcons.trashCanOutline, size: 18,),
            color: Colors.redAccent,
            onTap: () {
              setState(() {
                if(colors.length>2) {
                  colors.removeAt(selectIndex);
                  stops.removeAt(selectIndex);
                  selectIndex=0;
                  updateGradient();
                }
              });
            },
          ),
          Divider(),
        ],),
    );

    return Container(
      width: min(MediaQuery.of(context).size.width, mobileScreenWidthTypical),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
              height: 100,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 100,
                    decoration: BoxDecoration(gradient: currentGradient),
                  ),
                  Align(
                    alignment: alignment1,
                    child: GestureDetector(
                        onPanUpdate: (DragUpdateDetails details) {
                          _handlePanUpdate(details, 0);
                        },
                        onPanEnd: (DragEndDetails details) {
                          _handlePanEnd(details, 0);
                        },
                        child: Icon(MdiIcons.crosshairs, color: colors.first.computeLuminance() > 0.5 ? Colors.black : Colors.white,)),
                  ),
                  gradientType==0 ? Align(
                    alignment: alignment2,
                    child: GestureDetector(
                      onPanUpdate: (DragUpdateDetails details) {
                        _handlePanUpdate(details, 1);
                      },
                      onPanEnd: (DragEndDetails details) {
                        _handlePanEnd(details, 1);
                      },
                      child: Icon(MdiIcons.crosshairs, color: colors.last.computeLuminance() > 0.5 ? Colors.black : Colors.white,)),
                  ): Container()
                ],
              )),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Radio(
              value: 0,
              groupValue: gradientType,
              onChanged: updateGradientType,
            ),
            Text("Linear"),
            Radio(
              value: 1,
              groupValue: gradientType,
              onChanged: updateGradientType,
            ),
            Text("Radial"),
            Radio(
              value: 2,
              groupValue: gradientType,
              onChanged: updateGradientType,
            ),
            Text("Sweep"),
          ]),
          stopsWidget,
          colorEditWidget(context: context, currentColor: colors[selectIndex],
          onChanged: (color) {
            colors[selectIndex] = color;
            List<Color> tempColors=[];
            for(var color in colors) {
              tempColors.add(color.withOpacity(color.opacity));
            }
            setState(() {
              colors = tempColors;
              updateGradient();
            });
          }),
          /*
          BottomSheetAlignmentSelection(
            alignment: alignment1,
            updateAlignment: (Alignment align) {
              setState(() => alignment1 = align);
              updateGradient();
            },
            headerText: gradientType == 0 ? "Start" : "Center",
          ),
          BottomSheetAlignmentSelection(
            alignment: alignment2,
            updateAlignment: (Alignment align) {
              setState(() => alignment2 = align);
              updateGradient();
            },
            headerText: gradientType == 0 ? "End" : "Focal",
          ),
          */
          gradientType == 1
          ? Row(children: [
            Text("Radius"),
            Slider(
              min: 0.0,
              max: 36.0,
              divisions: 72,
              value: radius,
              onChanged: (value) {
                setState(() {
                  radius = value;
                  updateGradient();
                });
              },
            )
          ],) : Container(),
          gradientType == 2
              ? Column(children: <Widget>[
            Row(children: [
              Text("Start Angle"),
              Slider(
                min: 0.0,
                max: 360.0,
                divisions: 72,
                value: startAngle,
                onChanged: (value) {
                  setState(() {
                    startAngle = value;
                    updateGradient();
                  });
                },
              )
            ],),
            Row(children: [
              Text("End Angle"),
              Slider(
                min: 0.0,
                max: 360.0,
                divisions: 72,
                value: endAngle,
                onChanged: (value) {
                  setState(() {
                    endAngle = value;
                    updateGradient();
                  });
                },
              )
            ],)
          ],): Container(),
          BottomDropdownButton(
            headText: "Elevation",
            value: tileMode.toString().substring(9),
            valueChanged: (value) {
              setState(() {
                tileMode=parseTileMode(value)??TileMode.clamp;
                print(tileMode);
                updateGradient();
              });
              },
            items: ["clamp", "mirror","repeated"],
          ),
        ],
      ),
    );
  }

  void updateGradient() {
    setState(() {
      if (gradientType == 0) {
        currentGradient = LinearGradient(
            tileMode: tileMode,
            begin: alignment1, end: alignment2, colors: colors, stops: stops);
      } else if(gradientType==1) {
        currentGradient = RadialGradient(
            tileMode: tileMode,
            center: alignment1,
            //focalRadius: focalRadius,
            //focal: alignment2,
            radius: radius,
            colors: colors,
            stops: stops);
      }else{
        currentGradient = SweepGradient(
            tileMode: tileMode,
            center: alignment1,
            startAngle: startAngle/180*pi,
            endAngle: endAngle/180*pi,
            colors: colors,
            stops: stops);
      }
      widget.onGradientChanged(currentGradient);
    });

  }

  void updateGradientType(int index) {
    setState(() {
      gradientType = index??0;
      updateGradient();
    });
  }

  void _handleTapDown(TapDownDetails details, int index) {
    setState(() {
      selectIndex = index;
    });
  }

  void _handleHorizontalDrag(DragUpdateDetails details, int index) {
    if (selectIndex == index) {
      setState(() {
        stops[index] += details.delta.dx / (maxSliderWidth-blockWidth);
        stops[index] = stops[index].clamp(0.0, 1.0);
        stops = List.from(stops);
      });
      updateGradient();
    }
  }


  void _handlePanUpdate(DragUpdateDetails tapInfo, int index) {
    double x,y;
    if(index==0) {
      x=alignment1.x;
      y=alignment1.y;
    }else{
      x=alignment2.x;
      y=alignment2.y;
    }
    x += tapInfo.delta.dx/mobileScreenWidthTypical*2;
    y += tapInfo.delta.dy/50;
    x=x.clamp(-1.0, 1.0);
    y=y.clamp(-1.0, 1.0);
    setState(() {
      if(index==0) {
        alignment1=Alignment(x,y);
      }else{
        alignment2=Alignment(x,y);
      }
      updateGradient();
    });
  }

  void _handlePanEnd(DragEndDetails tapInfo, int index) {
    double x,y;
    if(index==0) {
      x=alignment1.x;
      y=alignment1.y;
    }else{
      x=alignment2.x;
      y=alignment2.y;
    };
    x=roundWithNumber(x, 3);
    y=roundWithNumber(y, 3);
    setState(() {
      if(index==0) {
        alignment1=Alignment(x,y);
      }else{
        alignment2=Alignment(x,y);
      }
      updateGradient();
    });
  }


}
