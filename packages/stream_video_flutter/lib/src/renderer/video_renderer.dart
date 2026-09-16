import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:visibility_detector/visibility_detector.dart';

import '../../stream_video_flutter.dart';

/// A builder for the widget that is displayed when there's no video stream.
Widget _defaultPlaceholderBuilder(BuildContext context) => Container();

/// Names each renderer for the call's viewport registry. Nothing outside this
/// process reads it; it only has to tell two live renderers apart.
int _viewportSeq = 0;

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
  // This renderer's name in the call's viewport registry, which holds one
  // measurement per renderer. Two renderers drawing the same participant — a
  // tile in the grid and a picture-in-picture overlay — must not share it, or
  // they are back to overwriting each other.
  final String _viewportId = '${_viewportSeq++}';

  VisibilityInfo? latestVisibilityInfo;

  /// The track this renderer last reported a measurement for, which it owes a
  /// release. Null until it has measured anything.
  ViewportTrack? _reportedTrack;

  ViewportTrack get _track => ViewportTrack(
    userId: widget.participant.userId,
    sessionId: widget.participant.sessionId,
    trackIdPrefix: widget.participant.trackIdPrefix,
    trackType: widget.videoTrackType,
  );

  @override
  void didUpdateWidget(covariant StreamVideoRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // An element recycled onto a different participant carries no measurement
    // from the one it drew before.
    final reported = _reportedTrack;
    if (reported != null && reported != _track) {
      _releaseAfterFrame(widget.call, _viewportId, reported);
      _reportedTrack = null;
    }

    final info = latestVisibilityInfo;
    if (info == null) return;

    final prevTrackState =
        oldWidget.participant.publishedTracks[oldWidget.videoTrackType];
    final newTrackState =
        widget.participant.publishedTracks[widget.videoTrackType];

    if (prevTrackState == null && newTrackState != null) {
      // The track has only now been published. Nothing this renderer measures
      // changed — it has been drawing a placeholder at the same size all along
      // — but that size has never been subscribed at, so the registry is asked
      // to say it again.
      //
      // Deferred, because acting on it writes call state, which the SDK's
      // emitter delivers synchronously: from the middle of this rebuild it
      // would ask a widget that has already been built this frame to build
      // again, and that throws. Nothing is waiting on the answer.
      final track = _track;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _report(latestVisibilityInfo ?? info);
        widget.call.viewportVisibility.reapply(track);
      });
    }
  }

  @override
  void dispose() {
    final reported = _reportedTrack;
    if (reported != null) {
      _releaseAfterFrame(widget.call, _viewportId, reported);
    }

    super.dispose();
  }

  /// Takes this renderer's measurement out of the registry at the end of the
  /// frame.
  ///
  /// Deferred for the same reason a report is, and taking what it needs by
  /// value: by the time it runs this [State] may be disposed, and the widget
  /// it would have read is gone.
  static void _releaseAfterFrame(
    Call call,
    String viewportId,
    ViewportTrack track,
  ) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      call.viewportVisibility.release(viewportId: viewportId, track: track);
    });
  }

  /// Hands the call what this renderer now measures for the track it draws.
  ///
  /// Only ever about itself: what the participant's visibility and
  /// subscription become is the registry's to decide, across every renderer
  /// drawing them.
  void _report(VisibilityInfo info) {
    latestVisibilityInfo = info;

    final visibility = ViewportVisibility.fromVisibleFraction(
      info.visibleFraction,
    );

    var size = Size.zero;
    if (visibility.isVisible) {
      // VisibilityDetector measures in logical, device-independent pixels, and
      // a track is subscribed in device pixels.
      final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
      size = Size(
        info.size.width * devicePixelRatio,
        info.size.height * devicePixelRatio,
      );
    }

    widget.onSizeChanged?.call(size);

    final track = _track;
    _reportedTrack = track;

    widget.call.viewportVisibility.report(
      viewportId: _viewportId,
      track: track,
      measurement: ViewportMeasurement(
        visibility: visibility,
        dimension: RtcVideoDimension(
          width: size.width.toInt(),
          height: size.height.toInt(),
        ),
        persistWhenHidden: widget.persistTrackIfNotVisible,
      ),
    );
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
      onVisibilityChanged: _report,
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
}

/// Options for scaling the bounds of a video.
enum VideoFit {
  /// Center the video in the widget, but perform no scaling.
  contain,

  /// Scale the video uniformly (maintain the video's aspect ratio)
  /// to cover the entire widget area.
  cover,

  /// Automatically pick between [cover] and [contain] based on the video's
  /// own orientation: landscape (or square) video fills the widget ([cover]),
  /// while portrait/tall video is letterboxed so the whole frame stays
  /// visible ([contain]).
  adaptive,
}

/// The [VideoFit] used for participant video when none is explicitly set.
///
/// Resolves to [VideoFit.adaptive] on web and desktop, so portrait video is
/// letterboxed instead of cropped, and to [VideoFit.cover] on mobile.
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
    return ValueListenableBuilder<rtc.RTCVideoValue>(
      valueListenable: _videoRenderer,
      builder: (context, value, _) {
        return rtc.RTCVideoView(
          _videoRenderer,
          mirror: widget.mirror,
          objectFit: _getVideoViewObjectFit(videoFit, value),
          filterQuality: FilterQuality.medium,
          placeholderBuilder: widget.placeholderBuilder,
        );
      },
    );
  }

  rtc.RTCVideoViewObjectFit _getVideoViewObjectFit(
    VideoFit videoFit,
    rtc.RTCVideoValue value,
  ) {
    switch (videoFit) {
      case VideoFit.cover:
        return rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;
      case VideoFit.contain:
        return rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
      case VideoFit.adaptive:
        // [RTCVideoValue.aspectRatio] is rotation-aware and returns 1.0 until
        // the first frame arrives, so tall/portrait video is letterboxed while
        // landscape (or square, or not-yet-known) video fills the widget.
        final isWide = value.aspectRatio >= 1.0;
        return isWide
            ? rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover
            : rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
    }
  }
}
