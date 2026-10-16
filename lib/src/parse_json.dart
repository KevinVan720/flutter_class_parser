import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'named_values.dart';
import 'to_json.dart';

///Parse string or a map to various built-in UI data classes
///Functions are all called parse + class name
///The input and output should all be nullable

// The name is part of the public API, so it is kept for compatibility.
// ignore: camel_case_extensions
extension stringParsingExtension on String {
  String stripFirstDot() {
    return substring(indexOf('.') + 1);
  }
}

///Returns the enum value named [string], or null if there is none.
T? _parseEnum<T extends Enum>(List<T> values, String? string) {
  for (T value in values) {
    if (value.name == string) return value;
  }
  return null;
}

///Reads a JSON number, which can be an int or a double, as a double.
double? _toDouble(dynamic value) => (value as num?)?.toDouble();

Color? parseColor(String? string) {
  if (string == null) return null;
  int colorInt = int.tryParse(string, radix: 16) ?? 0xFFFFFFFF;
  return Color(colorInt);
}

Orientation? parseOrientation(String? string) =>
    _parseEnum(Orientation.values, string);

BlendMode? parseBlendMode(String? string) =>
    _parseEnum(BlendMode.values, string);

TileMode? parseTileMode(String? string) => _parseEnum(TileMode.values, string);

///not an enum
///Parses the names of the predefined alignments, for example "topLeft", and
///"(x, y)" for other alignments.
Alignment? parseAlignment(String? string) {
  if (string == null) return null;
  switch (string) {
    case 'topLeft':
      return Alignment.topLeft;
    case 'topCenter':
      return Alignment.topCenter;
    case 'topRight':
      return Alignment.topRight;
    case 'centerLeft':
      return Alignment.centerLeft;
    case 'center':
      return Alignment.center;
    case 'centerRight':
      return Alignment.centerRight;
    case 'bottomLeft':
      return Alignment.bottomLeft;
    case 'bottomCenter':
      return Alignment.bottomCenter;
    case 'bottomRight':
      return Alignment.bottomRight;
  }

  int start = string.indexOf("(");
  int end = string.indexOf(")", start + 1);
  if (start < 0 || end < 0) return null;
  List<String> aligns = string.substring(start + 1, end).split(",");
  if (aligns.length < 2) return null;
  double? x = double.tryParse(aligns[0]);
  double? y = double.tryParse(aligns[1]);
  if (x == null || y == null) return null;
  return Alignment(x, y);
}

BoxFit? parseBoxFit(String? string) => _parseEnum(BoxFit.values, string);

ImageRepeat? parseImageRepeat(String? string) =>
    _parseEnum(ImageRepeat.values, string);

FilterQuality? parseFilterQuality(String? string) =>
    _parseEnum(FilterQuality.values, string);

StackFit? parseStackFit(String? string) => _parseEnum(StackFit.values, string);

FontStyle? parseFontStyle(String? string) =>
    _parseEnum(FontStyle.values, string);

Axis? parseAxis(String? string) => _parseEnum(Axis.values, string);

AxisDirection? parseAxisDirection(String? string) =>
    _parseEnum(AxisDirection.values, string);

///not an enum
///Parses a single decoration, for example "underline", or a combined one, for
///example "combine([underline, lineThrough])".
TextDecoration? parseTextDecoration(String? string) {
  if (string == null) return null;
  if (string == "none") return TextDecoration.none;
  TextDecoration? decoration = textDecorationsByName[string];
  if (decoration != null) return decoration;

  Match? combined = RegExp(r"^combine\(\[(.*)\]\)$").firstMatch(string);
  if (combined == null) return null;
  List<TextDecoration> decorations = [];
  for (String name in combined.group(1)!.split(",")) {
    TextDecoration? decoration = textDecorationsByName[name.trim()];
    if (decoration == null) return null;
    decorations.add(decoration);
  }
  return TextDecoration.combine(decorations);
}

TextDecorationStyle? parseTextDecorationStyle(String? string) =>
    _parseEnum(TextDecorationStyle.values, string);

Clip? parseClip(String? string) => _parseEnum(Clip.values, string);

///not an enum
///Only the predefined [Curves] are supported.
Curve? parseCurve(String? string) => curvesByName[string];

TextOverflow? parseTextOverflow(String? string) =>
    _parseEnum(TextOverflow.values, string);

TextDirection? parseTextDirection(String? string) =>
    _parseEnum(TextDirection.values, string);

TextAlign? parseTextAlign(String? string) =>
    _parseEnum(TextAlign.values, string);

TextBaseline? parseTextBaseline(String? string) =>
    _parseEnum(TextBaseline.values, string);

///sorta like an enum
///Parses "w100" to "w900", and other weights in the "FontWeight(450)" format.
FontWeight? parseFontWeight(String? string) {
  if (string == null) return null;
  for (FontWeight weight in FontWeight.values) {
    if (weight.toJson() == string) return weight;
  }

  Match? match = RegExp(r"^FontWeight\((\d+)\)$").firstMatch(string);
  if (match == null) return null;
  int value = int.parse(match.group(1)!);
  //The FontWeight constructor is not public in all supported Flutter
  //versions. Where it is, lerp creates the exact weight, otherwise the
  //closest predefined one.
  return FontWeight.lerp(
      FontWeight.w100, FontWeight.w900, (value - 100) / (900 - 100));
}

///Parses a "left,top,right,bottom" string, for example "8,0,8,0".
EdgeInsetsGeometry? parseEdgeInsetsGeometry(String? string) {
  if (string == null || string.trim() == '') {
    return null;
  }
  List<String> values = string.split(",");
  return EdgeInsets.only(
      left: double.parse(values[0]),
      top: double.parse(values[1]),
      right: double.parse(values[2]),
      bottom: double.parse(values[3]));
}

CrossAxisAlignment? parseCrossAxisAlignment(String? string) =>
    _parseEnum(CrossAxisAlignment.values, string);

MainAxisAlignment? parseMainAxisAlignment(String? string) =>
    _parseEnum(MainAxisAlignment.values, string);

WrapAlignment? parseWrapAlignment(String? string) =>
    _parseEnum(WrapAlignment.values, string);

WrapCrossAlignment? parseWrapCrossAlignment(String? string) =>
    _parseEnum(WrapCrossAlignment.values, string);

MainAxisSize? parseMainAxisSize(String? string) =>
    _parseEnum(MainAxisSize.values, string);

VerticalDirection? parseVerticalDirection(String? string) =>
    _parseEnum(VerticalDirection.values, string);

BorderStyle? parseBorderStyle(String? string) =>
    _parseEnum(BorderStyle.values, string);

StrokeJoin? parseStrokeJoin(String? string) =>
    _parseEnum(StrokeJoin.values, string);

StrokeCap? parseStrokeCap(String? string) =>
    _parseEnum(StrokeCap.values, string);

///Up till this point all parsing should be 1 level. Directly parsing a string.

Radius? parseRadius(Map<String, dynamic>? map) {
  if (map == null) return null;
  double x = _toDouble(map["x"]) ?? 0.0;
  double y = _toDouble(map["y"]) ?? 0.0;
  return Radius.elliptical(x, y);
}

BorderRadius? parseBorderRadius(Map<String, dynamic>? map) {
  if (map == null) return null;
  Radius? topLeft = parseRadius(map["topLeft"]);
  Radius? topRight = parseRadius(map["topRight"]);
  Radius? bottomLeft = parseRadius(map["bottomLeft"]);
  Radius? bottomRight = parseRadius(map["bottomRight"]);
  return BorderRadius.only(
    topLeft: topLeft ?? Radius.zero,
    topRight: topRight ?? Radius.zero,
    bottomLeft: bottomLeft ?? Radius.zero,
    bottomRight: bottomRight ?? Radius.zero,
  );
}

Matrix4? parseMatrix4(dynamic list) {
  if (list == null) return null;
  List<double> storage = [
    for (dynamic value in list as List) (value as num).toDouble(),
  ];
  return Matrix4.fromList(storage);
}

SystemMouseCursor? parseSystemMouseCursor(String? string) =>
    systemMouseCursorsByName[string];

Offset? parseOffset(Map<String, dynamic>? map) {
  if (map == null) return null;
  double dx = _toDouble(map["dx"]) ?? 0.0;
  double dy = _toDouble(map["dy"]) ?? 0.0;
  return Offset(dx, dy);
}

Size? parseSize(Map<String, dynamic>? map) {
  if (map == null) return null;
  double width = _toDouble(map["width"]) ?? 0.0;
  double height = _toDouble(map["height"]) ?? 0.0;
  return Size(width, height);
}

Rect? parseRect(Map<String, dynamic>? map) {
  if (map == null) return null;
  double left = _toDouble(map["left"]) ?? 0.0;
  double right = _toDouble(map["right"]) ?? 0.0;
  double top = _toDouble(map["top"]) ?? 0.0;
  double bottom = _toDouble(map["bottom"]) ?? 0.0;
  return Rect.fromLTRB(left, top, right, bottom);
}

EdgeInsets? parseEdgeInsets(Map<String, dynamic>? map) {
  if (map == null) return null;
  double left = _toDouble(map["left"]) ?? 0.0;
  double right = _toDouble(map["right"]) ?? 0.0;
  double top = _toDouble(map["top"]) ?? 0.0;
  double bottom = _toDouble(map["bottom"]) ?? 0.0;
  return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}

ImageFilter? parseImageFilter(Map<String, dynamic>? map) {
  if (map == null) return null;
  if (map["type"] == "ImageFilter") {
    if (map.containsKey("sigmaX")) {
      double sigmaX = _toDouble(map["sigmaX"]) ?? 0;
      double sigmaY = _toDouble(map["sigmaY"]) ?? 0;
      //A blur created without a tile mode uses a platform specific default
      //since Flutter 3.29.
      if (map["tileMode"] == "unspecified") {
        return ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY);
      }
      return ImageFilter.blur(
          sigmaX: sigmaX,
          sigmaY: sigmaY,
          tileMode: parseTileMode(map["tileMode"]) ?? TileMode.clamp);
    }
  }
  if (map["type"] == "ColorFilter") {
    return parseColorFilter(map);
  }
  return null;
}

///Returns null for an empty map, which is what [ColorFilterToJsonExtension]
///returns for filters it can't serialize.
ColorFilter? parseColorFilter(Map<String, dynamic>? map) {
  if (map == null) return null;
  List? matrix = map["matrix"];
  if (matrix != null) {
    return ColorFilter.matrix(
        [for (dynamic value in matrix) (value as num).toDouble()]);
  }
  if (!map.containsKey("color") && !map.containsKey("mode")) return null;
  Color color = parseColor(map["color"]) ?? const Color(0x00000000);
  BlendMode mode = parseBlendMode(map["mode"]) ?? BlendMode.src;
  return ColorFilter.mode(color, mode);
}

//TODO: add more providers here
ImageProvider? parseImageProvider(Map<String, dynamic>? map) {
  if (map == null) return null;
  if (map["type"] == "NetworkImage") {
    return NetworkImage(map["url"], scale: _toDouble(map["scale"]) ?? 1.0);
  }
  if (map["type"] == "AssetImage") {
    return AssetImage(map["assetName"], package: map["package"]);
  }
  return null;
}

DecorationImage? parseDecorationImage(Map<String, dynamic>? map) {
  if (map == null) return null;
  ImageProvider? image = parseImageProvider(map["image"]);
  ColorFilter? colorFilter = parseColorFilter(map["colorFilter"]);
  BoxFit? fit = parseBoxFit(map["fit"]);
  Alignment alignment = parseAlignment(map["alignment"]) ?? Alignment.center;
  ImageRepeat repeat = parseImageRepeat(map["repeat"]) ?? ImageRepeat.noRepeat;
  double scale = _toDouble(map["scale"]) ?? 1.0;

  if (image == null) return null;
  return DecorationImage(
      image: image,
      fit: fit,
      alignment: alignment,
      colorFilter: colorFilter,
      repeat: repeat,
      scale: scale);
}

Shadow? parseShadow(Map<String, dynamic>? map) {
  if (map == null) return null;
  Color color = parseColor(map["color"]) ?? const Color(0x00000000);
  Offset offset = parseOffset(map["offset"]) ?? Offset.zero;
  double blurRadius = _toDouble(map["blurRadius"]) ?? 0.0;

  return Shadow(color: color, offset: offset, blurRadius: blurRadius);
}

///Missing values default to the defaults of the gradient constructors.
Gradient? parseGradient(Map<String, dynamic>? map) {
  if (map == null) return null;
  List<Color> colors = [
    for (dynamic color in map["colors"] as List)
      parseColor(color) ?? const Color(0xFFFFFFFF),
  ];
  List<double>? stops =
      (map["stops"] as List?)?.map((e) => (e as num).toDouble()).toList();
  TileMode tileMode = parseTileMode(map["tileMode"]) ?? TileMode.clamp;
  if (map["type"] == "RadialGradient") {
    Alignment center = parseAlignment(map["center"]) ?? Alignment.center;
    double radius = _toDouble(map["radius"]) ?? 0.5;
    return RadialGradient(
        center: center,
        radius: radius,
        colors: colors,
        stops: stops,
        tileMode: tileMode);
  } else if (map["type"] == "SweepGradient") {
    Alignment center = parseAlignment(map["center"]) ?? Alignment.center;
    double startAngle = _toDouble(map["startAngle"]) ?? 0.0;
    double endAngle = _toDouble(map["endAngle"]) ?? math.pi * 2;
    return SweepGradient(
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        colors: colors,
        stops: stops,
        tileMode: tileMode);
  } else {
    Alignment begin = parseAlignment(map["begin"]) ?? Alignment.centerLeft;
    Alignment end = parseAlignment(map["end"]) ?? Alignment.centerRight;
    return LinearGradient(
        begin: begin,
        end: end,
        colors: colors,
        stops: stops,
        tileMode: tileMode);
  }
}

BoxDecoration? parseBoxDecoration(Map<String, dynamic>? map) {
  if (map == null) return null;
  Color? color = parseColor(map["color"]);
  Gradient? gradient = parseGradient(map["gradient"]);
  DecorationImage? image = parseDecorationImage(map["image"]);
  return BoxDecoration(color: color, gradient: gradient, image: image);
}

///Parses the properties written by [TextStyleToJsonExtension]. A missing
///font style is parsed as [FontStyle.normal].
TextStyle? parseTextStyle(Map<String, dynamic>? map) {
  if (map == null) return null;
  Color? color = parseColor(map['color']);
  Color? backgroundColor = parseColor(map['backgroundColor']);
  String? fontFamily = map['fontFamily'];
  double? fontSize = _toDouble(map['fontSize']);
  FontStyle? fontStyle =
      'italic' == map['fontStyle'] ? FontStyle.italic : FontStyle.normal;
  FontWeight? fontWeight = parseFontWeight(map['fontWeight']);
  TextDecoration? decoration = parseTextDecoration(map['decoration']);
  Color? decorationColor = parseColor(map["decorationColor"]);
  TextDecorationStyle? decorationStyle =
      parseTextDecorationStyle(map['decorationStyle']);
  double? decorationThickness = _toDouble(map['decorationThickness']);
  double? height = _toDouble(map['height']);
  double? letterSpacing = _toDouble(map['letterSpacing']);
  double? wordSpacing = _toDouble(map['wordSpacing']);
  TextBaseline? textBaseline = parseTextBaseline(map['textBaseline']);

  return TextStyle(
    height: height,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    textBaseline: textBaseline,
    color: color,
    backgroundColor: backgroundColor,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontStyle: fontStyle,
    fontWeight: fontWeight,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
  );
}
