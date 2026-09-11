import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'picture_in_picture_theme.g.theme.dart';

/// Applies a picture-in-picture theme to the descendant
/// picture-in-picture window.
///
/// The window is inserted into the nearest [Overlay], which in an app with a
/// [Navigator] sits above the route showing the call. A theme wrapped around
/// the call screen is therefore not an ancestor of it: set
/// [StreamVideoTheme.pictureInPictureTheme], or wrap this above the
/// [Navigator], to reach the window.
///
/// See also:
///
///  * [StreamPictureInPictureThemeData], which describes the theme.
///  * [StreamPictureInPictureStyle], the visual style it carries.
class StreamPictureInPictureTheme extends InheritedTheme {
  /// Creates a picture-in-picture theme.
  const StreamPictureInPictureTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The picture-in-picture theme data for descendant widgets.
  final StreamPictureInPictureThemeData data;

  /// Returns the [StreamPictureInPictureThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamPictureInPictureTheme] ancestor take
  /// precedence over the global values from
  /// [StreamVideoTheme.pictureInPictureTheme].
  static StreamPictureInPictureThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamPictureInPictureTheme>();
    return StreamVideoTheme.of(
      context,
    ).pictureInPictureTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamPictureInPictureTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamPictureInPictureTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing the picture-in-picture window.
///
/// See also:
///
///  * [StreamPictureInPictureStyle], the style embedded here.
///  * [StreamPictureInPictureTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamPictureInPictureThemeData with _$StreamPictureInPictureThemeData {
  /// Creates picture-in-picture theme data.
  const StreamPictureInPictureThemeData({this.style});

  /// Visual styling for the picture-in-picture window.
  final StreamPictureInPictureStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamPictureInPictureThemeData? lerp(
    StreamPictureInPictureThemeData? a,
    StreamPictureInPictureThemeData? b,
    double t,
  ) => _$StreamPictureInPictureThemeData.lerp(a, b, t);
}

/// Visual styling properties for the picture-in-picture window.
///
/// Applies to the window Android draws while the app is in
/// picture-in-picture mode. The iOS window is rendered natively and is
/// configured through `IOSPictureInPictureConfiguration` instead.
@themeGen
@immutable
class StreamPictureInPictureStyle with _$StreamPictureInPictureStyle {
  /// Creates a picture-in-picture style with optional property overrides.
  const StreamPictureInPictureStyle({this.tileStyle});

  /// Overrides applied to the participant tile the window renders.
  ///
  /// Merged over the ambient [StreamParticipantTileTheme] style, so an app-wide
  /// tile customization still reaches the window, and over the window's own
  /// choices, so this is what puts any of them back. The window draws no name
  /// pill, no connection quality indicator and no overflow button: it is a
  /// glance at the call, and Android delivers taps to the window rather than
  /// to what is drawn in it.
  ///
  /// Nothing here reaches a window built by
  /// `AndroidPictureInPictureConfiguration.callPictureInPictureWidgetBuilder` —
  /// that replaces what this styles.
  final StreamParticipantTileStyle? tileStyle;

  /// Linearly interpolate between two styles.
  static StreamPictureInPictureStyle? lerp(
    StreamPictureInPictureStyle? a,
    StreamPictureInPictureStyle? b,
    double t,
  ) => _$StreamPictureInPictureStyle.lerp(a, b, t);
}
