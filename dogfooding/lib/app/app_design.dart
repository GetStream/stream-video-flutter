import 'package:flutter/material.dart';

import 'design/app_design_spec.dart';
import 'design/fluent/fluent_design.dart';
import 'design/liquid_glass/liquid_glass_design.dart';
import 'design/m3e/m3e_design.dart';
import 'design/shad/shad_design.dart';
import 'design/stream_design.dart';
import 'design/yaru/yaru_design.dart';

/// The design system the app's components are drawn with.
enum AppDesign {
  /// The SDK's own design system.
  stream(StreamDesign()),

  /// shadcn/ui, through the shad package.
  shad(ShadDesign()),

  /// Ubuntu's Yaru.
  yaru(YaruDesign()),

  /// Windows 11's Fluent.
  fluent(FluentDesign()),

  /// Apple's Liquid Glass.
  liquidGlass(LiquidGlassDesign()),

  /// Material 3 Expressive.
  material3Expressive(M3EDesign());

  const AppDesign(this.spec);

  /// The theme, component builders and scope this design restyles the app
  /// with.
  final AppDesignSpec spec;

  /// The accent color this design uses when no accent color is picked.
  Color defaultAccent(Brightness brightness) => spec.defaultAccent(brightness);
}
