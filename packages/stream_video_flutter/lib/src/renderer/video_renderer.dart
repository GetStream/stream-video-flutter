import 'package:flutter/material.dart';
import 'package:stream_webrtc_flutter/flutter_webrtc.dart' as rtc;

import '../../stream_video_flutter.dart';
import '../widgets/size_change_listener.dart';

/// A builder for the widget that is displayed when there's no video stream.
Widget _defaultPlaceholderBuilder(BuildContext context) => Container();

/// Widget that renders a single video track for a call participant.
class StreamVideoRenderer extends StatelessWidget {
  /// Creates a new instance of [StreamVideoRenderer].
  const StreamVideoRenderer({
    super.key,
    required this.call,
    required this.participant,
    required this.videoTrackType,
    this.placeholderBuilder = _defaultPlaceholderBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The participant who is publishing the track.
  final CallParticipantState participant;

  /// The type of video track to display.
  final SfuTrackTypeVideo videoTrackType;

  /// A builder for the placeholder.
  final WidgetBuilder placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    final trackState = participant.publishedTracks[videoTrackType];

    // The video track hasn't been published yet.
    if (trackState == null) {
      return placeholderBuilder.call(context);
    }
    // The video track is local and shouldn't send size notifications..
    if (trackState is! RemoteTrackState) {
      return _buildVideoTrackRenderer(context, trackState);
    }

    final Widget child;
    if (trackState.received) {
      child = _buildVideoTrackRenderer(context, trackState);
    } else {
      child = placeholderBuilder.call(context);
    }
    return SizeChangeListener(
      onSizeChanged: (size) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          call.apply(
            UpdateSubscription(
              userId: participant.userId,
              sessionId: participant.sessionId,
              trackIdPrefix: participant.trackIdPrefix,
              trackType: videoTrackType,
              videoDimension: RtcVideoDimension(
                width: size.width.toInt(),
                height: size.height.toInt(),
              ),
            ),
          );
        });
      },
      child: child,
    );
  }

  Widget _buildVideoTrackRenderer(BuildContext context, TrackState trackState) {
    if (trackState.muted) return placeholderBuilder.call(context);

    final videoTrack = call.getTrack(
      participant.trackIdPrefix,
      videoTrackType,
    )!;
    return VideoTrackRenderer(
      videoTrack: videoTrack,
      mirror: participant.isLocal,
      placeholderBuilder: placeholderBuilder,
    );
  }
}

/// Options for scaling the bounds of a video.
enum VideoFit {
  /// Center the video in the widget, but perform no scaling.
  contain,

  /// Scale the video uniformly (maintain the video's aspect ratio)
  /// to cover the entire widget area.
  cover,
}

/// A widget that renders a single video track.
class VideoTrackRenderer extends StatefulWidget {
  /// Creates a new instance of [VideoTrackRenderer].
  const VideoTrackRenderer({
    super.key,
    required this.videoTrack,
    this.mirror = false,
    this.videoFit = VideoFit.contain,
    this.placeholderBuilder = _defaultPlaceholderBuilder,
  });

  /// The video track to display.
  final RtcTrack videoTrack;

  /// If the video should be mirrored.
  final bool mirror;

  /// The scale type of the video.
  final VideoFit videoFit;

  /// A builder for the placeholder.
  final WidgetBuilder placeholderBuilder;

  @override
  State<VideoTrackRenderer> createState() => _VideoTrackRendererState();
}

class _VideoTrackRendererState extends State<VideoTrackRenderer> {
  /// Renderer to display WebRTC video stream.
  final _videoRenderer = rtc.RTCVideoRenderer();

  /// If [rtc.RTCVideoRenderer] is initialized.
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    (() async {
      await _videoRenderer.initialize();
      _videoRenderer.srcObject = widget.videoTrack.mediaStream;
      setState(() {
        _isInitialized = true;
      });
    })();
  }

  @override
  void didUpdateWidget(covariant VideoTrackRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoTrack != oldWidget.videoTrack) {
      _videoRenderer.srcObject = widget.videoTrack.mediaStream;
      setState(() {});
    }
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _videoRenderer.srcObject = null;
    await _videoRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !_isInitialized
        ? widget.placeholderBuilder.call(context)
        : rtc.RTCVideoView(
            _videoRenderer,
            mirror: widget.mirror,
            objectFit: _getVideoViewObjectFit(widget.videoFit),
            filterQuality: FilterQuality.medium,
            placeholderBuilder: widget.placeholderBuilder,
          );
  }

  rtc.RTCVideoViewObjectFit _getVideoViewObjectFit(VideoFit videoFit) {
    switch (videoFit) {
      case VideoFit.cover:
        return rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;
      case VideoFit.contain:
        return rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
    }
  }
}
