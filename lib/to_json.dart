import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_class_parser/parse_json.dart';

extension MapExtension<K, V> on Map<K, V> {
  void updateNotNull(K key, V value) {
    if (value != null) this[key] = value;
  }
}

extension ColorToJson on Color {
  String toJson() {
    return this.value.toRadixString(16);
  }
}

extension BlendModeToJson on BlendMode {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension TileModeToJson on TileMode {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension AlignmentToJson on Alignment {
  String toJson() {
    if (!this.toString().contains("(")) {
      return this.toString().stripFirstDot();
    } else {
      return this.toString().substring(9);
    }
  }
}

extension BoxFitToJson on BoxFit {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension ImageRepeatToJson on ImageRepeat {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension FilterQualityToJson on FilterQuality {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension StackFitToJson on StackFit {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension FontWeightToJson on FontWeight {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension FontStyleToJson on FontStyle {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension AxisToJson on Axis {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension AxisDirectionToJson on AxisDirection {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension TextOverflowToJson on TextOverflow {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension TextDecorationToJson on TextDecoration {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension TextDecorationStyleToJson on TextDecorationStyle {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension ClipToJson on Clip {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension CurveToJson on Curve {
  String toJson() {
    switch (this) {
      case Curves.linear:
        return "linear";
      case Curves.bounceIn:
        return "bounceIn";
      case Curves.bounceOut:
        return "bounceOut";
      case Curves.decelerate:
        return "decelerate";
      case Curves.ease:
        return "ease";
      case Curves.easeIn:
        return "easeIn";
      case Curves.bounceOut:
        return "easeOut";
      case Curves.elasticIn:
        return "elasticIn";
      case Curves.elasticInOut:
        return "elasticOut";
      default:
        return "";
    }
  }
}

extension TextAlignToJson on TextAlign {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension MainAxisAlignmentToJson on MainAxisAlignment {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension CrossAxisAlignmentToJson on CrossAxisAlignment {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension WrapAlignmentToJson on WrapAlignment {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension WrapCrossAlignmentToJson on WrapCrossAlignment {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension BorderStyleToJson on BorderStyle {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension OffsetToJsonExtension on Offset {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["dx"] = this.dx;
    rst["dy"] = this.dy;
    return rst;
  }
}

extension SizeToJsonExtension on Size {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["width"] = this.width;
    rst["height"] = this.height;
    return rst;
  }
}

extension RectToJsonExtension on Rect {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["left"] = this.left;
    rst["right"] = this.right;
    rst["top"] = this.top;
    rst["bottom"] = this.bottom;
    return rst;
  }
}

extension RadiusToJsonExtension on Radius {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["x"] = this.x;
    rst["y"] = this.y;
    return rst;
  }

  static Radius? fromJson(Map<String, dynamic> map) {
    return Radius.elliptical(
      map["x"],
      map["y"],
    );
  }
}

extension BorderRadiusToJsonExtension on BorderRadius {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["topLeft"] = this.topLeft.toJson();
    rst["topRight"] = this.topRight.toJson();
    rst["bottomLeft"] = this.bottomLeft.toJson();
    rst["bottomRight"] = this.bottomRight.toJson();
    return rst;
  }
}

extension GradientToJsonExtension on Gradient {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};

    rst.updateNotNull("stops", this.stops);
    rst.updateNotNull("colors", this.colors.map((e) => e.toJson()).toList());
    if (this is LinearGradient) {
      rst["type"] = "LinearGradient";
      rst.updateNotNull(
          "begin", ((this as LinearGradient).begin as Alignment).toJson());
      rst.updateNotNull(
          "end", ((this as LinearGradient).end as Alignment).toJson());
      rst.updateNotNull("tileMode", (this as LinearGradient).tileMode.toJson());
    } else if (this is RadialGradient) {
      rst["type"] = "RadialGradient";
      rst.updateNotNull(
          "center", ((this as RadialGradient).center as Alignment).toJson());
      rst.updateNotNull("radius", (this as RadialGradient).radius);
      rst.updateNotNull("tileMode", (this as RadialGradient).tileMode.toJson());
    } else if (this is SweepGradient) {
      rst["type"] = "SweepGradient";
      rst.updateNotNull(
          "center", ((this as SweepGradient).center as Alignment).toJson());
      rst.updateNotNull("startAngle", (this as SweepGradient).startAngle);
      rst.updateNotNull("endAngle", (this as SweepGradient).endAngle);
      rst.updateNotNull("tileMode", (this as SweepGradient).tileMode.toJson());
    }

    return rst;
  }
}

extension ColorFilterToJsonExtension on ColorFilter {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    String temp = this.toString();
    //assume color filter is in mode type
    List<String> filtermode =
        temp.substring(temp.indexOf("("), temp.lastIndexOf((")"))).split(",");
    String colorString = filtermode[0];
    colorString = colorString.substring(
        colorString.lastIndexOf("(0x") + 3, colorString.indexOf(")"));
    rst["color"] = colorString;
    rst["mode"] = filtermode[1].stripFirstDot();
    return rst;
  }
}

extension DecorationImageToJsonExtension on DecorationImage {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull("fit", this.fit?.toJson());
    rst.updateNotNull("alignment", (this.alignment as Alignment).toJson());
    rst.updateNotNull("colorFilter", this.colorFilter?.toJson());
    rst.updateNotNull("url", (this.image as NetworkImage).url);
    return rst;
  }
}

extension BoxDecorationToJsonExtension on BoxDecoration {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull("color", this.color?.toJson());
    rst.updateNotNull("gradient", this.gradient?.toJson());
    rst.updateNotNull("image", this.image?.toJson());
    return rst;
  }
}

extension TextStyleToJsonExtension on TextStyle {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull("fontFamily", this.fontFamily);
    rst.updateNotNull("color", this.color?.toJson());
    rst.updateNotNull("backgroundColor", this.backgroundColor?.toJson());
    rst.updateNotNull("fontWeight", this.fontWeight?.toJson());
    rst.updateNotNull("fontStyle", this.fontStyle?.toJson());
    rst.updateNotNull("decoration", this.decoration?.toJson());
    rst.updateNotNull("decorationColor", this.decorationColor?.toJson());
    rst.updateNotNull("decorationStyle", this.decorationStyle?.toJson());
    rst.updateNotNull("decorationThickness", this.decorationThickness);
    rst.updateNotNull("height", this.height);
    rst.updateNotNull("letterSpacing", this.letterSpacing);
    return rst;
  }
}
