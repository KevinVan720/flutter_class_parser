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

Support the latest Flutter stable (3.47).
Only depend on the Flutter widgets library instead of Material, so the package works with both `package:flutter/material.dart` and the standalone `material_ui` package.
Fix `ColorFilter.toJson` crashing with the new `Color.toString` format introduced in Flutter 3.27.
Fix `ImageFilter.blur` tile mode serialization and `parseTextStyle` crashing when `fontSize` or other optional values are missing.
Replace the deprecated `Color.value` with `Color.toARGB32`.
Require Flutter 3.27 or higher.
