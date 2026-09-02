import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../../stream_video_flutter.dart';

part 'participant_tile_theme.g.theme.dart';

/// Applies a participant tile theme to descendant [StreamParticipantTile]
/// widgets.
///
/// Wrap a subtree with [StreamParticipantTileTheme] to override the tile's
/// styling — for example to drop the name pill in a livestream layout while
/// leaving the grid untouched.
///
/// {@tool snippet}
///
/// ```dart
/// StreamParticipantTileTheme(
///   data: StreamParticipantTileThemeData(
///     style: StreamParticipantTileStyle(showParticipantLabel: false),
///   ),
///   child: child,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamParticipantTileThemeData], which describes the theme.
///  * [StreamParticipantTileStyle], the visual style it carries.
class StreamParticipantTileTheme extends InheritedTheme {
  /// Creates a participant tile theme.
  const StreamParticipantTileTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The tile theme data for descendant widgets.
  final StreamParticipantTileThemeData data;

  /// Returns the [StreamParticipantTileThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamParticipantTileTheme] ancestor take
  /// precedence over the global values from
  /// [StreamVideoTheme.participantTileTheme]. This allows partial overrides:
  /// setting only [StreamParticipantTileStyle.borderRadius] leaves the
  /// remaining properties coming from the global theme.
  static StreamParticipantTileThemeData of(BuildContext context) {
    final localTheme = context
        .dependOnInheritedWidgetOfExactType<StreamParticipantTileTheme>();
    return StreamVideoTheme.of(
      context,
    ).participantTileTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamParticipantTileTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamParticipantTileTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for customizing [StreamParticipantTile] widgets.
///
/// Wraps a [StreamParticipantTileStyle] so it can be served by
/// [StreamParticipantTileTheme] and slotted into [StreamVideoTheme] alongside
/// the other component theme data classes.
///
/// See also:
///
///  * [StreamParticipantTileStyle], the style embedded here.
///  * [StreamParticipantTileTheme], for overriding it in a subtree.
@themeGen
@immutable
class StreamParticipantTileThemeData with _$StreamParticipantTileThemeData {
  /// Creates participant tile theme data.
  const StreamParticipantTileThemeData({this.style});

  /// Visual styling for the tile.
  final StreamParticipantTileStyle? style;

  /// Linearly interpolate between two theme data objects.
  static StreamParticipantTileThemeData? lerp(
    StreamParticipantTileThemeData? a,
    StreamParticipantTileThemeData? b,
    double t,
  ) => _$StreamParticipantTileThemeData.lerp(a, b, t);
}

/// Visual styling properties for a [StreamParticipantTile].
///
/// A tile is a rounded surface holding a participant's video, a top toolbar
/// carrying the overflow button and any live reaction, and a bottom toolbar
/// carrying the name pill and the connection quality indicator.
///
/// The nested [placeholderStyle], [labelStyle] and
/// [connectionQualityIndicatorStyle] are handed to their components through
/// scoped themes, so a component supplied through the component factory picks
/// up the tile's styling without having to thread it manually.
///
/// Exposed separately from [StreamParticipantTileThemeData] so other theme data
/// classes can embed a tile style via a typed field — see
/// [StreamFloatingParticipantTileStyle.tileStyle].
@themeGen
@immutable
class StreamParticipantTileStyle with _$StreamParticipantTileStyle {
  /// Creates a tile style with optional property overrides.
  const StreamParticipantTileStyle({
    this.videoFit,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.speakingBorder,
    this.showSpeakerBorder,
    this.showParticipantLabel,
    this.showConnectionQualityIndicator,
    this.showMoreButton,
    this.showReaction,
    this.toolbarPadding,
    this.toolbarSpacing,
    this.topToolbarPadding,
    this.moreButtonStyle,
    this.reactionSize,
    this.reactionInset,
    this.placeholderStyle,
    this.labelStyle,
    this.connectionQualityIndicatorStyle,
  });

  /// How the participant's video fills the tile.
  ///
  /// Defaults to [VideoFit.adaptive] on web and desktop, [VideoFit.cover] on
  /// mobile.
  final VideoFit? videoFit;

  /// The fill behind the video.
  ///
  /// Visible while the participant's camera is off. Defaults to
  /// `colorScheme.backgroundSurfaceSubtle`.
  final Color? backgroundColor;

  /// The corner radius of the tile.
  ///
  /// Defaults to `radius.xxl`.
  final BorderRadius? borderRadius;

  /// The border drawn around a tile that is showing no video.
  ///
  /// A tile showing video needs no outline — the video itself defines the
  /// edge — so this is only painted while the placeholder is visible. Defaults
  /// to a hairline in `colorScheme.borderDefault`.
  final BoxBorder? border;

  /// The border drawn around the tile while the participant is speaking.
  ///
  /// Replaces [border] rather than stacking with it, and is suppressed entirely
  /// when [showSpeakerBorder] resolves to false. Defaults to a 2px outline in
  /// `colorScheme.accentPrimary`.
  final BoxBorder? speakingBorder;

  /// Whether [speakingBorder] is drawn while the participant is speaking.
  ///
  /// Defaults to true.
  final bool? showSpeakerBorder;

  /// Whether the name pill is shown in the bottom toolbar.
  ///
  /// Defaults to true.
  final bool? showParticipantLabel;

  /// Whether the connection quality indicator is shown in the bottom toolbar.
  ///
  /// Defaults to true.
  final bool? showConnectionQualityIndicator;

  /// Whether the overflow button is shown in the top toolbar.
  ///
  /// Has no effect on a tile with no actions: the button is hidden whenever the
  /// resolved action list is empty. Defaults to true.
  final bool? showMoreButton;

  /// Whether the participant's live reaction is shown in the top toolbar.
  ///
  /// Defaults to true.
  final bool? showReaction;

  /// The inset around the bottom toolbar's content.
  ///
  /// Defaults to `spacing.xs` on every side. The toolbar takes its height from
  /// its content, so this also sets how far the pill sits from the tile edge.
  final EdgeInsetsGeometry? toolbarPadding;

  /// The gap between the name pill and the connection quality indicator.
  ///
  /// Defaults to `spacing.xxs`. Also the minimum distance a long name is kept
  /// from the indicator before it ellipsizes.
  final double? toolbarSpacing;

  /// The inset around the top toolbar's content.
  ///
  /// Defaults to `spacing.xxs`, which lets the overflow button's tap target
  /// reach close to the tile corner while its visual stays inset.
  final EdgeInsetsGeometry? topToolbarPadding;

  /// The button style applied to the overflow button.
  ///
  /// Applied through a scoped [StreamButtonTheme], so a [StreamButton] supplied
  /// by a custom component builder picks it up too.
  final StreamButtonThemeStyle? moreButtonStyle;

  /// The font size of the reaction emoji.
  ///
  /// Defaults to 48.
  final double? reactionSize;

  /// The inset of the reaction from the tile's top and trailing edges.
  ///
  /// Measured from the tile edge rather than from [topToolbarPadding].
  /// Defaults to `spacing.sm`.
  final double? reactionInset;

  /// Styling for the widget shown while the participant's camera is off.
  final StreamParticipantPlaceholderStyle? placeholderStyle;

  /// Styling for the participant name pill.
  final StreamParticipantLabelStyle? labelStyle;

  /// Styling for the connection quality indicator.
  final StreamConnectionQualityIndicatorStyle? connectionQualityIndicatorStyle;

  /// Linearly interpolate between two styles.
  static StreamParticipantTileStyle? lerp(
    StreamParticipantTileStyle? a,
    StreamParticipantTileStyle? b,
    double t,
  ) => _$StreamParticipantTileStyle.lerp(a, b, t);
}

/// Visual styling for the widget shown while a participant's camera is off.
///
/// The placeholder centers the participant's avatar over the tile's background.
@themeGen
@immutable
class StreamParticipantPlaceholderStyle
    with _$StreamParticipantPlaceholderStyle {
  /// Creates a placeholder style with optional property overrides.
  const StreamParticipantPlaceholderStyle({this.avatarTheme});

  /// Configuration for the avatar at the center of the placeholder.
  ///
  /// Handed down through a scoped [StreamAvatarTheme], so it also reaches an
  /// avatar supplied through the component factory. Defaults to
  /// [StreamAvatarSize.xxl] with a 2px `colorScheme.borderOnInverse` ring.
  final StreamAvatarThemeData? avatarTheme;

  /// Linearly interpolate between two styles.
  static StreamParticipantPlaceholderStyle? lerp(
    StreamParticipantPlaceholderStyle? a,
    StreamParticipantPlaceholderStyle? b,
    double t,
  ) => _$StreamParticipantPlaceholderStyle.lerp(a, b, t);
}
