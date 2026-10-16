# flutter_class_parser

A package for serialize and deserialize common **UI data** classes in Flutter.

## Getting Started

To serialize/deserialize a supported class, use:
```dart
var gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
String gradientJson = json.encode(gradient.toJson());
var gradient2 = parseGradient(json.decode(gradientJson));
```

Serialization of built in classes is done using extension methods. Deserialization, on the other hand, is done
with functions.

The package only depends on the Flutter widgets library, so it works with both `package:flutter/material.dart`
and the standalone `material_ui` package.

## Current Supported Classes

1. Color
1. Orientation
1. BlendMode
1. TileMode
1. Alignment
1. BoxFit
1. ImageRepeat
1. FilterQuality
1. StackFit
1. FontWeight
1. FontStyle
1. Axis
1. AxisDirection
1. TextDecoration
1. TextDecorationStyle
1. Clip
1. Curve
1. TextOverflow
1. TextDirection
1. TextAlign
1. TextBaseline
1. MainAxisAlignment
1. CrossAxisAlignment
1. WrapAlignment
1. WrapCrossAlignment
1. MainAxisSize
1. VerticalDirection
1. BorderStyle
1. StrokeJoin
1. StrokeCap
1. Offset
1. Size
1. Rect
1. EdgeInsets
1. Radius
1. BorderRadius
1. Matrix4
1. SystemMouseCursor
1. Gradient
1. Shadow
1. ImageFilter
1. ColorFilter
1. DecorationImage
1. BoxDecoration
1. TextStyle

Some class parsing are not fully supported yet. For example:

- Curve parsing only supports the predefined curves.
- SystemMouseCursor parsing only supports the predefined cursors.
- ImageFilter parsing supports blur filters and color filters.
- ColorFilter parsing supports `ColorFilter.mode` and `ColorFilter.matrix`.
- ImageProvider parsing (used by DecorationImage) supports `NetworkImage` and `AssetImage`.
- BoxDecoration parsing supports `color`, `gradient` and `image`.
- TextStyle parsing supports the color, background color, font family, size, weight and style, letter and word spacing,
  text baseline, height and the decoration properties.

You are more than welcomed to contribute and add more classes to the collection.