import 'package:flutter/material.dart';
import 'dart:convert';

extension stringParsingExtension on String {
  String stripFirstDot() {
    int index = this.indexOf('.') + 1;
    index = index == 0 ? 0 : index;
    return this.substring(index);
  }

  Color parseColor() {
    int colorInt = int.parse(this, radix: 16);
    return Color(colorInt);
  }

  BlendMode parseBlendMode() {
    switch (this.trim()) {
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
        return BlendMode.srcIn;
    }
  }

  TileMode parseTileMode() {
    switch (this) {
      case "clamp":
        return TileMode.clamp;
      case "mirror":
        return TileMode.mirror;
      case "repeated":
        return TileMode.repeated;
    }
    return TileMode.clamp;
  }

  Alignment parseAlignment() {

    Alignment alignment = Alignment.topLeft;
    switch (this) {
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
          List<String> aligns =
          this.substring(this.indexOf("("), this.indexOf(")")).split(",");
          alignment =
              Alignment(double.parse(aligns[0]), double.parse(aligns[1]));
        }
        break;
    }
    return alignment;
  }

  BoxFit parseBoxFit() {
    switch (this) {
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
    }
    return BoxFit.fill;
  }

  ImageRepeat parseImageRepeat() {
    switch (this) {
      case 'repeat':
        return ImageRepeat.repeat;
      case 'repeatX':
        return ImageRepeat.repeatX;
      case 'repeatY':
        return ImageRepeat.repeatY;
      case 'noRepeat':
        return ImageRepeat.noRepeat;
      default:
        return ImageRepeat.noRepeat;
    }
  }

  FilterQuality parseFilterQuality() {
    switch (this) {
      case 'none':
        return FilterQuality.none;
      case 'low':
        return FilterQuality.low;
      case 'medium':
        return FilterQuality.medium;
      case 'high':
        return FilterQuality.high;
      default:
        return FilterQuality.low;
    }
  }

  StackFit parseStackFit() {
    switch (this) {
      case 'loose':
        return StackFit.loose;
      case 'expand':
        return StackFit.expand;
      case 'passthrough':
        return StackFit.passthrough;
      default:
        return StackFit.loose;
    }
  }

  Axis parseAxis() {

    switch (this) {
      case "horizontal":
        return Axis.horizontal;
      case "vertical":
        return Axis.vertical;
    }
    return Axis.vertical;
  }

  TextDecoration parseTextDecoration() {
    switch (this) {
      case "none":
        return TextDecoration.none;
      case "underline":
        return TextDecoration.underline;
      case "lineThrough":
        return TextDecoration.lineThrough;
      case "overline":
        return TextDecoration.overline;
    }
    return TextDecoration.none;
  }

  TextDecorationStyle parseTextDecorationStyle() {

    switch (this) {
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
        return TextDecorationStyle.solid;
    }
  }

  Clip parseClipBehavior() {

    switch (this) {
      case "antiAlias":
        return Clip.antiAlias;
      case "none":
        return Clip.none;
      case "hardEdge":
        return Clip.hardEdge;
      case "antiAliasWithSaveLayer":
        return Clip.antiAliasWithSaveLayer;
      default:
        return Clip.antiAlias;
    }
  }

  Curve parseCurve() {

    switch (this) {
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
    }
    return Curves.linear;
  }

  ColorFilter parseColorFilter() {
    var map = json.decode(this);
    Color color = (map["color"] as String).parseColor();
    BlendMode mode = (map["mode"] as String).parseBlendMode();
    return ColorFilter.mode(color, mode);
  }

  DecorationImage parseDecorationImage() {
    var map = json.decode(this);
    String url = map["url"];
    ColorFilter colorFilter = (map["colorFilter"] as String).parseColorFilter();
    BoxFit fit = (map["fit"] as String).parseBoxFit();
    Alignment alignment = (map["alignment"] as String).parseAlignment();
    return DecorationImage(
        image: NetworkImage(url),
        fit: fit,
        alignment: alignment,
        colorFilter: colorFilter
    );
  }

  Gradient parseGradient() {
    var map = json.decode(this);
    List<Color> colors =
    (map["colors"] as List).map((e) => (e as String).parseColor()).toList();
    List<double> stops = map["stops"]?.cast<double>();
    TileMode tileMode = (map["tileMode"] as String).parseTileMode();
    if (map.containsKey("radius")) {
      Alignment center = (map["center"] as String).parseAlignment();
      double radius = map["radius"];
      return RadialGradient(
          center: center,
          radius: radius,
          colors: colors,
          stops: stops,
          tileMode: tileMode);
    } else if (map.containsKey("startAngle")) {
      Alignment center = (map["center"] as String).parseAlignment();
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
      Alignment begin = (map["begin"] as String).parseAlignment();
      Alignment end = (map["end"] as String).parseAlignment();
      return LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
          stops: stops,
          tileMode: tileMode);
    }
  }

  BoxDecoration parseBoxDecoration() {
    var map = json.decode(this);
    Color color = (map["color"] as String).parseColor();
    Gradient gradient = (map["gradient"] as String).parseGradient();
    DecorationImage image = (map["image"] as String).parseDecorationImage();
    return BoxDecoration(color: color, gradient: gradient, image: image);
  }
}