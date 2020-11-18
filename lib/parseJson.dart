import 'package:flutter/material.dart';
import 'dart:convert';

//I can make parsing be extension methods on String and Map<String, dynamic>, but that would require

extension stringParsingExtension on String {
  String stripFirstDot() {
    int index = this.indexOf('.') + 1;
    index = index == 0 ? 0 : index;
    return this.substring(index);
  }
}

Color? parseColor(String? string) {
  if (string == null) return null;
  int colorInt = int.parse(string, radix: 16);
  return Color(colorInt);
}

BlendMode? parseBlendMode(String? string) {
  switch (string?.trim()) {
    case 'clear':
      return BlendMode.clear;
    case 'src':
      return BlendMode.src;
    case 'dst':
      return BlendMode.dst;
    case 'srcOver':
      return BlendMode.srcOver;
    case 'dstOver':
      return BlendMode.dstOver;
    case 'srcIn':
      return BlendMode.srcIn;
    case 'dstIn':
      return BlendMode.dstIn;
    case 'srcOut':
      return BlendMode.srcOut;
    case 'dstOut':
      return BlendMode.dstOut;
    case 'srcATop':
      return BlendMode.srcATop;
    case 'dstATop':
      return BlendMode.dstATop;
    case 'xor':
      return BlendMode.xor;
    case 'plus':
      return BlendMode.plus;
    case 'modulate':
      return BlendMode.modulate;
    case 'screen':
      return BlendMode.screen;
    case 'overlay':
      return BlendMode.overlay;
    case 'darken':
      return BlendMode.darken;
    case 'lighten':
      return BlendMode.lighten;
    case 'colorDodge':
      return BlendMode.colorDodge;
    case 'colorBurn':
      return BlendMode.colorBurn;
    case 'hardLight':
      return BlendMode.hardLight;
    case 'softLight':
      return BlendMode.softLight;
    case 'difference':
      return BlendMode.difference;
    case 'exclusion':
      return BlendMode.exclusion;
    case 'multiply':
      return BlendMode.multiply;
    case 'hue':
      return BlendMode.hue;
    case 'saturation':
      return BlendMode.saturation;
    case 'color':
      return BlendMode.color;
    case 'luminosity':
      return BlendMode.luminosity;

    default:
      return null;
  }
}

TileMode? parseTileMode(String? string) {
  switch (string) {
    case "clamp":
      return TileMode.clamp;
    case "mirror":
      return TileMode.mirror;
    case "repeated":
      return TileMode.repeated;
    default:
      return null;
  }
}

Alignment? parseAlignment(String? string) {
  Alignment? alignment;
  switch (string) {
    case 'topLeft':
      alignment = Alignment.topLeft;
      break;
    case 'topCenter':
      alignment = Alignment.topCenter;
      break;
    case 'topRight':
      alignment = Alignment.topRight;
      break;
    case 'centerLeft':
      alignment = Alignment.centerLeft;
      break;
    case 'center':
      alignment = Alignment.center;
      break;
    case 'centerRight':
      alignment = Alignment.centerRight;
      break;
    case 'bottomLeft':
      alignment = Alignment.bottomLeft;
      break;
    case 'bottomCenter':
      alignment = Alignment.bottomCenter;
      break;
    case 'bottomRight':
      alignment = Alignment.bottomRight;
      break;

    default:
      {
        if (string != null) {
          List<String> aligns = string
              .substring(string.indexOf("("), string.indexOf(")"))
              .split(",");
          alignment =
              Alignment(double.parse(aligns[0]), double.parse(aligns[1]));
        }
      }
      break;
  }
  return alignment;
}

BoxFit? parseBoxFit(String? string) {
  switch (string) {
    case 'fill':
      return BoxFit.fill;
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fitWidth':
      return BoxFit.fitWidth;
    case 'fitHeight':
      return BoxFit.fitHeight;
    case 'none':
      return BoxFit.none;
    case 'scaleDown':
      return BoxFit.scaleDown;
    default:
      return null;
  }
}

ImageRepeat? parseImageRepeat(String? string) {
  switch (string) {
    case 'repeat':
      return ImageRepeat.repeat;
    case 'repeatX':
      return ImageRepeat.repeatX;
    case 'repeatY':
      return ImageRepeat.repeatY;
    case 'noRepeat':
      return ImageRepeat.noRepeat;
    default:
      return null;
  }
}

FilterQuality? parseFilterQuality(String? string) {
  switch (string) {
    case 'none':
      return FilterQuality.none;
    case 'low':
      return FilterQuality.low;
    case 'medium':
      return FilterQuality.medium;
    case 'high':
      return FilterQuality.high;
    default:
      return null;
  }
}

StackFit? parseStackFit(String? string) {
  switch (string) {
    case 'loose':
      return StackFit.loose;
    case 'expand':
      return StackFit.expand;
    case 'passthrough':
      return StackFit.passthrough;
    default:
      return null;
  }
}

Axis? parseAxis(String? string) {
  switch (string) {
    case "horizontal":
      return Axis.horizontal;
    case "vertical":
      return Axis.vertical;
  }
  return null;
}

TextDecoration? parseTextDecoration(String? string) {
  switch (string) {
    case "none":
      return TextDecoration.none;
    case "underline":
      return TextDecoration.underline;
    case "lineThrough":
      return TextDecoration.lineThrough;
    case "overline":
      return TextDecoration.overline;
    default:
      return null;
  }
}

TextDecorationStyle? parseTextDecorationStyle(String? string) {
  switch (string) {
    case "solid":
      return TextDecorationStyle.solid;
    case "double":
      return TextDecorationStyle.double;
    case "dotted":
      return TextDecorationStyle.dotted;
    case "dashed":
      return TextDecorationStyle.dashed;
    case "wavy":
      return TextDecorationStyle.wavy;
    default:
      return null;
  }
}

Clip? parseClipBehavior(String? string) {
  switch (string) {
    case "antiAlias":
      return Clip.antiAlias;
    case "none":
      return Clip.none;
    case "hardEdge":
      return Clip.hardEdge;
    case "antiAliasWithSaveLayer":
      return Clip.antiAliasWithSaveLayer;
    default:
      return null;
  }
}

Curve? parseCurve(String? string) {
  switch (string) {
    case "linear":
      return Curves.linear;
    case "bounceIn":
      return Curves.bounceIn;
    case "bounceOut":
      return Curves.bounceOut;
    case "decelerate":
      return Curves.decelerate;
    case "ease":
      return Curves.ease;
    case "easeIn":
      return Curves.easeIn;
    case "easeOut":
      return Curves.easeOut;
    case "elasticIn":
      return Curves.elasticIn;
    case "elasticOut":
      return Curves.elasticOut;
    default:
      return null;
  }
}

TextOverflow? parseTextOverflow(String? string) {
  TextOverflow? textOverflow;
  switch (string) {
    case "ellipsis":
      textOverflow = TextOverflow.ellipsis;
      break;
    case "clip":
      textOverflow = TextOverflow.clip;
      break;
    case "fade":
      textOverflow = TextOverflow.fade;
      break;
  }
  return textOverflow;
}

TextDirection? parseTextDirection(String? string) {
  TextDirection textDirection = TextDirection.ltr;
  switch (string) {
    case 'ltr':
      textDirection = TextDirection.ltr;
      break;
    case 'rtl':
      textDirection = TextDirection.rtl;
      break;
    default:
      textDirection = TextDirection.ltr;
  }
  return textDirection;
}

EdgeInsetsGeometry? parseEdgeInsetsGeometry(String? string) {
  //left,top,right,bottom
  if (string == null || string.trim() == '') {
    return null;
  }
  var values = string.split(",");
  return EdgeInsets.only(
      left: double.parse(values[0]),
      top: double.parse(values[1]),
      right: double.parse(values[2]),
      bottom: double.parse(values[3]));
}

CrossAxisAlignment? parseCrossAxisAlignment(String? crossAxisAlignmentString) {
  if (crossAxisAlignmentString == null) return null;
  //crossAxisAlignmentString = crossAxisAlignmentString.substring(18);

  switch (crossAxisAlignmentString) {
    case 'start':
      return CrossAxisAlignment.start;
    case 'end':
      return CrossAxisAlignment.end;
    case 'center':
      return CrossAxisAlignment.center;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    case 'baseline':
      return CrossAxisAlignment.baseline;
  }
  return CrossAxisAlignment.center;
}

MainAxisAlignment? parseMainAxisAlignment(String? mainAxisAlignmentString) {
  if (mainAxisAlignmentString == null) return null;
  //mainAxisAlignmentString = mainAxisAlignmentString.substring(17);

  switch (mainAxisAlignmentString) {
    case 'start':
      return MainAxisAlignment.start;
    case 'end':
      return MainAxisAlignment.end;
    case 'center':
      return MainAxisAlignment.center;
    case 'spaceBetween':
      return MainAxisAlignment.spaceBetween;
    case 'spaceAround':
      return MainAxisAlignment.spaceAround;
    case 'spaceEvenly':
      return MainAxisAlignment.spaceEvenly;
  }
  return MainAxisAlignment.start;
}

WrapAlignment? parseWrapAlignment(String? wrapAlignmentString) {
  if (wrapAlignmentString == null) return null;
  //wrapAlignmentString = wrapAlignmentString.substring(14);

  switch (wrapAlignmentString) {
    case 'start':
      return WrapAlignment.start;
    case 'end':
      return WrapAlignment.end;
    case 'center':
      return WrapAlignment.center;
    case 'spaceBetween':
      return WrapAlignment.spaceBetween;
    case 'spaceAround':
      return WrapAlignment.spaceAround;
    case 'spaceEvenly':
      return WrapAlignment.spaceEvenly;
  }
  return WrapAlignment.start;
}

WrapCrossAlignment? parseWrapCrossAlignment(String? wrapCrossAlignmentString) {
  if (wrapCrossAlignmentString == null) return null;

  //wrapCrossAlignmentString = wrapCrossAlignmentString.substring(19);

  switch (wrapCrossAlignmentString) {
    case 'start':
      return WrapCrossAlignment.start;
    case 'end':
      return WrapCrossAlignment.end;
    case 'center':
      return WrapCrossAlignment.center;
  }
  return WrapCrossAlignment.start;
}

TextAlign? parseTextAlign(String? string) {
  if (string == null) return null;
  switch (string) {
    case 'left':
      return TextAlign.left;
    case 'right':
      return TextAlign.right;
    case 'center':
      return TextAlign.center;
    case 'justify':
      return TextAlign.justify;
    case 'start':
      return TextAlign.start;
    case 'end':
      return TextAlign.end;
    default:
      return null;
  }
}

MainAxisSize? parseMainAxisSize(String? mainAxisSizeString) =>
    mainAxisSizeString == 'min' ? MainAxisSize.min : MainAxisSize.max;

TextBaseline? parseTextBaseline(String? parseTextBaselineString) =>
    'alphabetic' == parseTextBaselineString
        ? TextBaseline.alphabetic
        : TextBaseline.ideographic;

VerticalDirection? parseVerticalDirection(String? verticalDirectionString) =>
    'up' == verticalDirectionString
        ? VerticalDirection.up
        : VerticalDirection.down;

//Up till this point all parsing should be 1 level. Directly parsing a string.

ColorFilter? parseColorFilter(Map<String, dynamic>? map) {
  if (map == null) return null;
  Color color = parseColor(map["color"]) ?? Colors.white;
  BlendMode mode = parseBlendMode(map["mode"]) ?? BlendMode.clear;
  return ColorFilter.mode(color, mode);
}

DecorationImage? parseDecorationImage(Map<String, dynamic>? map) {
  if (map == null) return null;
  String url = map["url"];
  ColorFilter? colorFilter = parseColorFilter(map["colorFilter"]);
  BoxFit? fit = parseBoxFit(map["fit"]);
  Alignment alignment = parseAlignment(map["alignment"]) ?? Alignment.topLeft;
  return DecorationImage(
      image: NetworkImage(url),
      fit: fit,
      alignment: alignment,
      colorFilter: colorFilter);
}

Gradient? parseGradient(Map<String, dynamic>? map) {
  if (map == null) return null;
  List<Color> colors = (map["colors"] as List)
      .map((e) => parseColor(e) ?? Colors.white)
      .toList();
  List<double>? stops = map["stops"]?.cast<double>();
  TileMode tileMode = parseTileMode(map["tileMode"]) ?? TileMode.clamp;
  if (map.containsKey("radius")) {
    Alignment center = parseAlignment(map["center"]) ?? Alignment.center;
    double radius = map["radius"];
    return RadialGradient(
        center: center,
        radius: radius,
        colors: colors,
        stops: stops,
        tileMode: tileMode);
  } else if (map.containsKey("startAngle")) {
    Alignment center = parseAlignment(map["center"]) ?? Alignment.center;
    double startAngle = map["startAngle"];
    double endAngle = map["endAngle"];
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

TextStyle? parseTextStyle(Map<String, dynamic>? map) {
  if (map == null) return null;
  //TODO: more properties need to be implemented, such as decoration, decorationColor, decorationStyle, wordSpacing and so on.
  Color? color = parseColor(map['color']);
  Color? backgroundColor = parseColor(map['backgroundColor']);
  String? fontFamily = map['fontFamily'];
  //double fontSize = map['fontSize'];
  FontStyle? fontStyle =
      'italic' == map['fontStyle'] ? FontStyle.italic : FontStyle.normal;
  FontWeight? fontWeight =
      'w700' == map['fontWeight'] ? FontWeight.bold : FontWeight.normal;
  TextDecoration? decoration = parseTextDecoration(map['decoration']);
  Color? decorationColor = parseColor(map["decorationColor"]);
  TextDecorationStyle? decorationStyle =
      parseTextDecorationStyle(map['decorationStyle']);
  double? decorationThickness = map['decorationThickness'];
  double? height = map['height'];
  double? letterSpacing = map['letterSpacing'];

  return TextStyle(
    height: height,
    letterSpacing: letterSpacing,
    color: color,
    backgroundColor: backgroundColor,
    //fontSize: fontSize,
    fontFamily: fontFamily,
    fontStyle: fontStyle,
    fontWeight: fontWeight,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
  );
}
