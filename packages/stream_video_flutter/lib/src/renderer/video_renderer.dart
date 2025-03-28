import 'package:flutter/material.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:visibility_detector/visibility_detector.dart';

import '../../stream_video_flutter.dart';

/// A builder for the widget that is displayed when there's no video stream.
Widget _defaultPlaceholderBuilder(BuildContext context) => Container();

/// Widget that renders a single video track for a call participant.
class StreamVideoRenderer extends StatefulWidget {
  /// Creates a new instance of [StreamVideoRenderer].
  const StreamVideoRenderer({
    super.key,
    required this.call,
    required this.participant,
    required this.videoTrackType,
    this.placeholderBuilder = _defaultPlaceholderBuilder,
    this.videoFit = VideoFit.cover,
    this.onSizeChanged,
  });

  /// Represents a call.
  final Call call;

  /// The participant who is publishing the track.
  final CallParticipantState participant;

  /// The type of video track to display.
  final SfuTrackTypeVideo videoTrackType;

  /// A builder for the placeholder.
  final WidgetBuilder placeholderBuilder;

  /// The scale type to use for the video renderer.
  final VideoFit videoFit;

  /// Called when the size of the widget changes.
  final ValueSetter<Size>? onSizeChanged;

  @override
  State<StreamVideoRenderer> createState() => _StreamVideoRendererState();
}

class _StreamVideoRendererState extends State<StreamVideoRenderer> {
  VisibilityInfo? latestVisibilityInfo;

  @override
  void didUpdateWidget(covariant StreamVideoRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final prevTrackState =
        oldWidget.participant.publishedTracks[oldWidget.videoTrackType];
    final newTrackState =
        widget.participant.publishedTracks[widget.videoTrackType];

    if (prevTrackState == null && newTrackState != null) {
      // The video track has been published.
      if (latestVisibilityInfo != null) {
        _onVisibilityChanged(latestVisibilityInfo!, widget.participant.userId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackState =
        widget.participant.publishedTracks[widget.videoTrackType];

    final Widget child;
    if (trackState == null) {
      // The video track hasn't been published or subscribed yet.
      child = widget.placeholderBuilder.call(context);
    } else if (trackState is! RemoteTrackState) {
      // The video track is local and is already published.
      child = _buildVideoTrackRenderer(context, trackState);
    } else if (trackState.subscribed && trackState.received) {
      final incomingVideoSettingsEnabled = widget
              .call.dynascaleManager.incomingVideoSettings
              ?.isParticipantVideoEnabled(widget.participant.sessionId) ??
          true;

      if (!incomingVideoSettingsEnabled) {
        // The video track is remote and has been received, but has been disabled.
        child = widget.placeholderBuilder.call(context);
      } else {
        // The video track is remote and has been received.
        child = _buildVideoTrackRenderer(context, trackState);
      }
    } else {
      // The video track is remote and hasn't been received yet.
      child = widget.placeholderBuilder.call(context);
    }

    return VisibilityDetector(
      key: Key(
        '${widget.participant.uniqueParticipantKey}${widget.videoTrackType}',
      ),
      onVisibilityChanged: (info) =>
          _onVisibilityChanged(info, widget.participant.userId),
      child: child,
    );
  }

  Widget _buildVideoTrackRenderer(BuildContext context, TrackState trackState) {
    // If the track is muted, display the placeholder.
    if (trackState.muted) {
      return widget.placeholderBuilder.call(context);
    }

    final videoTrack = widget.call.getTrack(
      widget.participant.trackIdPrefix,
      widget.videoTrackType,
    );

    // If the track is not available, display the placeholder.
    if (videoTrack == null) {
      return widget.placeholderBuilder.call(context);
    }

    var mirror = widget.participant.isLocal;

    if (videoTrack is RtcLocalScreenShareTrack) {
      mirror = false;
    } else if (videoTrack is RtcLocalTrack<CameraConstraints>) {
      final isBackCamera =
          videoTrack.mediaConstraints.facingMode == FacingMode.environment;

      mirror = switch (videoTrack.mediaConstraints.mirrorMode) {
        MirrorMode.defaultMode => mirror && !isBackCamera,
        MirrorMode.on => true,
        MirrorMode.off => false
      };
    }

    return VideoTrackRenderer(
      key: ValueKey(videoTrack.trackId),
      videoFit: widget.videoFit,
      videoTrack: videoTrack,
      mirror: mirror,
      placeholderBuilder: widget.placeholderBuilder,
    );
  }

  void _onVisibilityChanged(VisibilityInfo info, String participantId) {
    latestVisibilityInfo = info;
    final fraction = info.visibleFraction;

    final prevVisibility = widget.participant.viewportVisibility;
    final visibility = ViewportVisibility.fromVisibleFraction(fraction);

    // Update the viewport visibility of the participant.
    if (prevVisibility != visibility) {
      widget.call.updateViewportVisibility(
        sessionId: widget.participant.sessionId,
        userId: widget.participant.userId,
        visibility: visibility,
      );
    }

    var size = info.size;
    if (visibility != ViewportVisibility.visible) {
      // If the visibility is not visible, set the size to zero.
      size = Size.zero;
    }

    return _onSizeChanged(size, participantId);
  }

  void _onSizeChanged(Size size, String participantId) {
    // Notify the listener.
    if (widget.onSizeChanged != null) {
      widget.onSizeChanged!.call(size);
    }

    // We only care about remote tracks.
    final trackState =
        widget.participant.publishedTracks[widget.videoTrackType];
    if (trackState is! RemoteTrackState) return;

    final prevDim = trackState.videoDimension;
    final newDim = RtcVideoDimension(
      width: size.width.toInt(),
      height: size.height.toInt(),
    );

    // If the dimension hasn't changed, don't update the subscription.
    if (prevDim == newDim) return;

    if (newDim.isEmpty) {
      // Remove the video subscription of the track.
      widget.call.removeSubscription(
        userId: widget.participant.userId,
        sessionId: widget.participant.sessionId,
        trackIdPrefix: widget.participant.trackIdPrefix,
        trackType: widget.videoTrackType,
      );
    } else {
      // Update the video subscription of the track.
      widget.call.updateSubscription(
        userId: widget.participant.userId,
        sessionId: widget.participant.sessionId,
        trackIdPrefix: widget.participant.trackIdPrefix,
        trackType: widget.videoTrackType,
        videoDimension: newDim,
      );
    }
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
    this.videoFit = VideoFit.cover,
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
      if (mounted) setState(() => _isInitialized = true);
    })();
  }

  @override
  void didUpdateWidget(covariant VideoTrackRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoTrack != oldWidget.videoTrack) {
      _videoRenderer.srcObject = widget.videoTrack.mediaStream;
      if (mounted) setState(() {});
    }
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    if (_isInitialized) _videoRenderer.srcObject = null;
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
