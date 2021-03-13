import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

extension TextDirectionToJson on TextDirection {
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
      case Curves.decelerate:
        return "decelerate";
      case Curves.fastLinearToSlowEaseIn:
        return "fastLinearToSlowEaseIn";
      case Curves.ease:
        return "ease";
      case Curves.easeIn:
        return "easeIn";
      case Curves.easeInToLinear:
        return "easeInToLinear";
      case Curves.easeInSine:
        return "easeInSine";
      case Curves.easeInQuad:
        return "easeInQuad";
      case Curves.easeInCubic:
        return "easeInCubic";
      case Curves.easeInQuart:
        return "easeInQuart";
      case Curves.easeInQuint:
        return "easeInQuint";
      case Curves.easeInExpo:
        return "easeInExpo";
      case Curves.easeInCirc:
        return "easeInCirc";
      case Curves.easeInBack:
        return "easeInBack";
      case Curves.easeOut:
        return "easeOut";
      case Curves.linearToEaseOut:
        return "linearToEaseOut";
      case Curves.easeOutSine:
        return "easeOutSine";
      case Curves.easeOutQuad:
        return "easeOutQuad";
      case Curves.easeOutCubic:
        return "easeOutCubic";
      case Curves.easeOutQuart:
        return "easeOutQuart";
      case Curves.easeOutQuint:
        return "easeOutQuint";
      case Curves.easeOutExpo:
        return "easeOutExpo";
      case Curves.easeOutCirc:
        return "easeOutCirc";
      case Curves.easeOutBack:
        return "easeOutBack";
      case Curves.easeInOut:
        return "easeInOut";
      case Curves.easeInOutSine:
        return "easeInOutSine";
      case Curves.easeInOutQuad:
        return "easeInOutQuad";
      case Curves.easeInOutCubic:
        return "easeInOutCubic";
      case Curves.easeInOutQuart:
        return "easeInOutQuart";
      case Curves.easeInOutQuint:
        return "easeInOutQuint";
      case Curves.easeInOutExpo:
        return "easeInOutExpo";
      case Curves.easeInOutCirc:
        return "easeInOutCirc";
      case Curves.easeInOutBack:
        return "easeInOutBack";
      case Curves.fastOutSlowIn:
        return "fastOutSlowIn";
      case Curves.slowMiddle:
        return "slowMiddle";
      case Curves.bounceIn:
        return "bounceIn";
      case Curves.bounceOut:
        return "bounceOut";
      case Curves.bounceInOut:
        return "bounceInOut";
      case Curves.elasticIn:
        return "elasticIn";
      case Curves.elasticOut:
        return "elasticOut";
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

extension MainAxisSizeToJson on MainAxisSize {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension TextBaselineToJson on TextBaseline {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension VerticalDirectionToJson on VerticalDirection {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension BorderStyleToJson on BorderStyle {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension Matrix4ToJson on Matrix4 {
  List<double> toJson() {
    return this.storage.toList();
  }
}

extension SystemMouseCursorsToJson on SystemMouseCursor {
  String toJson() {
    if (this == SystemMouseCursors.basic) {
      return "basic";
    } else if (this == SystemMouseCursors.click) {
      return "click";
    } else if (this == SystemMouseCursors.none) {
      return "none";
    } else if (this == SystemMouseCursors.forbidden) {
      return "forbidden";
    } else if (this == SystemMouseCursors.wait) {
      return "wait";
    } else if (this == SystemMouseCursors.progress) {
      return "progress";
    } else if (this == SystemMouseCursors.contextMenu) {
      return "contextMenu";
    } else if (this == SystemMouseCursors.help) {
      return "help";
    } else if (this == SystemMouseCursors.text) {
      return "text";
    } else if (this == SystemMouseCursors.verticalText) {
      return "verticalText";
    } else if (this == SystemMouseCursors.cell) {
      return "cell";
    } else if (this == SystemMouseCursors.precise) {
      return "precise";
    } else if (this == SystemMouseCursors.move) {
      return "move";
    } else if (this == SystemMouseCursors.grab) {
      return "grab";
    } else if (this == SystemMouseCursors.grabbing) {
      return "grabbing";
    } else if (this == SystemMouseCursors.noDrop) {
      return "noDrop";
    } else if (this == SystemMouseCursors.alias) {
      return "alias";
    } else if (this == SystemMouseCursors.copy) {
      return "copy";
    } else if (this == SystemMouseCursors.disappearing) {
      return "disappearing";
    } else if (this == SystemMouseCursors.allScroll) {
      return "allScroll";
    } else if (this == SystemMouseCursors.resizeLeftRight) {
      return "resizeLeftRight";
    } else if (this == SystemMouseCursors.resizeUpDown) {
      return "resizeUpDown";
    } else if (this == SystemMouseCursors.resizeUpLeftDownRight) {
      return "resizeUpLeftDownRight";
    } else if (this == SystemMouseCursors.resizeUpRightDownLeft) {
      return "resizeUpRightDownLeft";
    } else if (this == SystemMouseCursors.resizeUp) {
      return "resizeUp";
    } else if (this == SystemMouseCursors.resizeDown) {
      return "resizeDown";
    } else if (this == SystemMouseCursors.resizeLeft) {
      return "resizeLeft";
    } else if (this == SystemMouseCursors.resizeRight) {
      return "resizeRight";
    } else if (this == SystemMouseCursors.resizeUpLeft) {
      return "resizeUpLeft";
    } else if (this == SystemMouseCursors.resizeUpRight) {
      return "resizeUpRight";
    } else if (this == SystemMouseCursors.resizeDownLeft) {
      return "resizeDownLeft";
    } else if (this == SystemMouseCursors.resizeDownRight) {
      return "resizeDownRight";
    } else if (this == SystemMouseCursors.resizeColumn) {
      return "resizeColumn";
    } else if (this == SystemMouseCursors.resizeRow) {
      return "resizeRow";
    } else if (this == SystemMouseCursors.zoomIn) {
      return "zoomIn";
    } else if (this == SystemMouseCursors.zoomOut) {
      return "zoomOut";
    } else {
      return "";
    }
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
    //can not get _matrix, only parse the mode type
    if (temp.contains("mode")) {
      List<String> filtermode =
          temp.substring(temp.indexOf("("), temp.lastIndexOf((")"))).split(",");
      String colorString = filtermode[0];
      colorString = colorString.substring(
          colorString.lastIndexOf("(0x") + 3, colorString.indexOf(")"));
      rst["color"] = colorString;
      rst["mode"] = filtermode[1].stripFirstDot();
    }

    return rst;
  }
}

extension ImageProviderToJsonExtension on ImageProvider {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    if (this is NetworkImage) {
      rst["type"] = "NetworkImage";
      rst["url"] = (this as NetworkImage).url;
      rst["scale"] = (this as NetworkImage).scale;
    }
    if (this is AssetImage) {
      rst["type"] = "AssetImage";
      rst["assetName"] = (this as AssetImage).assetName;
      rst["package"] = (this as AssetImage).package;
    }
    return rst;
  }
}

extension DecorationImageToJsonExtension on DecorationImage {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull("image", this.image.toJson());
    rst.updateNotNull("colorFilter", this.colorFilter?.toJson());
    rst.updateNotNull("fit", this.fit?.toJson());
    rst.updateNotNull("alignment", (this.alignment as Alignment).toJson());
    rst.updateNotNull("repeat", this.repeat.toJson());
    rst.updateNotNull("scale", scale);

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
    rst.updateNotNull("color", this.color?.toJson());
    rst.updateNotNull("backgroundColor", this.backgroundColor?.toJson());
    rst.updateNotNull("fontSize", this.fontSize);
    rst.updateNotNull("fontWeight", this.fontWeight?.toJson());
    rst.updateNotNull("fontStyle", this.fontStyle?.toJson());
    rst.updateNotNull("letterSpacing", this.letterSpacing);
    rst.updateNotNull("wordSpacing", this.wordSpacing);
    rst.updateNotNull("textBaseline", this.textBaseline?.toJson());
    rst.updateNotNull("height", this.height);
    rst.updateNotNull("decoration", this.decoration?.toJson());
    rst.updateNotNull("decorationColor", this.decorationColor?.toJson());
    rst.updateNotNull("decorationStyle", this.decorationStyle?.toJson());
    rst.updateNotNull("decorationThickness", this.decorationThickness);
    rst.updateNotNull("fontFamily", this.fontFamily);

    return rst;
  }
}
