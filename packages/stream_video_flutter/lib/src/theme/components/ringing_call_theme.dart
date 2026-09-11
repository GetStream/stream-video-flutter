import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'ringing_call_theme.g.theme.dart';

/// Applies a theme to a descendant [StreamIncomingCallContent].
///
/// {@tool snippet}
///
/// ```dart
/// StreamIncomingCallTheme(
///   data: StreamIncomingCallThemeData(
///     style: StreamRingingCallStyle(statusTextStyle: TextStyle(fontSize: 20)),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamOutgoingCallTheme], the same for the screen that calls out.
///  * [StreamRingingCallStyle], the visual style both carry.
class StreamIncomingCallTheme extends InheritedTheme {
  /// Creates an incoming call theme.
  const StreamIncomingCallTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The incoming call theme data for descendant widgets.
  final StreamIncomingCallThemeData data;

  /// Returns the [StreamIncomingCallThemeData] merged from local and global
  /// themes.
  ///
  /// Merges, so a subtree can override one property and inherit the rest.
  static StreamIncomingCallThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamIncomingCallTheme>();
    return StreamVideoTheme.of(
      context,
    ).incomingCallContentTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamIncomingCallTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamIncomingCallTheme oldWidget) =>
      data != oldWidget.data;
}

/// Applies a theme to a descendant [StreamOutgoingCallContent].
///
/// See also:
///
///  * [StreamIncomingCallTheme], the same for the screen that is called.
///  * [StreamRingingCallStyle], the visual style both carry.
class StreamOutgoingCallTheme extends InheritedTheme {
  /// Creates an outgoing call theme.
  const StreamOutgoingCallTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The outgoing call theme data for descendant widgets.
  final StreamOutgoingCallThemeData data;

  /// Returns the [StreamOutgoingCallThemeData] merged from local and global
  /// themes.
  ///
  /// Merges, so a subtree can override one property and inherit the rest.
  static StreamOutgoingCallThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamOutgoingCallTheme>();
    return StreamVideoTheme.of(
      context,
    ).outgoingCallContentTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamOutgoingCallTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamOutgoingCallTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [StreamIncomingCallContent].
///
/// See also:
///
///  * [StreamRingingCallStyle], the style embedded here.
///  * [StreamIncomingCallTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamIncomingCallThemeData with _$StreamIncomingCallThemeData {
  /// Creates incoming call theme data.
  const StreamIncomingCallThemeData({this.style});

  /// Visual styling for the screen.
  final StreamRingingCallStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamIncomingCallThemeData? lerp(
    StreamIncomingCallThemeData? a,
    StreamIncomingCallThemeData? b,
    double t,
  ) => _$StreamIncomingCallThemeData.lerp(a, b, t);
}

/// Theme data for customizing [StreamOutgoingCallContent].
///
/// Separate from [StreamIncomingCallThemeData] so the two screens can be
/// themed apart: they share a style shape but not a background, and the
/// outgoing one draws its text on top of the camera rather than on a surface.
///
/// See also:
///
///  * [StreamRingingCallStyle], the style embedded here.
///  * [StreamOutgoingCallTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamOutgoingCallThemeData with _$StreamOutgoingCallThemeData {
  /// Creates outgoing call theme data.
  const StreamOutgoingCallThemeData({this.style});

  /// Visual styling for the screen.
  final StreamRingingCallStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamOutgoingCallThemeData? lerp(
    StreamOutgoingCallThemeData? a,
    StreamOutgoingCallThemeData? b,
    double t,
  ) => _$StreamOutgoingCallThemeData.lerp(a, b, t);
}

/// Visual styling properties for a ringing call screen.
///
/// Both ringing screens are the same layout — an avatar over a name and a
/// status line, with the call controls below — so they share one style shape.
/// What differs is where it resolves its defaults from: the incoming screen
/// sits on a surface, the outgoing one on the local camera.
@themeGen
@immutable
class StreamRingingCallStyle with _$StreamRingingCallStyle {
  /// Creates a ringing call style with optional property overrides.
  const StreamRingingCallStyle({
    this.backgroundColor,
    this.scrimColor,
    this.blurSigma,
    this.avatarTheme,
    this.avatarGroupSize,
    this.contentSpacing,
    this.titleSpacing,
    this.titleTextStyle,
    this.statusTextStyle,
    this.controlsSpacing,
    this.controlsPadding,
    this.secondaryControlsSpacing,
  });

  /// The fill behind the whole screen.
  ///
  /// Defaults to `colorScheme.backgroundApp` on the incoming screen. The
  /// outgoing screen draws the local camera instead and only falls back to
  /// this when there is no camera to draw.
  final Color? backgroundColor;

  /// The wash drawn over the camera on the outgoing screen.
  ///
  /// Defaults to `colorScheme.backgroundScrim`. Unused by the incoming screen,
  /// which has nothing to wash over.
  final Color? scrimColor;

  /// The blur applied to the camera on the outgoing screen.
  ///
  /// Defaults to 25. Set to `0` to show the camera sharp; `null` is not the
  /// way to switch it off — like every property here it means "no override".
  final double? blurSigma;

  /// The theme the single participant's avatar is drawn with.
  ///
  /// Defaults to `StreamAvatarSize.xxxl`, the 104px size the design gives it.
  final StreamAvatarThemeData? avatarTheme;

  /// The size the avatar group is drawn at when more than one person is
  /// ringing.
  ///
  /// Defaults to `StreamAvatarGroupSize.xxxl`, so a group fills the same box
  /// as a single avatar. Sized separately because the design system counts
  /// group sizes and avatar sizes on two different scales.
  final StreamAvatarGroupSize? avatarGroupSize;

  /// The gap between the avatar and the name below it.
  ///
  /// Defaults to `spacing.md`.
  final double? contentSpacing;

  /// The gap between the name and the status line under it.
  ///
  /// Defaults to `spacing.xs`.
  final double? titleSpacing;

  /// The text style of the name of whoever is ringing.
  ///
  /// Defaults to `textTheme.headingLg`, in `colorScheme.textPrimary` on the
  /// incoming screen and `textOnAccent` on the outgoing one.
  final TextStyle? titleTextStyle;

  /// The text style of the line saying what the call is doing.
  ///
  /// Defaults to `textTheme.bodyDefault`, in `colorScheme.textSecondary` on
  /// the incoming screen and `textOnAccent` on the outgoing one.
  final TextStyle? statusTextStyle;

  /// The gap between the two buttons that answer and decline.
  ///
  /// Defaults to 80. Wide on purpose: the two do opposite things and are the
  /// one pair on the screen that must not be mistaken for each other.
  final double? controlsSpacing;

  /// The inset around the call controls.
  ///
  /// Defaults to 104 from the bottom, above the safe area.
  final EdgeInsetsGeometry? controlsPadding;

  /// The gap between the ringing buttons and the microphone and camera
  /// toggles under them.
  ///
  /// Defaults to `spacing.xxl`.
  final double? secondaryControlsSpacing;

  /// Linearly interpolate between two styles.
  static StreamRingingCallStyle? lerp(
    StreamRingingCallStyle? a,
    StreamRingingCallStyle? b,
    double t,
  ) => _$StreamRingingCallStyle.lerp(a, b, t);
}
