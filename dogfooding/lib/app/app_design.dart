import 'package:flutter/material.dart';

import 'design/app_design_spec.dart';
import 'design/stream_design.dart';

/// The design system the app's components are drawn with.
enum AppDesign {
  /// The SDK's own design system.
  stream(StreamDesign());

  const AppDesign(this.spec);

  /// The theme, component builders and scope this design restyles the app
  /// with.
  final AppDesignSpec spec;

  /// The accent color this design uses when no accent color is picked.
  Color defaultAccent(Brightness brightness) => spec.defaultAccent(brightness);
}
