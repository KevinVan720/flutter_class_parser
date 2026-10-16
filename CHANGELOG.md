## [0.0.1].

Added basic serialization support for Flutter UI data classes.

## [0.0.2].

Update license.

## [0.0.3].

Avoid using runtimeType.

## [0.0.4].

Add borderStyle parsing.

## [0.0.5].

Fix Alignment parsing.

## [0.0.6].

Fix Alignment parsing.

## [0.0.7].

Add font weight parsing.

## [0.0.8].

Redo enum and Curve parsing.

## [0.0.9].

MouseCursor and Matrix4.

## [0.1.0].

Fix int to double conversion

## [0.1.1].

Update SDK dependence

## [0.1.2].

Fix int to double conversion

## [0.1.3].

Image provider parsing

## [0.1.4].

ImageFilter parsing

## [0.1.5].

StrokeJoin, StrokeCap parsing

## [0.1.6].

EdgeInsets, Shadow parsing

## [0.1.7].

EdgeInsets, Shadow parsing

## [0.1.8].

Fix ImageFilter parsing on the web

## [0.1.9].

Code clean up

## [0.2.0].

Code restructure

## [0.2.1].

Code restructure

## [0.2.2].

Update dependence

## [0.2.3].

Orientation parse

## [0.2.4].

Update license.

## [0.2.5].

Update dependency.

## [0.2.6].

- Support the latest Flutter stable (3.47). Require Flutter 3.27 or higher.
- Only depend on the Flutter widgets library instead of Material, so the package works with both `package:flutter/material.dart` and the standalone `material_ui` package.
- Fix `ColorFilter.toJson` crashing with the `Color.toString` format introduced in Flutter 3.27.
- Fix the tile mode of `ImageFilter.blur`, and round trip blur filters created without a tile mode (Flutter 3.29 and higher) instead of parsing them with `TileMode.clamp`.
- Serialize `ColorFilter.matrix` filters. Color filters that can't be serialized are written as `{}`, which `parseColorFilter` now parses as `null` instead of a transparent `BlendMode.src` filter that hid the image.
- Fix `Curves.elasticInOut` being serialized as `"elasticOut"`, and support `Curves.fastEaseInToSlowEaseOut` and `Curves.easeInOutCubicEmphasized`.
- `Alignment.toJson` no longer rounds alignments to one decimal, for example `Alignment(0.25, 0)` was serialized as `"(0.3, 0.0)"`. Values with at most one decimal are serialized as before.
- Round trip combined `TextDecoration`s, such as `"combine([underline, lineThrough])"`, and weights that are not a multiple of 100, such as `"FontWeight(450)"`.
- `parseTextStyle` now reads `wordSpacing` and `textBaseline`, which `toJson` already wrote, and no longer crashes when `fontSize` or other optional values are missing.
- Accept integer JSON numbers (`1` instead of `1.0`, as written by the web or by hand) in `parseMatrix4`, `parseImageProvider` and `RadiusToJsonExtension.fromJson`.
- Missing numbers no longer crash `parseOffset`, `parseSize`, `parseRect`, `parseEdgeInsets`, `parseRadius` and `parseGradient`. They default to zero, or to the default of the gradient constructor.
- `parseAlignment` returns `null` for malformed strings instead of throwing.
- Add `parseFontStyle`.
- Serialize enums with `Enum.name` and other values from their fields instead of parsing `toString()` where possible. The JSON output is unchanged.
- Replace the deprecated `Color.value` with `Color.toARGB32`.
- Add tests and lints.
