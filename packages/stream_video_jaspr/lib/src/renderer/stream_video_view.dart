import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_video/stream_video.dart';
import 'package:universal_web/web.dart' as web;

import 'video_track_renderer.dart';

/// Renders the video track for [participant], falling back to [placeholder]
/// when no track is currently available/enabled.
///
/// Drives minimal dynascale: on attach it reports the rendered size to the
/// SFU via [Call.updateSubscription] so the server can pick an appropriate
/// simulcast layer; on dispose it removes the subscription.
class StreamVideoView extends StatefulComponent {
  StreamVideoView({
    required this.call,
    required this.participant,
    SfuTrackTypeVideo? videoTrackType,
    this.objectFit = 'cover',
    this.placeholder,
    super.key,
  }) : videoTrackType = videoTrackType ?? SfuTrackType.video;

  final Call call;
  final CallParticipantState participant;
  final SfuTrackTypeVideo videoTrackType;
  final String objectFit;
  final Component Function()? placeholder;

  @override
  State<StreamVideoView> createState() => _StreamVideoViewState();
}

class _StreamVideoViewState extends State<StreamVideoView> {
  final _hostKey = GlobalNodeKey<web.HTMLDivElement>();
  bool _subscribed = false;

  @override
  void initState() {
    super.initState();
    context.binding.addPostFrameCallback(_subscribe);
  }

  @override
  void didUpdateComponent(StreamVideoView oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (!_subscribed) {
      context.binding.addPostFrameCallback(_subscribe);
    }
  }

  void _subscribe() {
    if (_subscribed) return;
    final host = _hostKey.currentNode;
    if (host == null) {
      context.binding.addPostFrameCallback(_subscribe);
      return;
    }
    _subscribed = true;

    final rect = host.getBoundingClientRect();
    final pixelRatio = web.window.devicePixelRatio;
    final dimension = RtcVideoDimension(
      width: (rect.width * pixelRatio).round(),
      height: (rect.height * pixelRatio).round(),
    );

    component.call.updateSubscription(
      userId: component.participant.userId,
      sessionId: component.participant.sessionId,
      trackIdPrefix: component.participant.trackIdPrefix,
      trackType: component.videoTrackType,
      videoDimension: dimension,
    );
  }

  @override
  void dispose() {
    if (_subscribed) {
      component.call.removeSubscription(
        userId: component.participant.userId,
        sessionId: component.participant.sessionId,
        trackIdPrefix: component.participant.trackIdPrefix,
        trackType: component.videoTrackType,
      );
    }
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final track = component.call.getTrack(
      component.participant.trackIdPrefix,
      component.videoTrackType,
    );
    final trackState =
        component.participant.publishedTracks[component.videoTrackType];
    final showVideo = track != null && trackState != null && !trackState.muted;

    return div(key: _hostKey, styles: _hostStyles, [
      if (showVideo)
        VideoTrackRenderer(
          mediaStream: track.mediaStream,
          mirror:
              component.participant.isLocal &&
              !component.videoTrackType.isScreenShare,
          objectFit: component.objectFit,
        )
      else
        component.placeholder?.call() ??
            DefaultParticipantPlaceholder(component.participant),
    ]);
  }

  static final _hostStyles = Styles(
    width: 100.percent,
    height: 100.percent,
    position: const Position.relative(),
  );
}

class DefaultParticipantPlaceholder extends StatelessComponent {
  const DefaultParticipantPlaceholder(this.participant);

  final CallParticipantState participant;

  @override
  Component build(BuildContext context) {
    return div(classes: 'svj-video-placeholder', [
      .text(
        participant.name.isNotEmpty ? participant.name : participant.userId,
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.svj-video-placeholder', [
      css('&').styles(
        display: .flex,
        width: 100.percent,
        height: 100.percent,
        alignItems: .center,
        justifyContent: .center,
        backgroundColor: const Color('#222'),
        color: Colors.white,
      ),
    ]),
  ];
}
