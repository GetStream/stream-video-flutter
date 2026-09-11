import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// The values a ringing screen falls back to when neither its theme nor its
/// call site names one.
///
/// Both screens share a layout and differ in their colors, so everything
/// resolves here and the outgoing screen overrides the two properties that
/// depend on it being drawn on top of the camera rather than on a surface.
///
/// Every getter is non-null, which is what lets the widgets below take one of
/// these rather than a style full of nulls. For the same reason it must never
/// be handed to a theme: merging one would pin every property of whatever it
/// was merged into.
@internal
class RingingCallStyleDefaults extends StreamRingingCallStyle {
  /// Resolves a ringing screen's defaults from the theme on the given context.
  RingingCallStyleDefaults(this.context, this.style);

  /// The context the design-system tokens are read from.
  final BuildContext context;

  /// The style the theme and the call site resolved to, if any.
  final StreamRingingCallStyle? style;

  late final colorScheme = context.streamColorScheme;
  late final textTheme = context.streamTextTheme;
  late final spacing = context.streamSpacing;

  @override
  Color get backgroundColor =>
      style?.backgroundColor ?? colorScheme.backgroundApp;

  @override
  TextStyle get titleTextStyle =>
      style?.titleTextStyle ??
      textTheme.headingLg.copyWith(color: colorScheme.textPrimary);

  @override
  TextStyle get statusTextStyle =>
      style?.statusTextStyle ??
      textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary);

  @override
  Color get scrimColor => style?.scrimColor ?? colorScheme.backgroundScrim;

  @override
  double get blurSigma => style?.blurSigma ?? 25;

  @override
  StreamAvatarThemeData get avatarTheme => const StreamAvatarThemeData(
    size: StreamAvatarSize.xxxl,
  ).merge(style?.avatarTheme);

  @override
  StreamAvatarGroupSize get avatarGroupSize =>
      style?.avatarGroupSize ?? StreamAvatarGroupSize.xxxl;

  @override
  double get contentSpacing => style?.contentSpacing ?? spacing.md;

  @override
  double get titleSpacing => style?.titleSpacing ?? spacing.xs;

  @override
  double get controlsSpacing => style?.controlsSpacing ?? 80;

  @override
  EdgeInsetsGeometry get controlsPadding =>
      style?.controlsPadding ?? const EdgeInsets.only(bottom: 104);

  @override
  double get secondaryControlsSpacing =>
      style?.secondaryControlsSpacing ?? spacing.xxl;
}
