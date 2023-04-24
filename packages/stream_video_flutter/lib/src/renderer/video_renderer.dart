import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

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
  Call get call => widget.call;

  CallParticipantState get participant => widget.participant;

  SfuTrackTypeVideo get videoTrackType => widget.videoTrackType;

  @override
  Widget build(BuildContext context) {
    final trackState = participant.publishedTracks[widget.videoTrackType];

    final Widget child;
    if (trackState == null) {
      // The video track hasn't been published or subscribed yet.
      child = widget.placeholderBuilder.call(context);
    } else if (trackState is! RemoteTrackState) {
      // The video track is local and is already published.
      child = _buildVideoTrackRenderer(context, trackState);
    } else if (trackState.received) {
      // The video track is remote and has been received.
      child = _buildVideoTrackRenderer(context, trackState);
    } else {
      // The video track is remote and hasn't been received yet.
      child = widget.placeholderBuilder.call(context);
    }

    return SizeChangeListener(
      onSizeChanged: _onSizeChanged,
      child: child,
    );
  }

  Widget _buildVideoTrackRenderer(BuildContext context, TrackState trackState) {
    // If the track is muted, display the placeholder.
    if (trackState.muted) return widget.placeholderBuilder.call(context);

    final videoTrack = widget.call.getTrack(
      widget.participant.trackIdPrefix,
      widget.videoTrackType,
    )!;
    return VideoTrackRenderer(
      videoFit: widget.videoFit,
      videoTrack: videoTrack,
      mirror: widget.participant.isLocal,
      placeholderBuilder: widget.placeholderBuilder,
    );
  }

  void _onSizeChanged(Size size) {
    // Notify the listener.
    if (widget.onSizeChanged != null) {
      widget.onSizeChanged!.call(size);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prevSize = participant.viewportVisibility.size;

      print('Prev Size: $prevSize');
      print('New Size: $size');

      // If the size hasn't changed, don't update the viewport visibility.
      if (size == prevSize) return;

      // Update the viewport visibility of the participant.
      call.setParticipantViewportVisibility(
        sessionId: participant.sessionId,
        visibility: ViewportVisibility(size: size),
      );

      if (!participant.isLocal) {
        // Update the video subscription of the track.
        call.updateSubscription(
          userId: participant.userId,
          sessionId: participant.sessionId,
          trackIdPrefix: participant.trackIdPrefix,
          trackType: videoTrackType,
          videoDimension: RtcVideoDimension(
            width: size.width.toInt(),
            height: size.height.toInt(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // Update the viewport visibility of the participant.
    call.setParticipantViewportVisibility(
      sessionId: participant.sessionId,
      visibility: const ViewportVisibility.hidden(),
    );

    if (!participant.isLocal) {
      // Remove the subscription.
      call.removeSubscription(
        userId: participant.userId,
        sessionId: participant.sessionId,
        trackIdPrefix: participant.trackIdPrefix,
        trackType: videoTrackType,
      );
    }

    super.dispose();
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
