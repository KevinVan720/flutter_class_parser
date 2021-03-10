import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'to_json.dart';

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
  int colorInt = int.tryParse(string, radix: 16) ?? 0xFFFFFFFF;
  return Color(colorInt);
}

BlendMode? parseBlendMode(String? string) {
  BlendMode? rst;
  BlendMode.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

TileMode? parseTileMode(String? string) {
  TileMode? rst;
  TileMode.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

///not an enum
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
              .substring(string.indexOf("(") + 1, string.indexOf(")"))
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
  BoxFit? rst;
  BoxFit.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

ImageRepeat? parseImageRepeat(String? string) {
  ImageRepeat? rst;
  ImageRepeat.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

FilterQuality? parseFilterQuality(String? string) {
  FilterQuality? rst;
  FilterQuality.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

StackFit? parseStackFit(String? string) {
  StackFit? rst;
  StackFit.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

Axis? parseAxis(String? string) {
  Axis? rst;
  Axis.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

AxisDirection? parseAxisDirection(String? string) {
  AxisDirection? rst;
  AxisDirection.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

///not an enum
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
  TextDecorationStyle? rst;
  TextDecorationStyle.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

Clip? parseClip(String? string) {
  Clip? rst;
  Clip.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

Curve? parseCurve(String? string) {
  switch (string) {
    case "linear":
      return Curves.linear;
    case "decelerate":
      return Curves.decelerate;
    case "fastLinearToSlowEaseIn":
      return Curves.fastLinearToSlowEaseIn;
    case "ease":
      return Curves.ease;
    case "easeIn":
      return Curves.easeIn;
    case "easeInToLinear":
      return Curves.easeInToLinear;
    case "easeInSine":
      return Curves.easeInSine;
    case "easeInQuad":
      return Curves.easeInQuad;
    case "easeInCubic":
      return Curves.easeInCubic;
    case "easeInQuart":
      return Curves.easeInQuart;
    case "easeInQuint":
      return Curves.easeInQuint;
    case "easeInExpo":
      return Curves.easeInExpo;
    case "easeInCirc":
      return Curves.easeInCirc;
    case "easeInBack":
      return Curves.easeInBack;
    case "easeOut":
      return Curves.easeOut;
    case "linearToEaseOut":
      return Curves.linearToEaseOut;
    case "easeOutSine":
      return Curves.easeOutSine;
    case "easeOutQuad":
      return Curves.easeOutQuad;
    case "easeOutCubic":
      return Curves.easeOutCubic;
    case "easeOutQuart":
      return Curves.easeOutQuart;
    case "easeOutQuint":
      return Curves.easeOutQuint;
    case "easeOutExpo":
      return Curves.easeOutExpo;
    case "easeOutCirc":
      return Curves.easeOutCirc;
    case "easeOutBack":
      return Curves.easeOutBack;
    case "easeInOut":
      return Curves.easeInOut;
    case "easeInOutSine":
      return Curves.easeInOutSine;
    case "easeInOutQuad":
      return Curves.easeInOutQuad;
    case "easeInOutCubic":
      return Curves.easeInOutCubic;
    case "easeInOutQuart":
      return Curves.easeInOutQuart;
    case "easeInOutQuint":
      return Curves.easeInOutQuint;
    case "easeInOutExpo":
      return Curves.easeInOutExpo;
    case "easeInOutCirc":
      return Curves.easeInOutCirc;
    case "easeInOutBack":
      return Curves.easeInOutBack;
    case "fastOutSlowIn":
      return Curves.fastOutSlowIn;
    case "slowMiddle":
      return Curves.slowMiddle;
    case "bounceIn":
      return Curves.bounceIn;
    case "bounceOut":
      return Curves.bounceOut;
    case "bounceInOut":
      return Curves.bounceInOut;
    case "elasticIn":
      return Curves.elasticIn;
    case "elasticOut":
      return Curves.elasticOut;
    case "elasticOut":
      return Curves.elasticInOut;
    default:
      return null;
  }
}

TextOverflow? parseTextOverflow(String? string) {
  TextOverflow? rst;
  TextOverflow.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

TextDirection? parseTextDirection(String? string) {
  TextDirection? rst;
  TextDirection.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

TextAlign? parseTextAlign(String? string) {
  TextAlign? rst;
  TextAlign.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

TextBaseline? parseTextBaseline(String? string) {
  TextBaseline? rst;
  TextBaseline.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

///sorta like an enum
FontWeight? parseFontWeight(String? string) {
  FontWeight? rst;
  FontWeight.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

EdgeInsetsGeometry? parseEdgeInsetsGeometry(String? string) {
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

CrossAxisAlignment? parseCrossAxisAlignment(String? string) {
  CrossAxisAlignment? rst;
  CrossAxisAlignment.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

MainAxisAlignment? parseMainAxisAlignment(String? string) {
  MainAxisAlignment? rst;
  MainAxisAlignment.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

WrapAlignment? parseWrapAlignment(String? string) {
  WrapAlignment? rst;
  WrapAlignment.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

WrapCrossAlignment? parseWrapCrossAlignment(String? string) {
  WrapCrossAlignment? rst;
  WrapCrossAlignment.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

MainAxisSize? parseMainAxisSize(String? string) {
  MainAxisSize? rst;
  MainAxisSize.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

VerticalDirection? parseVerticalDirection(String? string) {
  VerticalDirection? rst;
  VerticalDirection.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

BorderStyle? parseBorderStyle(String? string) {
  BorderStyle? rst;
  BorderStyle.values.forEach((element) {
    if (string == element.toJson()) {
      rst = element;
    }
  });
  return rst;
}

///Up till this point all parsing should be 1 level. Directly parsing a string.

Radius? parseRadius(Map<String, dynamic>? map) {
  if (map == null) return null;
  double x = map["x"].toDouble();
  double y = map["y"].toDouble();
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

Matrix4? parseMatrix4(dynamic? list) {
  if (list == null) return null;
  List<double> storage = (list as List).cast<double>();
  return Matrix4.fromList(storage);
}

SystemMouseCursor? parseSystemMouseCursor(String? string) {
  if (string == "basic") {
    return SystemMouseCursors.basic;
  } else if (string == "click") {
    return SystemMouseCursors.click;
  } else if (string == "none") {
    return SystemMouseCursors.none;
  } else if (string == "forbidden") {
    return SystemMouseCursors.forbidden;
  } else if (string == "wait") {
    return SystemMouseCursors.wait;
  } else if (string == "progress") {
    return SystemMouseCursors.progress;
  } else if (string == "contextMenu") {
    return SystemMouseCursors.contextMenu;
  } else if (string == "help") {
    return SystemMouseCursors.help;
  } else if (string == "text") {
    return SystemMouseCursors.text;
  } else if (string == "verticalText") {
    return SystemMouseCursors.verticalText;
  } else if (string == "cell") {
    return SystemMouseCursors.cell;
  } else if (string == "precise") {
    return SystemMouseCursors.precise;
  } else if (string == "move") {
    return SystemMouseCursors.move;
  } else if (string == "grab") {
    return SystemMouseCursors.grab;
  } else if (string == "grabbing") {
    return SystemMouseCursors.grabbing;
  } else if (string == "noDrop") {
    return SystemMouseCursors.noDrop;
  } else if (string == "alias") {
    return SystemMouseCursors.alias;
  } else if (string == "copy") {
    return SystemMouseCursors.copy;
  } else if (string == "disappearing") {
    return SystemMouseCursors.disappearing;
  } else if (string == "allScroll") {
    return SystemMouseCursors.allScroll;
  } else if (string == "resizeLeftRight") {
    return SystemMouseCursors.resizeLeftRight;
  } else if (string == "resizeUpDown") {
    return SystemMouseCursors.resizeUpDown;
  } else if (string == "resizeUpLeftDownRight") {
    return SystemMouseCursors.resizeUpLeftDownRight;
  } else if (string == "resizeUpRightDownLeft") {
    return SystemMouseCursors.resizeUpRightDownLeft;
  } else if (string == "resizeUp") {
    return SystemMouseCursors.resizeUp;
  } else if (string == "resizeDown") {
    return SystemMouseCursors.resizeDown;
  } else if (string == "resizeLeft") {
    return SystemMouseCursors.resizeLeft;
  } else if (string == "resizeRight") {
    return SystemMouseCursors.resizeRight;
  } else if (string == "resizeUpLeft") {
    return SystemMouseCursors.resizeUpLeft;
  } else if (string == "resizeUpRight") {
    return SystemMouseCursors.resizeUpRight;
  } else if (string == "resizeDownLeft") {
    return SystemMouseCursors.resizeDownLeft;
  } else if (string == "resizeDownRight") {
    return SystemMouseCursors.resizeDownRight;
  } else if (string == "resizeColumn") {
    return SystemMouseCursors.resizeColumn;
  } else if (string == "resizeRow") {
    return SystemMouseCursors.resizeRow;
  } else if (string == "zoomIn") {
    return SystemMouseCursors.zoomIn;
  } else if (string == "zoomOut") {
    return SystemMouseCursors.zoomOut;
  } else {
    return null;
  }
}

Offset? parseOffset(Map<String, dynamic>? map) {
  if (map == null) return null;
  double dx = map["dx"].toDouble();
  double dy = map["dy"].toDouble();
  return Offset(dx, dy);
}

Size? parseSize(Map<String, dynamic>? map) {
  if (map == null) return null;
  double width = map["width"].toDouble();
  double height = map["height"].toDouble();
  return Size(width, height);
}

Rect? parseRect(Map<String, dynamic>? map) {
  if (map == null) return null;
  double left = map["left"].toDouble();
  double right = map["right"].toDouble();
  double top = map["top"].toDouble();
  double bottom = map["bottom"].toDouble();
  return Rect.fromLTRB(left, top, right, bottom);
}

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
  if (map["type"] == "RadialGradient") {
    Alignment center = parseAlignment(map["center"]) ?? Alignment.center;
    double radius = map["radius"].toDouble();
    return RadialGradient(
        center: center,
        radius: radius,
        colors: colors,
        stops: stops,
        tileMode: tileMode);
  } else if (map["type"] == "SweepGradient") {
    Alignment center = parseAlignment(map["center"]) ?? Alignment.center;
    double startAngle = map["startAngle"].toDouble();
    double endAngle = map["endAngle"].toDouble();
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
  double fontSize = map['fontSize'].toDouble();
  FontStyle? fontStyle =
      'italic' == map['fontStyle'] ? FontStyle.italic : FontStyle.normal;
  FontWeight? fontWeight = parseFontWeight(map['fontWeight']);
  TextDecoration? decoration = parseTextDecoration(map['decoration']);
  Color? decorationColor = parseColor(map["decorationColor"]);
  TextDecorationStyle? decorationStyle =
      parseTextDecorationStyle(map['decorationStyle']);
  double? decorationThickness = map['decorationThickness'].toDouble();
  double? height = map['height'].toDouble();
  double? letterSpacing = map['letterSpacing'].toDouble();

  return TextStyle(
    height: height,
    letterSpacing: letterSpacing,
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
