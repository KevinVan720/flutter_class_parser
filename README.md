# flutter_class_parser

A package for serialize and deserialize common **UI data** classes in Flutter.

## Getting Started

To serialize/deserialize a supported class, use:
```
var gradient=LinearGradient(colors:[Colors.red, Colors.blue]);
String gradientJson=json.encode(gradient.toJson());
var gradient2=parseGradient(json.decode(gradientJson));
```

## Supported Classes

```
Color
BlendMode
TileMode
AlignmentGeometry
BoxFit
ImageRepeat
FilterQuality
StackFit
FontWeight
FontStyle
Axis
TextDecoration
TextDecorationStyle
Clip
Curve
TextAlign
MainAxisAlignment
CrossAxisAlignment
WrapAlignment
WrapCrossAlignment
Offset
Size
Rect
Radius
BorderRadius
Gradient
ColorFilter
DecorationImage
BoxDecoration
TextStyle
```

Some class parsing is not fully supported yet. For example,
the Curve class parsing only supports some of the predefined curves.

You can more than welcome to contribute and add more classes to the collection.