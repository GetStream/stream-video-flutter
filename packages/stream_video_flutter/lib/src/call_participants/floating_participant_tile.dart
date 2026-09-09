import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'floating_participant_tile_defaults.dart';

/// The draggable self-view that floats over a call.
///
/// A participant tile sized and styled for the corner of the screen: small
/// enough that the overflow button and the speaking outline would only crowd
/// it, so by default it drops both and keeps the connection quality indicator
/// and any live reaction. It carries no name pill at all — an app-wide
/// [StreamParticipantTileTheme] asking for one does not put one here, though
/// [StreamFloatingParticipantTileStyle.tileStyle] still can.
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
    final defaults = StreamFloatingParticipantTileStyleDefaults(context);

    final size = style?.size ?? defaults.size;
    final borderRadius = style?.borderRadius ?? defaults.borderRadius;

    // What the tile inside the surface is styled with, lowest precedence
    // first:
    //
    //  1. the floating defaults, which strip the chrome that does not fit at
    //     this size;
    //  2. the ambient participant tile theme, so an app that deliberately
    //     styled tiles reaches this one too — a default must never outrank a
    //     theme, which is why this is not left to the tile's own merge, where
    //     everything below arrives as props and would beat it;
    //  3. what the self-view is rather than what it defaults to: the design
    //     gives it no name pill at any size, and the surface's corner radius,
    //     since the surface rounds the outside while the tile rounds the video
    //     inside it and the two clips have to agree — overriding only the
    //     surface radius would leave the tighter clip stopping short of the
    //     corners, which reads as four transparent notches. Above the ambient
    //     theme because neither is a default an app-wide tile theme should
    //     restyle away; the deprecated `callParticipantTheme` bridges a
    //     non-null `showParticipantLabel: true` into that theme, so leaving
    //     the pill below it put one on the self-view of every app that had
    //     merely set the old theme;
    //  4. an explicit tileStyle, which is a caller asking for exactly this —
    //     including the pill, and a radius that differs from the surface's.
    final tileStyle = defaults.tileStyle
        .merge(StreamParticipantTileTheme.of(context).style)
        .merge(
          StreamParticipantTileStyle(
            borderRadius: borderRadius,
            showParticipantLabel: false,
          ),
        )
        .merge(style?.tileStyle);

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
