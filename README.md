# flutter_class_parser

A package for serialize and deserialize common **UI data** classes in Flutter.

## Getting Started

To serialize/deserialize a supported class, use:
```
var gradient=LinearGradient(colors:[Colors.red, Colors.blue]);
String gradientJson=json.encode(gradient.toJson());
var gradient2=parseGradient(json.decode(gradientJson));
```

## Current Supported Classes

```
Color
BlendMode
TileMode
Alignment
BoxFit
ImageRepeat
FilterQuality
StackFit
FontWeight
FontStyle
Axis
AxisDirection
TextDecoration
TextDecorationStyle
Clip
Curve
TextOverflow
TextDirection
TextAlign
TextBaseline
FontWeight
EdgeInsetsGeometry
MainAxisAlignment
CrossAxisAlignment
WrapAlignment
WrapCrossAlignment
MainAxisSize
VerticalDirection
BorderStyle
Offset
Size
Rect
Radius
BorderRadius
Matrix4
SystemMouseCursor
Gradient
ColorFilter
DecorationImage
BoxDecoration
TextStyle
```

Some class parsing are not fully supported yet. For example,
the Curve class parsing only supports the predefined curves.

You are more than welcomed to contribute and add more classes to the collection.