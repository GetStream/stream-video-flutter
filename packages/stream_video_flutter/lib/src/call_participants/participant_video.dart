import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// The video of a participant, with a placeholder for when there is none.
///
/// A thin component around [StreamVideoRenderer] so the video area of a
/// participant tile can be replaced app-wide: register a `participantVideo`
/// builder with [streamVideoComponentBuilders] on a [StreamComponentFactory].
/// When no builder is registered, [DefaultStreamParticipantVideo] is used.
///
/// A replacement is responsible for reporting the size it renders at through
/// [StreamParticipantVideoProps.onSizeChanged] — see that property.
///
/// See also:
///
///  * [StreamParticipantPlaceholder], shown when there is no picture.
class StreamParticipantVideo extends StatelessWidget {
  /// Creates a participant video.
  StreamParticipantVideo({
    super.key,
    required Call call,
    required CallParticipantState participant,
    SfuTrackTypeVideo? videoTrackType,
    String? rendererScopePrefix,
    VideoFit? videoFit,
    ValueSetter<Size>? onSizeChanged,
    WidgetBuilder? placeholderBuilder,
  }) : props = .new(
         call: call,
         participant: participant,
         videoTrackType: videoTrackType ?? SfuTrackType.video,
         rendererScopePrefix: rendererScopePrefix,
         videoFit: videoFit,
         onSizeChanged: onSizeChanged,
         placeholderBuilder: placeholderBuilder,
       );

  /// The properties that configure this video.
  final StreamParticipantVideoProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context
        .videoComponentBuilder<StreamParticipantVideoProps>();
    return builder?.call(context, props) ??
        DefaultStreamParticipantVideo(props: props);
  }
}

/// Properties for configuring a [StreamParticipantVideo].
///
/// See also:
///
///  * [StreamParticipantVideo], which uses these properties.
///  * [DefaultStreamParticipantVideo], the default implementation.
@immutable
class StreamParticipantVideoProps {
  /// Creates properties for a participant video.
  const StreamParticipantVideoProps({
    required this.call,
    required this.participant,
    SfuTrackTypeVideo? videoTrackType,
    this.rendererScopePrefix,
    this.videoFit,
    this.onSizeChanged,
    this.placeholderBuilder,
  }) : _videoTrackType = videoTrackType;

  final SfuTrackTypeVideo? _videoTrackType;

  /// Represents a call.
  final Call call;

  /// The participant whose video is shown.
  final CallParticipantState participant;

  /// Which of the participant's tracks to render.
  ///
  /// Defaults to their camera.
  SfuTrackTypeVideo get videoTrackType => _videoTrackType ?? SfuTrackType.video;

  /// Optional prefix to scope renderer keys (e.g. PiP vs main view).
  final String? rendererScopePrefix;

  /// How the video fills the space it is given.
  final VideoFit? videoFit;

  /// Reports the size the video is rendered at.
  ///
  /// This drives dynascale: the size decides which quality layer is requested
  /// from the SFU, so a replacement that does not report it leaves the call
  /// negotiating against stale dimensions. Forward it, or accept that every
  /// participant is subscribed to at whatever was last measured.
  final ValueSetter<Size>? onSizeChanged;

  /// Builds what is shown while there is no picture.
  ///
  /// Defaults to a [StreamParticipantPlaceholder].
  final WidgetBuilder? placeholderBuilder;

  /// Creates a copy of these properties with the given fields replaced.
  StreamParticipantVideoProps copyWith({
    Call? call,
    CallParticipantState? participant,
    SfuTrackTypeVideo? videoTrackType,
    String? rendererScopePrefix,
    VideoFit? videoFit,
    ValueSetter<Size>? onSizeChanged,
    WidgetBuilder? placeholderBuilder,
  }) {
    return StreamParticipantVideoProps(
      call: call ?? this.call,
      participant: participant ?? this.participant,
      videoTrackType: videoTrackType ?? _videoTrackType,
      rendererScopePrefix: rendererScopePrefix ?? this.rendererScopePrefix,
      videoFit: videoFit ?? this.videoFit,
      onSizeChanged: onSizeChanged ?? this.onSizeChanged,
      placeholderBuilder: placeholderBuilder ?? this.placeholderBuilder,
    );
  }
}

/// The default implementation of [StreamParticipantVideo].
class DefaultStreamParticipantVideo extends StatelessWidget {
  /// Creates the default participant video.
  const DefaultStreamParticipantVideo({super.key, required this.props});

  /// The properties that configure this video.
  final StreamParticipantVideoProps props;

  @override
  Widget build(BuildContext context) {
    final participant = props.participant;
    final prefix = props.rendererScopePrefix ?? '';

    // SfuTrackType carries no name; camera versus screen share is the only
    // distinction the key needs.
    final track = props.videoTrackType.isScreenShare ? 'screenShare' : 'video';

    return StreamVideoRenderer(
      key: ValueKey('$prefix${participant.uniqueParticipantKey}-$track'),
      rendererScopePrefix: props.rendererScopePrefix,
      call: props.call,
      participant: participant,
      videoTrackType: props.videoTrackType,
      onSizeChanged: props.onSizeChanged,
      videoFit: props.videoFit,
      placeholderBuilder:
          props.placeholderBuilder ??
          (context) => StreamParticipantPlaceholder(
            call: props.call,
            participant: participant,
          ),
    );
  }
}
