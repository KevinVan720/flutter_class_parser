import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'named_values.dart';
import 'parse_json.dart';

///Convert various built-in UI data classes to string or a map
///Methods are all called toJson() for simplification

///If a parameter is null, don't convert it in the json
///This saves space. But the corresponding parser should handle null values correctly
extension MapToJsonTypeExtension<K, V> on Map<K, V> {
  dynamic toJson() {
    return this;
  }

  void updateNotNull(K key, V value) {
    if (value != null) this[key] = value;
  }
}

extension ColorToJson on Color {
  String toJson() {
    return toARGB32().toRadixString(16);
  }
}

extension OrientationToJson on Orientation {
  String toJson() => name;
}

extension BlendModeToJson on BlendMode {
  String toJson() => name;
}

extension TileModeToJson on TileMode {
  String toJson() => name;
}

extension AlignmentToJson on Alignment {
  ///The predefined alignments are serialized by name, for example "topLeft",
  ///others as "(x, y)", for example "(0.1, 0.2)".
  String toJson() {
    return switch ((x, y)) {
      (-1.0, -1.0) => "topLeft",
      (0.0, -1.0) => "topCenter",
      (1.0, -1.0) => "topRight",
      (-1.0, 0.0) => "centerLeft",
      (0.0, 0.0) => "center",
      (1.0, 0.0) => "centerRight",
      (-1.0, 1.0) => "bottomLeft",
      (0.0, 1.0) => "bottomCenter",
      (1.0, 1.0) => "bottomRight",
      _ => "(${_alignmentComponentToJson(x)}, ${_alignmentComponentToJson(y)})",
    };
  }
}

///Formats a value with one decimal like [Alignment.toString] does, so the
///output stays the same as in older versions, unless that would lose
///precision.
String _alignmentComponentToJson(double value) {
  String fixed = value.toStringAsFixed(1);
  return double.parse(fixed) == value ? fixed : value.toString();
}

extension BoxFitToJson on BoxFit {
  String toJson() => name;
}

extension ImageRepeatToJson on ImageRepeat {
  String toJson() => name;
}

extension FilterQualityToJson on FilterQuality {
  String toJson() => name;
}

extension StackFitToJson on StackFit {
  String toJson() => name;
}

extension FontWeightToJson on FontWeight {
  ///The predefined weights are serialized as "w100" to "w900", other
  ///weights (supported by variable fonts) as for example "FontWeight(450)".
  ///Like [FontWeight.toString], FontWeight(1000) is serialized as "w900".
  String toJson() {
    if (value % 100 != 0) return "FontWeight($value)";
    return "w${(value ~/ 100).clamp(1, 9) * 100}";
  }
}

extension FontStyleToJson on FontStyle {
  String toJson() => name;
}

extension AxisToJson on Axis {
  String toJson() => name;
}

extension AxisDirectionToJson on AxisDirection {
  String toJson() => name;
}

extension TextOverflowToJson on TextOverflow {
  String toJson() => name;
}

extension TextDecorationToJson on TextDecoration {
  ///A single decoration is serialized by name, for example "underline",
  ///a combined one as for example "combine([underline, lineThrough])".
  String toJson() {
    List<String> names = [
      for (MapEntry<String, TextDecoration> entry
          in textDecorationsByName.entries)
        if (contains(entry.value)) entry.key,
    ];
    if (names.isEmpty) return "none";
    if (names.length == 1) return names.single;
    return "combine([${names.join(", ")}])";
  }
}

extension TextDirectionToJson on TextDirection {
  String toJson() => name;
}

extension TextDecorationStyleToJson on TextDecorationStyle {
  String toJson() => name;
}

extension ClipToJson on Clip {
  String toJson() => name;
}

extension CurveToJson on Curve {
  ///Only the predefined [Curves] are supported, other curves are serialized
  ///as an empty string.
  String toJson() {
    for (MapEntry<String, Curve> entry in curvesByName.entries) {
      if (entry.value == this) return entry.key;
    }
    return "";
  }
}

extension TextAlignToJson on TextAlign {
  String toJson() => name;
}

extension MainAxisAlignmentToJson on MainAxisAlignment {
  String toJson() => name;
}

extension CrossAxisAlignmentToJson on CrossAxisAlignment {
  String toJson() => name;
}

extension WrapAlignmentToJson on WrapAlignment {
  String toJson() => name;
}

extension WrapCrossAlignmentToJson on WrapCrossAlignment {
  String toJson() => name;
}

extension MainAxisSizeToJson on MainAxisSize {
  String toJson() => name;
}

extension TextBaselineToJson on TextBaseline {
  String toJson() => name;
}

extension VerticalDirectionToJson on VerticalDirection {
  String toJson() => name;
}

extension BorderStyleToJson on BorderStyle {
  String toJson() => name;
}

extension StrokeJoinToJson on StrokeJoin {
  String toJson() => name;
}

extension StrokeCapToJson on StrokeCap {
  String toJson() => name;
}

extension Matrix4ToJson on Matrix4 {
  List<double> toJson() {
    return storage.toList();
  }
}

extension SystemMouseCursorsToJson on SystemMouseCursor {
  ///Unknown cursors are serialized as an empty string.
  String toJson() {
    return systemMouseCursorsByName[kind] == this ? kind : "";
  }
}

extension OffsetToJsonExtension on Offset {
  Map<String, dynamic> toJson() {
    return {"dx": dx, "dy": dy};
  }
}

extension SizeToJsonExtension on Size {
  Map<String, dynamic> toJson() {
    return {"width": width, "height": height};
  }
}

extension RectToJsonExtension on Rect {
  Map<String, dynamic> toJson() {
    return {"left": left, "right": right, "top": top, "bottom": bottom};
  }
}

extension EdgeInsetsToJsonExtension on EdgeInsets {
  Map<String, dynamic> toJson() {
    return {"left": left, "right": right, "top": top, "bottom": bottom};
  }
}

extension RadiusToJsonExtension on Radius {
  Map<String, dynamic> toJson() {
    return {"x": x, "y": y};
  }

  static Radius? fromJson(Map<String, dynamic> map) {
    return parseRadius(map);
  }
}

extension BorderRadiusToJsonExtension on BorderRadius {
  Map<String, dynamic> toJson() {
    return {
      "topLeft": topLeft.toJson(),
      "topRight": topRight.toJson(),
      "bottomLeft": bottomLeft.toJson(),
      "bottomRight": bottomRight.toJson(),
    };
  }
}

extension GradientToJsonExtension on Gradient {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};

    rst.updateNotNull("stops", stops);
    rst.updateNotNull("colors", colors.map((e) => e.toJson()).toList());
    Gradient gradient = this;
    if (gradient is LinearGradient) {
      rst["type"] = "LinearGradient";
      rst.updateNotNull("begin", (gradient.begin as Alignment).toJson());
      rst.updateNotNull("end", (gradient.end as Alignment).toJson());
      rst.updateNotNull("tileMode", gradient.tileMode.toJson());
    } else if (gradient is RadialGradient) {
      rst["type"] = "RadialGradient";
      rst.updateNotNull("center", (gradient.center as Alignment).toJson());
      rst.updateNotNull("radius", gradient.radius);
      rst.updateNotNull("tileMode", gradient.tileMode.toJson());
    } else if (gradient is SweepGradient) {
      rst["type"] = "SweepGradient";
      rst.updateNotNull("center", (gradient.center as Alignment).toJson());
      rst.updateNotNull("startAngle", gradient.startAngle);
      rst.updateNotNull("endAngle", gradient.endAngle);
      rst.updateNotNull("tileMode", gradient.tileMode.toJson());
    }

    return rst;
  }
}

extension ImageFilterToJson on ImageFilter {
  ///Supports blur filters and the color filters supported by
  ///[ColorFilterToJsonExtension], other filters are serialized as an empty
  ///map.
  Map<String, dynamic> toJson() {
    ImageFilter filter = this;
    if (filter is ColorFilter) return filter.toJson();

    ///The blur parameters are private, so they are read from toString(),
    ///for example "ImageFilter.blur(2.0, 3.0, clamp)".
    Match? blur =
        RegExp(r"^ImageFilter\.blur\(\s*([^,\s]+)\s*,\s*([^,\s]+)\s*,\s*(\w+)")
            .firstMatch(toString());
    if (blur == null) return {};
    return {
      "sigmaX": double.tryParse(blur.group(1)!) ?? 0,
      "sigmaY": double.tryParse(blur.group(2)!) ?? 0,
      "tileMode": blur.group(3),
      "type": "ImageFilter",
    };
  }
}

extension ColorFilterToJsonExtension on ColorFilter {
  ///Supports [ColorFilter.mode] and [ColorFilter.matrix] filters, other
  ///filters are serialized as an empty map.
  Map<String, dynamic> toJson() {
    ///The filter parameters are private, so they are read from toString(),
    ///for example "ColorFilter.mode(Color(...), BlendMode.srcOver)".
    String string = toString();

    if (string.startsWith("ColorFilter.mode(")) {
      String? color = _colorStringFromDebugString(string);
      Match? mode = RegExp(r"BlendMode\.(\w+)").firstMatch(string);
      if (color != null && mode != null) {
        return {"color": color, "mode": mode.group(1), "type": "ColorFilter"};
      }
    } else if (string.startsWith("ColorFilter.matrix(")) {
      Match? values = RegExp(r"\[([^\]]*)\]").firstMatch(string);
      List<double?>? matrix =
          values?.group(1)!.split(",").map(double.tryParse).toList();
      if (matrix != null && matrix.length == 20 && !matrix.contains(null)) {
        return {"matrix": matrix.cast<double>(), "type": "ColorFilter"};
      }
    }

    return {};
  }
}

///Extracts a color from the toString() output of a class that contains a
///[Color]. The color is formatted as eight hex digits, like older versions of
///this package did.
///Supports both the legacy "Color(0xff2196f3)" format and the
///"Color(alpha: 1.0000, red: 0.1294, ...)" format used since Flutter 3.27.
String? _colorStringFromDebugString(String string) {
  int? argb;
  Match? hex = RegExp(r"\(0x([0-9a-fA-F]{1,8})\)").firstMatch(string);
  Match? channels = RegExp(
          r"alpha: (-?[\d.]+), red: (-?[\d.]+), green: (-?[\d.]+), blue: (-?[\d.]+)")
      .firstMatch(string);
  if (hex != null) {
    argb = int.parse(hex.group(1)!, radix: 16);
  } else if (channels != null) {
    int toInt8(String value) =>
        (double.parse(value) * 255.0).round().clamp(0, 255);
    argb = toInt8(channels.group(1)!) << 24 |
        toInt8(channels.group(2)!) << 16 |
        toInt8(channels.group(3)!) << 8 |
        toInt8(channels.group(4)!);
  }
  return argb?.toRadixString(16).padLeft(8, "0");
}

extension ImageProviderToJsonExtension on ImageProvider {
  ///Supports [NetworkImage] and [AssetImage], other providers are serialized
  ///as an empty map.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    ImageProvider image = this;
    if (image is NetworkImage) {
      rst["type"] = "NetworkImage";
      rst["url"] = image.url;
      rst["scale"] = image.scale;
    }
    if (image is AssetImage) {
      rst["type"] = "AssetImage";
      rst["assetName"] = image.assetName;
      rst["package"] = image.package;
    }
    return rst;
  }
}

extension ShadowToJsonExtension on Shadow {
  Map<String, dynamic> toJson() {
    return {
      "color": color.toJson(),
      "offset": offset.toJson(),
      "blurRadius": blurRadius,
    };
  }
}

extension DecorationImageToJsonExtension on DecorationImage {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull("image", image.toJson());
    rst.updateNotNull("colorFilter", colorFilter?.toJson());
    rst.updateNotNull("fit", fit?.toJson());
    rst.updateNotNull("alignment", (alignment as Alignment).toJson());
    rst.updateNotNull("repeat", repeat.toJson());
    rst.updateNotNull("scale", scale);

    return rst;
  }
}

extension BoxDecorationToJsonExtension on BoxDecoration {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull("color", color?.toJson());
    rst.updateNotNull("gradient", gradient?.toJson());
    rst.updateNotNull("image", image?.toJson());
    return rst;
  }
}

extension TextStyleToJsonExtension on TextStyle {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull("color", color?.toJson());
    rst.updateNotNull("backgroundColor", backgroundColor?.toJson());
    rst.updateNotNull("fontSize", fontSize);
    rst.updateNotNull("fontWeight", fontWeight?.toJson());
    rst.updateNotNull("fontStyle", fontStyle?.toJson());
    rst.updateNotNull("letterSpacing", letterSpacing);
    rst.updateNotNull("wordSpacing", wordSpacing);
    rst.updateNotNull("textBaseline", textBaseline?.toJson());
    rst.updateNotNull("height", height);
    rst.updateNotNull("decoration", decoration?.toJson());
    rst.updateNotNull("decorationColor", decorationColor?.toJson());
    rst.updateNotNull("decorationStyle", decorationStyle?.toJson());
    rst.updateNotNull("decorationThickness", decorationThickness);
    rst.updateNotNull("fontFamily", fontFamily);

    return rst;
  }
}
