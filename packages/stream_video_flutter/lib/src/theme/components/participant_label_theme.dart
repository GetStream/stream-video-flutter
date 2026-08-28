import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'participant_label_theme.g.theme.dart';

/// Applies a participant label theme to descendant `StreamParticipantLabel`
/// widgets.
///
/// Wrap a subtree with [StreamParticipantLabelTheme] to override the styling of
/// the name pill shown on a participant tile.
///
/// {@tool snippet}
///
/// Drop the blur behind the pill, which costs a render layer per tile:
///
/// ```dart
/// StreamParticipantLabelTheme(
///   data: StreamParticipantLabelThemeData(
///     style: StreamParticipantLabelStyle(blurSigma: null),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamParticipantLabelThemeData], which describes the theme.
///  * [StreamParticipantLabelStyle], the visual style it carries.
class StreamParticipantLabelTheme extends InheritedTheme {
  /// Creates a participant label theme.
  const StreamParticipantLabelTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The label theme data for descendant widgets.
  final StreamParticipantLabelThemeData data;

  /// Returns the [StreamParticipantLabelThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamParticipantLabelTheme] ancestor take
  /// precedence over the global values from
  /// [StreamVideoTheme.participantLabelTheme]. This allows partial overrides:
  /// setting only [StreamParticipantLabelStyle.nameTextStyle] leaves the
  /// remaining properties coming from the global theme.
  static StreamParticipantLabelThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamParticipantLabelTheme>();
    return StreamVideoTheme.of(
      context,
    ).participantLabelTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamParticipantLabelTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamParticipantLabelTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing `StreamParticipantLabel` widgets.
///
/// Wraps a [StreamParticipantLabelStyle] so it can be served by
/// [StreamParticipantLabelTheme] and slotted into [StreamVideoTheme] alongside
/// the other component theme data classes.
///
/// See also:
///
///  * [StreamParticipantLabelStyle], the style embedded here.
///  * [StreamParticipantLabelTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamParticipantLabelThemeData with _$StreamParticipantLabelThemeData {
  /// Creates participant label theme data.
  const StreamParticipantLabelThemeData({this.style});

  /// Visual styling for the label.
  final StreamParticipantLabelStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamParticipantLabelThemeData? lerp(
    StreamParticipantLabelThemeData? a,
    StreamParticipantLabelThemeData? b,
    double t,
  ) => _$StreamParticipantLabelThemeData.lerp(a, b, t);
}

/// Visual styling properties for a `StreamParticipantLabel`.
///
/// The label is a pill holding the participant's name, a camera-off icon while
/// their video is off, and an audio indicator. It sits on top of video, so its
/// fill is an overlay rather than a surface color.
///
/// Exposed separately from [StreamParticipantLabelThemeData] so other theme
/// data classes can embed a label style via a typed field — see
/// [StreamParticipantTileStyle.labelStyle].
@themeGen
@immutable
class StreamParticipantLabelStyle with _$StreamParticipantLabelStyle {
  /// Creates a label style with optional property overrides.
  const StreamParticipantLabelStyle({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.spacing,
    this.blurSigma,
    this.nameTextStyle,
    this.videoOffIconColor,
    this.videoOffIconSize,
    this.audioIndicatorSize,
    this.audioIndicatorBorderRadius,
    this.audioIndicatorBackgroundColor,
    this.audioIndicatorIconSize,
    this.speakingColor,
    this.microphoneIconSize,
    this.microphoneOffColor,
  });

  /// The pill's fill.
  ///
  /// Defaults to `colorScheme.backgroundOverlayDarkStrong`, which stays legible
  /// on top of video.
  final Color? backgroundColor;

  /// The pill's corner radius.
  ///
  /// Defaults to `radius.lg`.
  final BorderRadius? borderRadius;

  /// The inset around the pill's content.
  ///
  /// Asymmetric by default — the audio indicator carries its own padding, so it
  /// sits closer to the trailing edge than the name does to the leading one.
  final EdgeInsetsGeometry? padding;

  /// The gap between the name, the camera-off icon and the audio indicator.
  ///
  /// Defaults to `spacing.xs`.
  final double? spacing;

  /// The blur applied to whatever sits behind the pill.
  ///
  /// Defaults to 12.5. Set to `null` to skip the blur entirely: it costs one
  /// render layer per tile, which is measurable on a full grid.
  final double? blurSigma;

  /// The text style of the participant's name.
  ///
  /// Defaults to `textTheme.metadataDefault` in `colorScheme.textOnAccent`.
  final TextStyle? nameTextStyle;

  /// The color of the camera-off icon.
  ///
  /// Defaults to the color of [nameTextStyle].
  final Color? videoOffIconColor;

  /// The side length of the camera-off icon.
  ///
  /// Defaults to 20.
  final double? videoOffIconSize;

  /// The side length of the audio indicator's box.
  ///
  /// Defaults to 24.
  final double? audioIndicatorSize;

  /// The corner radius of the audio indicator's box.
  ///
  /// Defaults to `radius.md`.
  final BorderRadius? audioIndicatorBorderRadius;

  /// The fill of the audio indicator's box.
  ///
  /// Defaults to [backgroundColor].
  final Color? audioIndicatorBackgroundColor;

  /// The side length of the bars inside the audio indicator.
  ///
  /// Defaults to 10.
  final double? audioIndicatorIconSize;

  /// The color of the sound indicator's bars.
  ///
  /// Defaults to `colorScheme.brand.shade300`.
  final Color? speakingColor;

  /// The side length of the muted-microphone icon.
  ///
  /// Defaults to 20.
  final double? microphoneIconSize;

  /// The color of the microphone icon while the participant is muted.
  ///
  /// Only the muted state draws an icon, so there is no unmuted counterpart.
  /// Defaults to the color of [nameTextStyle]: on a tile the muted state is
  /// information rather than a warning, and the red used for the mute control
  /// in the call bar would read as an error here.
  final Color? microphoneOffColor;

  /// Linearly interpolate between two styles.
  static StreamParticipantLabelStyle? lerp(
    StreamParticipantLabelStyle? a,
    StreamParticipantLabelStyle? b,
    double t,
  ) => _$StreamParticipantLabelStyle.lerp(a, b, t);
}
