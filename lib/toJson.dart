import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_class_parser/StringParsing.dart';

extension MapExtension<K, V> on Map<K, V> {
  void updateNotNull(K key, V value) {
    if (value != null) this[key] = value;
  }
}

extension colorToJsonExtension on Color {
  String toJson() {
    return this.value.toRadixString(16);
  }
}

extension gradientToJsonExtension on Gradient {
  String toJson() {
    var rst = {};
    rst.updateNotNull("stops", this.stops);
    rst.updateNotNull("colors", this.colors.map((e) => e.toJson()).toList());
    if (this is LinearGradient) {
      rst.updateNotNull(
          "begin", (this as LinearGradient).begin.toString().stripFirstDot());
      rst.updateNotNull(
          "end", (this as LinearGradient).end.toString().stripFirstDot());
      rst.updateNotNull("tileMode",
          (this as LinearGradient).tileMode.toString().stripFirstDot());
    } else if (this is RadialGradient) {
      rst.updateNotNull(
          "center", (this as RadialGradient).center.toString().stripFirstDot());
      rst.updateNotNull("radius", (this as RadialGradient).radius);
      rst.updateNotNull("tileMode",
          (this as RadialGradient).tileMode.toString().stripFirstDot());
    } else if (this is SweepGradient) {
      rst.updateNotNull(
          "center", (this as SweepGradient).center.toString().stripFirstDot());
      rst.updateNotNull("startAngle", (this as SweepGradient).startAngle);
      rst.updateNotNull("endAngle", (this as SweepGradient).endAngle);
      rst.updateNotNull("tileMode",
          (this as SweepGradient).tileMode.toString().stripFirstDot());
    }

    return json.encode(rst);
  }
}

extension colorFilterToJsonExtension on ColorFilter {
  String toJson() {
    var rst = {};
    String temp = this.toString();
    //assume color filter is in mode type
    List<String> filtermode =
        temp.substring(temp.indexOf("("), temp.lastIndexOf((")"))).split(",");
    String colorString = filtermode[0];
    colorString = colorString.substring(
        colorString.lastIndexOf("(0x") + 3, colorString.indexOf(")"));
    rst["color"] = colorString;
    rst["mode"] = filtermode[1].stripFirstDot();
    return json.encode(rst);
  }
}

extension decorationImageToJsonExtension on DecorationImage {
  String toJson() {
    var rst = {};
    rst.updateNotNull("fit", this.fit.toString().stripFirstDot());
    rst.updateNotNull("alignment", this.alignment.toString().stripFirstDot());
    rst.updateNotNull("colorFilter", this.colorFilter?.toJson());
    rst.updateNotNull("url", (this.image as NetworkImage).url);
    return json.encode(rst);
  }
}

extension boxDecorationToJsonExtension on BoxDecoration {
  String toJson() {
    var rst = {};
    rst.updateNotNull("color", this.color?.toJson());
    rst.updateNotNull("gradient", this.gradient?.toJson());
    rst.updateNotNull("image", this.image?.toJson());
    return json.encode(rst);
  }
}

extension textStyleToJsonExtension on TextStyle {
  String toJson() {
    var rst = {};
    rst.updateNotNull("fontFamily", this.fontFamily);
    rst.updateNotNull("color", this.color?.toJson());
    rst.updateNotNull("backgroundColor", this.backgroundColor?.toJson());
    rst.updateNotNull("fontWeight", this.fontWeight.toString().stripFirstDot());
    rst.updateNotNull("fontStyle", this.fontStyle.toString().stripFirstDot());
    rst.updateNotNull("decoration", this.decoration.toString().stripFirstDot());
    rst.updateNotNull("decorationColor", this.decorationColor?.toJson());
    rst.updateNotNull(
        "decorationStyle", this.decorationStyle.toString().stripFirstDot());
    rst.updateNotNull("decorationThickness", this.decorationThickness);
    rst.updateNotNull("height", this.height);
    rst.updateNotNull("letterSpacing", this.letterSpacing);
    return json.encode(rst);
  }
}
