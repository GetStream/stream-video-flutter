import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// What a participant tile shows in place of video.
///
/// Rendered whenever there is no picture to show — the camera is off, the track
/// has not arrived yet, or it is paused — so it stands in for the participant
/// rather than for the video: by default, their avatar centred on the tile.
///
/// The rendering can be replaced app-wide by registering a
/// `participantPlaceholder` builder with [streamVideoComponentBuilders] on a
/// [StreamComponentFactory]. When no builder is registered,
/// [DefaultStreamParticipantPlaceholder] is used.
///
/// See also:
///
///  * [StreamParticipantPlaceholderStyle], for customizing its appearance.
///  * [StreamUserAvatar], which it draws — replace that instead to change every
///    avatar in the SDK at once.
class StreamParticipantPlaceholder extends StatelessWidget {
  /// Creates a participant placeholder.
  StreamParticipantPlaceholder({
    super.key,
    required Call call,
    required CallParticipantState participant,
    StreamParticipantPlaceholderStyle? style,
  }) : props = .new(call: call, participant: participant, style: style);

  /// The properties that configure this placeholder.
  final StreamParticipantPlaceholderProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context
        .videoComponentBuilder<StreamParticipantPlaceholderProps>();
    return builder?.call(context, props) ??
        DefaultStreamParticipantPlaceholder(props: props);
  }
}

/// Properties for configuring a [StreamParticipantPlaceholder].
///
/// See also:
///
///  * [StreamParticipantPlaceholder], which uses these properties.
///  * [DefaultStreamParticipantPlaceholder], the default implementation.
@immutable
class StreamParticipantPlaceholderProps {
  /// Creates properties for a participant placeholder.
  const StreamParticipantPlaceholderProps({
    required this.call,
    required this.participant,
    this.style,
  });

  /// Represents a call.
  final Call call;

  /// The participant standing in for their missing video.
  final CallParticipantState participant;

  /// Overrides for this placeholder's appearance.
  final StreamParticipantPlaceholderStyle? style;

  /// Creates a copy of these properties with the given fields replaced.
  StreamParticipantPlaceholderProps copyWith({
    Call? call,
    CallParticipantState? participant,
    StreamParticipantPlaceholderStyle? style,
  }) {
    return StreamParticipantPlaceholderProps(
      call: call ?? this.call,
      participant: participant ?? this.participant,
      style: style ?? this.style,
    );
  }
}

/// The default implementation of [StreamParticipantPlaceholder].
class DefaultStreamParticipantPlaceholder extends StatelessWidget {
  /// Creates the default participant placeholder.
  const DefaultStreamParticipantPlaceholder({super.key, required this.props});

  /// The properties that configure this placeholder.
  final StreamParticipantPlaceholderProps props;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    // Merged rather than replaced: a style naming only a colour should not cost
    // the placeholder its size and ring.
    final avatarTheme = StreamAvatarThemeData(
      size: StreamAvatarSize.xxl,
      border: Border.all(color: colorScheme.borderOnInverse, width: 2),
    ).merge(props.style?.avatarTheme);

    return Center(
      child: StreamAvatarTheme(
        data: avatarTheme,
        // Through StreamUserAvatar rather than StreamAvatar directly, so an app
        // that registers a `userAvatar` builder sees it here too.
        child: StreamUserAvatar(user: props.participant.toUserInfo()),
      ),
    );
  }
}
