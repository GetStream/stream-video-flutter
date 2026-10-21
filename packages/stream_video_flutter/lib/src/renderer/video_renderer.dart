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
    this.videoFit,
    this.onSizeChanged,
    this.persistTrackIfNotVisible = false,
    this.rendererScopePrefix,
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
  ///
  /// When `null`, [defaultVideoFit] is used, which resolves to
  /// [VideoFit.adaptive] on web and desktop and [VideoFit.cover] on mobile.
  final VideoFit? videoFit;

  /// Called when the size of the widget changes.
  final ValueSetter<Size>? onSizeChanged;

  /// If the track should be persisted when not visible. Otherwise it will be unnsubscribed.
  /// This is useful for screen sharing, where the track should be persisted even when not visible.
  /// Defaults to false.
  final bool persistTrackIfNotVisible;

  /// Optional prefix to scope renderer keys (e.g. PiP vs main view).
  final String? rendererScopePrefix;

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
    final isTrackPaused = widget.participant.isTrackPaused(
      widget.videoTrackType,
    );

    final Widget child;
    if (trackState == null || isTrackPaused) {
      // The video track hasn't been published or subscribed yet.
      child = widget.placeholderBuilder.call(context);
    } else if (trackState is! RemoteTrackState) {
      // The video track is local and is already published.
      child = _buildVideoTrackRenderer(context, trackState);
    } else if (trackState.subscribed && trackState.received) {
      final incomingVideoSettingsEnabled =
          widget.call.dynascaleManager.incomingVideoSettings
              ?.isParticipantVideoEnabled(
                widget.participant.sessionId,
              ) ??
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
        '${widget.rendererScopePrefix ?? ''}${widget.participant.uniqueParticipantKey}${widget.videoTrackType}-visibility',
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

    var mirror =
        (trackState is RemoteTrackState && trackState.mirrorVideo) ||
        widget.participant.isLocal;

    if (videoTrack is RtcLocalScreenShareTrack) {
      mirror = false;
    } else if (videoTrack is RtcLocalTrack<CameraConstraints>) {
      final isBackCamera =
          videoTrack.mediaConstraints.facingMode == FacingMode.environment;

      mirror = switch (videoTrack.mediaConstraints.mirrorMode) {
        MirrorMode.defaultMode => mirror && !isBackCamera,
        MirrorMode.on => true,
        MirrorMode.off => false,
      };
    }

    return VideoTrackRenderer(
      key: Key(
        '${widget.rendererScopePrefix ?? ''}${widget.participant.uniqueParticipantKey}-${widget.videoTrackType}-renderer',
      ),
      videoFit: widget.videoFit,
      videoTrack: videoTrack,
      mirror: mirror,
      placeholderBuilder: widget.placeholderBuilder,
    );
  }

  void _onVisibilityChanged(VisibilityInfo info, String participantId) {
    latestVisibilityInfo = info;
    final fraction = info.visibleFraction;

    final prevVisibility = widget.videoTrackType.isScreenShare
        ? widget.participant.screenShareViewportVisibility
        : widget.participant.viewportVisibility;

    final visibility = ViewportVisibility.fromVisibleFraction(fraction);

    // Update the viewport visibility of the participant.
    if (prevVisibility != visibility) {
      widget.call.updateViewportVisibility(
        sessionId: widget.participant.sessionId,
        userId: widget.participant.userId,
        visibility: visibility,
        trackType: widget.videoTrackType,
      );
    }

    var size = info.size;
    if (visibility != ViewportVisibility.visible) {
      // If the visibility is not visible, set the size to zero.
      size = Size.zero;
    } else {
      // VisibilityDetector measures the size in logical, device-independent pixels.
      // We need to convert it to device pixels to get the correct size for the video track.
      final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
      size = Size(
        size.width * devicePixelRatio,
        size.height * devicePixelRatio,
      );
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

    if (newDim.isEmpty && !widget.persistTrackIfNotVisible) {
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

  /// Pick between [cover] and [contain] by comparing the video's orientation
  /// with the widget's: the video fills the widget ([cover]) when both are
  /// landscape or both are portrait, and is letterboxed ([contain]) when they
  /// differ, so a landscape feed in a portrait widget (or a portrait feed in a
  /// landscape one) is shown whole rather than cropped.
  ///
  /// Square counts as landscape on either side. When the widget's size cannot
  /// be measured, the widget is treated as landscape.
  adaptive,
}

/// Resolves [videoFit] to [VideoFit.cover] or [VideoFit.contain] for a video
/// of [videoAspectRatio] (width / height, rotation applied) shown in a widget
/// of [viewSize].
///
/// [VideoFit.cover] and [VideoFit.contain] are returned as they are.
@visibleForTesting
VideoFit resolveVideoFit(
  VideoFit videoFit, {
  required double videoAspectRatio,
  Size? viewSize,
}) {
  switch (videoFit) {
    case VideoFit.cover:
    case VideoFit.contain:
      return videoFit;
    case VideoFit.adaptive:
      final isVideoWide = videoAspectRatio >= 1.0;
      // A view that cannot be measured, such as one in an unbounded scroll
      // direction, counts as landscape, so the fit follows the video alone.
      final canMeasureView =
          viewSize != null && viewSize.isFinite && !viewSize.isEmpty;
      final isViewWide = !canMeasureView || viewSize.aspectRatio >= 1.0;
      return isVideoWide == isViewWide ? VideoFit.cover : VideoFit.contain;
  }
}

/// The [VideoFit] used for participant video when none is explicitly set.
///
/// Resolves to [VideoFit.adaptive] on web and desktop, so video whose
/// orientation differs from its tile is letterboxed instead of cropped, and to
/// [VideoFit.cover] on mobile.
VideoFit get defaultVideoFit {
  if (CurrentPlatform.isMobile) return VideoFit.cover;
  return VideoFit.adaptive;
}

/// A widget that renders a single video track.
class VideoTrackRenderer extends StatefulWidget {
  /// Creates a new instance of [VideoTrackRenderer].
  const VideoTrackRenderer({
    super.key,
    required this.videoTrack,
    this.mirror = false,
    this.videoFit,
    this.placeholderBuilder = _defaultPlaceholderBuilder,
  });

  /// The video track to display.
  final RtcTrack videoTrack;

  /// If the video should be mirrored.
  final bool mirror;

  /// The scale type of the video.
  ///
  /// When `null`, [defaultVideoFit] is used, which resolves to
  /// [VideoFit.adaptive] on web and desktop and [VideoFit.cover] on mobile.
  final VideoFit? videoFit;

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
    final streamChanged =
        widget.videoTrack.mediaStream != oldWidget.videoTrack.mediaStream;
    if (widget.videoTrack != oldWidget.videoTrack || streamChanged) {
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
    if (!_isInitialized) {
      return widget.placeholderBuilder.call(context);
    }

    final videoFit = widget.videoFit ?? defaultVideoFit;

    // Listen to the renderer's value so [VideoFit.adaptive] can recompute the
    // object fit whenever the incoming video dimensions or rotation change.
    //
    // The LayoutBuilder is there for every fit, not only the one that reads
    // the size, so switching fits keeps the tree shape and does not remount
    // the video view (which is stateful on web and would flash black).
    return ValueListenableBuilder<rtc.RTCVideoValue>(
      valueListenable: _videoRenderer,
      builder: (context, value, _) => LayoutBuilder(
        builder: (context, constraints) {
          // [RTCVideoValue.aspectRatio] is rotation-aware and returns 1.0
          // until the first frame arrives.
          final resolved = resolveVideoFit(
            videoFit,
            videoAspectRatio: value.aspectRatio,
            viewSize: constraints.biggest,
          );
          return rtc.RTCVideoView(
            _videoRenderer,
            mirror: widget.mirror,
            objectFit: resolved == VideoFit.cover
                ? rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover
                : rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
            filterQuality: FilterQuality.medium,
            placeholderBuilder: widget.placeholderBuilder,
          );
        },
      ),
    );
  }
}
