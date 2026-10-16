import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testEnumParsing<Orientation>('Orientation', Orientation.values,
      (value) => value.toJson(), parseOrientation);
  testEnumParsing<BlendMode>(
      'BlendMode', BlendMode.values, (value) => value.toJson(), parseBlendMode);
  testEnumParsing<TileMode>(
      'TileMode', TileMode.values, (value) => value.toJson(), parseTileMode);
  testEnumParsing<BoxFit>(
      'BoxFit', BoxFit.values, (value) => value.toJson(), parseBoxFit);
  testEnumParsing<ImageRepeat>('ImageRepeat', ImageRepeat.values,
      (value) => value.toJson(), parseImageRepeat);
  testEnumParsing<FilterQuality>('FilterQuality', FilterQuality.values,
      (value) => value.toJson(), parseFilterQuality);
  testEnumParsing<StackFit>(
      'StackFit', StackFit.values, (value) => value.toJson(), parseStackFit);
  testEnumParsing<FontStyle>(
      'FontStyle', FontStyle.values, (value) => value.toJson(), parseFontStyle);
  testEnumParsing<Axis>(
      'Axis', Axis.values, (value) => value.toJson(), parseAxis);
  testEnumParsing<AxisDirection>('AxisDirection', AxisDirection.values,
      (value) => value.toJson(), parseAxisDirection);
  testEnumParsing<TextOverflow>('TextOverflow', TextOverflow.values,
      (value) => value.toJson(), parseTextOverflow);
  testEnumParsing<TextDirection>('TextDirection', TextDirection.values,
      (value) => value.toJson(), parseTextDirection);
  testEnumParsing<TextDecorationStyle>(
      'TextDecorationStyle',
      TextDecorationStyle.values,
      (value) => value.toJson(),
      parseTextDecorationStyle);
  testEnumParsing<Clip>(
      'Clip', Clip.values, (value) => value.toJson(), parseClip);
  testEnumParsing<TextAlign>(
      'TextAlign', TextAlign.values, (value) => value.toJson(), parseTextAlign);
  testEnumParsing<TextBaseline>('TextBaseline', TextBaseline.values,
      (value) => value.toJson(), parseTextBaseline);
  testEnumParsing<MainAxisAlignment>(
      'MainAxisAlignment',
      MainAxisAlignment.values,
      (value) => value.toJson(),
      parseMainAxisAlignment);
  testEnumParsing<CrossAxisAlignment>(
      'CrossAxisAlignment',
      CrossAxisAlignment.values,
      (value) => value.toJson(),
      parseCrossAxisAlignment);
  testEnumParsing<WrapAlignment>('WrapAlignment', WrapAlignment.values,
      (value) => value.toJson(), parseWrapAlignment);
  testEnumParsing<WrapCrossAlignment>(
      'WrapCrossAlignment',
      WrapCrossAlignment.values,
      (value) => value.toJson(),
      parseWrapCrossAlignment);
  testEnumParsing<MainAxisSize>('MainAxisSize', MainAxisSize.values,
      (value) => value.toJson(), parseMainAxisSize);
  testEnumParsing<VerticalDirection>(
      'VerticalDirection',
      VerticalDirection.values,
      (value) => value.toJson(),
      parseVerticalDirection);
  testEnumParsing<BorderStyle>('BorderStyle', BorderStyle.values,
      (value) => value.toJson(), parseBorderStyle);
  testEnumParsing<StrokeJoin>('StrokeJoin', StrokeJoin.values,
      (value) => value.toJson(), parseStrokeJoin);
  testEnumParsing<StrokeCap>(
      'StrokeCap', StrokeCap.values, (value) => value.toJson(), parseStrokeCap);

  group('enum JSON format', () {
    test('is the plain value name', () {
      expect(BlendMode.srcOver.toJson(), 'srcOver');
      expect(TileMode.repeated.toJson(), 'repeated');
      expect(BoxFit.fitWidth.toJson(), 'fitWidth');
      expect(MainAxisAlignment.spaceBetween.toJson(), 'spaceBetween');
      expect(TextBaseline.ideographic.toJson(), 'ideographic');
      expect(ui.TextDirection.rtl.toJson(), 'rtl');
    });
  });

  group('FontWeight', () {
    test('serializes the predefined weights as w100 to w900', () {
      expect(FontWeight.values.map((weight) => weight.toJson()).toList(), [
        'w100',
        'w200',
        'w300',
        'w400',
        'w500',
        'w600',
        'w700',
        'w800',
        'w900',
      ]);
      expect(FontWeight.normal.toJson(), 'w400');
      expect(FontWeight.bold.toJson(), 'w700');
    });

    test('round trips the predefined weights', () {
      for (final FontWeight weight in FontWeight.values) {
        expect(parseFontWeight(jsonRoundTrip(weight.toJson())), weight);
      }
    });

    test('round trips weights that are not a multiple of 100', () {
      // Variable font weights such as 450 can only be created on newer
      // Flutter versions; lerp creates one there without needing the
      // FontWeight constructor that older versions don't have.
      final FontWeight weight =
          FontWeight.lerp(FontWeight.w400, FontWeight.w500, 0.5)!;
      expect(
          weight.toJson(),
          weight.value % 100 == 0
              ? 'w${weight.value}'
              : 'FontWeight(${weight.value})');
      expect(parseFontWeight(jsonRoundTrip(weight.toJson())), weight);
    });

    test('parses null and unknown strings to null', () {
      expect(parseFontWeight(null), isNull);
      expect(parseFontWeight(''), isNull);
      expect(parseFontWeight('bold'), isNull);
      expect(parseFontWeight('FontWeight.w700'), isNull);
    });
  });

  group('TextDecoration', () {
    test('serializes the single decorations by name', () {
      expect(TextDecoration.none.toJson(), 'none');
      expect(TextDecoration.underline.toJson(), 'underline');
      expect(TextDecoration.overline.toJson(), 'overline');
      expect(TextDecoration.lineThrough.toJson(), 'lineThrough');
    });

    test('round trips the single decorations', () {
      for (final TextDecoration decoration in const [
        TextDecoration.none,
        TextDecoration.underline,
        TextDecoration.overline,
        TextDecoration.lineThrough,
      ]) {
        expect(parseTextDecoration(jsonRoundTrip(decoration.toJson())),
            decoration);
      }
    });

    test('round trips combined decorations', () {
      final TextDecoration two = TextDecoration.combine(
          [TextDecoration.underline, TextDecoration.lineThrough]);
      final TextDecoration all = TextDecoration.combine([
        TextDecoration.lineThrough,
        TextDecoration.overline,
        TextDecoration.underline,
      ]);
      expect(two.toJson(), 'combine([underline, lineThrough])');
      expect(all.toJson(), 'combine([underline, overline, lineThrough])');
      expect(parseTextDecoration(jsonRoundTrip(two.toJson())), two);
      expect(parseTextDecoration(jsonRoundTrip(all.toJson())), all);
    });

    test('parses null and unknown strings to null', () {
      expect(parseTextDecoration(null), isNull);
      expect(parseTextDecoration(''), isNull);
      expect(parseTextDecoration('strikeThrough'), isNull);
      expect(parseTextDecoration('combine([underline, wavy])'), isNull);
    });
  });

  group('Alignment', () {
    const Map<String, Alignment> named = {
      'topLeft': Alignment.topLeft,
      'topCenter': Alignment.topCenter,
      'topRight': Alignment.topRight,
      'centerLeft': Alignment.centerLeft,
      'center': Alignment.center,
      'centerRight': Alignment.centerRight,
      'bottomLeft': Alignment.bottomLeft,
      'bottomCenter': Alignment.bottomCenter,
      'bottomRight': Alignment.bottomRight,
    };

    test('serializes the predefined alignments by name', () {
      named.forEach((name, alignment) {
        expect(alignment.toJson(), name);
        expect(parseAlignment(jsonRoundTrip(alignment.toJson())), alignment);
      });
      // Equal values are serialized by name too.
      expect(const Alignment(-1, 1).toJson(), 'bottomLeft');
      expect(const Alignment(-0.0, 0.0).toJson(), 'center');
    });

    test('serializes other alignments as "(x, y)"', () {
      expect(const Alignment(0.1, 0.2).toJson(), '(0.1, 0.2)');
      expect(const Alignment(-0.5, 1).toJson(), '(-0.5, 1.0)');
      expect(const Alignment(2, -3).toJson(), '(2.0, -3.0)');
      expect(const Alignment(0, 0.5).toJson(), '(0.0, 0.5)');
    });

    test('round trips other alignments', () {
      for (final Alignment alignment in const [
        Alignment(0.1, 0.2),
        Alignment(-0.5, 1),
        Alignment(2, -3),
      ]) {
        expect(parseAlignment(jsonRoundTrip(alignment.toJson())), alignment);
      }
    });

    test('round trips alignments that need more than one decimal', () {
      for (final Alignment alignment in const [
        Alignment(0.25, -0.75),
        Alignment(1 / 3, 0.05),
        Alignment(0.123456789, -0.987654321),
      ]) {
        expect(parseAlignment(jsonRoundTrip(alignment.toJson())), alignment);
      }
    });

    test('parses legacy and hand written values', () {
      expect(parseAlignment('(0.1, 0.2)'), const Alignment(0.1, 0.2));
      expect(parseAlignment('(1,0)'), Alignment.centerRight);
      expect(
          parseAlignment('Alignment(0.3, -0.4)'), const Alignment(0.3, -0.4));
    });

    test('parses null and malformed strings to null', () {
      expect(parseAlignment(null), isNull);
      expect(parseAlignment(''), isNull);
      expect(parseAlignment('middle'), isNull);
      expect(parseAlignment('(0.1)'), isNull);
      expect(parseAlignment('(a, b)'), isNull);
    });
  });

  group('Curve', () {
    const Map<String, Curve> curves = {
      'linear': Curves.linear,
      'decelerate': Curves.decelerate,
      'fastLinearToSlowEaseIn': Curves.fastLinearToSlowEaseIn,
      'fastEaseInToSlowEaseOut': Curves.fastEaseInToSlowEaseOut,
      'ease': Curves.ease,
      'easeIn': Curves.easeIn,
      'easeInToLinear': Curves.easeInToLinear,
      'easeInSine': Curves.easeInSine,
      'easeInQuad': Curves.easeInQuad,
      'easeInCubic': Curves.easeInCubic,
      'easeInQuart': Curves.easeInQuart,
      'easeInQuint': Curves.easeInQuint,
      'easeInExpo': Curves.easeInExpo,
      'easeInCirc': Curves.easeInCirc,
      'easeInBack': Curves.easeInBack,
      'easeOut': Curves.easeOut,
      'linearToEaseOut': Curves.linearToEaseOut,
      'easeOutSine': Curves.easeOutSine,
      'easeOutQuad': Curves.easeOutQuad,
      'easeOutCubic': Curves.easeOutCubic,
      'easeOutQuart': Curves.easeOutQuart,
      'easeOutQuint': Curves.easeOutQuint,
      'easeOutExpo': Curves.easeOutExpo,
      'easeOutCirc': Curves.easeOutCirc,
      'easeOutBack': Curves.easeOutBack,
      'easeInOut': Curves.easeInOut,
      'easeInOutSine': Curves.easeInOutSine,
      'easeInOutQuad': Curves.easeInOutQuad,
      'easeInOutCubic': Curves.easeInOutCubic,
      'easeInOutCubicEmphasized': Curves.easeInOutCubicEmphasized,
      'easeInOutQuart': Curves.easeInOutQuart,
      'easeInOutQuint': Curves.easeInOutQuint,
      'easeInOutExpo': Curves.easeInOutExpo,
      'easeInOutCirc': Curves.easeInOutCirc,
      'easeInOutBack': Curves.easeInOutBack,
      'fastOutSlowIn': Curves.fastOutSlowIn,
      'slowMiddle': Curves.slowMiddle,
      'bounceIn': Curves.bounceIn,
      'bounceOut': Curves.bounceOut,
      'bounceInOut': Curves.bounceInOut,
      'elasticIn': Curves.elasticIn,
      'elasticOut': Curves.elasticOut,
      'elasticInOut': Curves.elasticInOut,
    };

    test('serializes the predefined curves by name', () {
      curves.forEach((name, curve) {
        expect(curve.toJson(), name, reason: name);
      });
    });

    test('round trips the predefined curves', () {
      curves.forEach((name, curve) {
        expect(parseCurve(jsonRoundTrip(curve.toJson())), same(curve),
            reason: name);
      });
    });

    test('serializes other curves as an empty string', () {
      expect(const Interval(0.1, 0.5).toJson(), '');
      expect(const ElasticInCurve(0.3).toJson(), '');
      expect(Curves.easeIn.flipped.toJson(), '');
    });

    test('parses null and unknown strings to null', () {
      expect(parseCurve(null), isNull);
      expect(parseCurve(''), isNull);
      expect(parseCurve('Curves.ease'), isNull);
      expect(parseCurve('springy'), isNull);
    });
  });

  group('SystemMouseCursor', () {
    const List<SystemMouseCursor> cursors = [
      SystemMouseCursors.none,
      SystemMouseCursors.basic,
      SystemMouseCursors.click,
      SystemMouseCursors.forbidden,
      SystemMouseCursors.wait,
      SystemMouseCursors.progress,
      SystemMouseCursors.contextMenu,
      SystemMouseCursors.help,
      SystemMouseCursors.text,
      SystemMouseCursors.verticalText,
      SystemMouseCursors.cell,
      SystemMouseCursors.precise,
      SystemMouseCursors.move,
      SystemMouseCursors.grab,
      SystemMouseCursors.grabbing,
      SystemMouseCursors.noDrop,
      SystemMouseCursors.alias,
      SystemMouseCursors.copy,
      SystemMouseCursors.disappearing,
      SystemMouseCursors.allScroll,
      SystemMouseCursors.resizeLeftRight,
      SystemMouseCursors.resizeUpDown,
      SystemMouseCursors.resizeUpLeftDownRight,
      SystemMouseCursors.resizeUpRightDownLeft,
      SystemMouseCursors.resizeUp,
      SystemMouseCursors.resizeDown,
      SystemMouseCursors.resizeLeft,
      SystemMouseCursors.resizeRight,
      SystemMouseCursors.resizeUpLeft,
      SystemMouseCursors.resizeUpRight,
      SystemMouseCursors.resizeDownLeft,
      SystemMouseCursors.resizeDownRight,
      SystemMouseCursors.resizeColumn,
      SystemMouseCursors.resizeRow,
      SystemMouseCursors.zoomIn,
      SystemMouseCursors.zoomOut,
    ];

    test('serializes each cursor by its name', () {
      expect(SystemMouseCursors.click.toJson(), 'click');
      expect(SystemMouseCursors.resizeUpLeftDownRight.toJson(),
          'resizeUpLeftDownRight');
      for (final SystemMouseCursor cursor in cursors) {
        expect(cursor.toJson(), cursor.kind);
      }
    });

    test('round trips every cursor', () {
      for (final SystemMouseCursor cursor in cursors) {
        expect(parseSystemMouseCursor(jsonRoundTrip(cursor.toJson())), cursor);
      }
    });

    test('parses null and unknown strings to null', () {
      expect(parseSystemMouseCursor(null), isNull);
      expect(parseSystemMouseCursor(''), isNull);
      expect(parseSystemMouseCursor('pointer'), isNull);
    });
  });
}
