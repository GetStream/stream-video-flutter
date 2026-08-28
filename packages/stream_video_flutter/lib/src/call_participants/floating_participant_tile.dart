import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// The draggable self-view that floats over a call.
///
/// A participant tile sized and styled for the corner of the screen: small
/// enough that the name pill and the speaking outline would only crowd it, so
/// by default it carries the connection quality indicator alone.
///
/// The rendering can be replaced app-wide by registering a
/// `floatingParticipantTile` builder with [streamVideoComponentBuilders] on a
/// [StreamComponentFactory]. When no builder is registered,
/// [DefaultStreamFloatingParticipantTile] is used.
///
/// See also:
///
///  * [StreamFloatingParticipantTileTheme], for customizing its appearance.
///  * [StreamParticipantTile], the tile it wraps.
class StreamFloatingParticipantTile extends StatelessWidget {
  /// Creates a floating participant tile.
  StreamFloatingParticipantTile({
    super.key,
    required Call call,
    required CallParticipantState participant,
    StreamFloatingParticipantTileStyle? style,
    CallParticipantBuilder? participantBuilder,
  }) : props = .new(
         call: call,
         participant: participant,
         style: style,
         participantBuilder: participantBuilder,
       );

  /// The properties that configure this floating tile.
  final StreamFloatingParticipantTileProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context
        .videoComponentBuilder<StreamFloatingParticipantTileProps>();
    return builder?.call(context, props) ??
        DefaultStreamFloatingParticipantTile(props: props);
  }
}

/// Properties for configuring a [StreamFloatingParticipantTile].
///
/// See also:
///
///  * [StreamFloatingParticipantTile], which uses these properties.
///  * [DefaultStreamFloatingParticipantTile], the default implementation.
@immutable
class StreamFloatingParticipantTileProps {
  /// Creates properties for a floating participant tile.
  const StreamFloatingParticipantTileProps({
    required this.call,
    required this.participant,
    this.style,
    this.participantBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The participant to display — normally the local one.
  final CallParticipantState participant;

  /// Overrides for this floating tile's appearance.
  ///
  /// Merged over the ambient [StreamFloatingParticipantTileTheme].
  final StreamFloatingParticipantTileStyle? style;

  /// Builds the tile shown inside the floating surface.
  ///
  /// Replaces the participant tile entirely; the surface around it — its size,
  /// elevation and drag behaviour — is unaffected.
  final CallParticipantBuilder? participantBuilder;

  /// Creates a copy of these properties with the given fields replaced.
  StreamFloatingParticipantTileProps copyWith({
    Call? call,
    CallParticipantState? participant,
    StreamFloatingParticipantTileStyle? style,
    CallParticipantBuilder? participantBuilder,
  }) {
    return StreamFloatingParticipantTileProps(
      call: call ?? this.call,
      participant: participant ?? this.participant,
      style: style ?? this.style,
      participantBuilder: participantBuilder ?? this.participantBuilder,
    );
  }
}

/// The default implementation of [StreamFloatingParticipantTile].
class DefaultStreamFloatingParticipantTile extends StatelessWidget {
  /// Creates the default floating participant tile.
  const DefaultStreamFloatingParticipantTile({
    super.key,
    required this.props,
  });

  /// The properties that configure this floating tile.
  final StreamFloatingParticipantTileProps props;

  @override
  Widget build(BuildContext context) {
    final themeStyle = StreamFloatingParticipantTileTheme.of(context).style;
    final style = themeStyle?.merge(props.style) ?? props.style;
    final defaults = _StreamFloatingParticipantTileStyleDefaults(context);

    final size = style?.size ?? defaults.size;
    final borderRadius = style?.borderRadius ?? defaults.borderRadius;

    final tileStyle = defaults.tileStyle.merge(style?.tileStyle);

    return SizedBox.fromSize(
      size: size,
      child: Material(
        // Elevation rather than a painted shadow, so the self-view lifts off
        // the call the same way every other raised Stream surface does.
        elevation: style?.elevation ?? defaults.elevation,
        shadowColor: style?.shadowColor,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        // Clips whatever is inside to the same corners, so a replaced tile
        // does not have to round itself to sit in the surface.
        clipBehavior: Clip.antiAlias,
        child: DecoratedBox(
          // Outside the Material, which clips its children to its own shape and
          // would eat an outward-aligned border.
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: style?.border ?? defaults.border,
          ),
          child:
              props.participantBuilder?.call(
                context,
                props.call,
                props.participant,
              ) ??
              StreamParticipantTile(
                call: props.call,
                participant: props.participant,
                style: tileStyle,
              ),
        ),
      ),
    );
  }
}

// Default style values for [StreamFloatingParticipantTile].
class _StreamFloatingParticipantTileStyleDefaults
    extends StreamFloatingParticipantTileStyle {
  _StreamFloatingParticipantTileStyleDefaults(this._context);

  final BuildContext _context;

  late final _colorScheme = _context.streamColorScheme;
  late final _spacing = _context.streamSpacing;
  late final _radius = _context.streamRadius;
  late final _elevation = _context.streamElevation;

  @override
  Size get size => const Size(140, 228);

  @override
  double get padding => _spacing.md;

  @override
  BorderRadius get borderRadius => BorderRadius.all(_radius.lg);

  @override
  BoxBorder get border => Border.all(color: _colorScheme.borderOpacitySubtle);

  @override
  double get elevation => _elevation.level2;

  @override
  FloatingViewAlignment get initialAlignment => FloatingViewAlignment.topRight;

  @override
  bool get enableSnapping => true;

  @override
  StreamParticipantTileStyle get tileStyle => StreamParticipantTileStyle(
    borderRadius: borderRadius,
    // At this size a name and an outline crowd the video out; the connection
    // quality indicator is the one thing still worth the room.
    showParticipantLabel: false,
    showSpeakerBorder: false,
    showMoreButton: false,
    // The tile draws no border of its own — the floating surface owns it, and
    // two hairlines on the same corner read as one thick one.
    border: const Border(),
  );
}
