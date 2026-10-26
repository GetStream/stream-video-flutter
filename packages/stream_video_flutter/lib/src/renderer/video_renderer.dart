import 'package:flutter/material.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../stream_video_flutter.dart';
import 'rendered_video_sizes.dart';

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

  /// Whether this renderer wants the track kept while it is off screen, as a
  /// screen share does. The track is unsubscribed once no renderer shows it
  /// and none asks for it. Defaults to false.
  final bool persistTrackIfNotVisible;

  /// Optional prefix to scope renderer keys (e.g. PiP vs main view).
  final String? rendererScopePrefix;

  @override
  Widget build(BuildContext context) {
    final trackState = participant.publishedTracks[videoTrackType];
    final isTrackPaused = participant.isTrackPaused(
      videoTrackType,
    );

    final Widget child;
    if (trackState == null || isTrackPaused) {
      // The video track hasn't been published or subscribed yet.
      child = placeholderBuilder.call(context);
    } else if (trackState is! RemoteTrackState) {
      // The video track is local and is already published.
      child = _buildVideoTrackRenderer(context, trackState);
    } else if (trackState.subscribed && trackState.received) {
      final incomingVideoSettingsEnabled =
          call.dynascaleManager.incomingVideoSettings
              ?.isParticipantVideoEnabled(
                participant.sessionId,
              ) ??
          true;

      if (!incomingVideoSettingsEnabled) {
        // The video track is remote and has been received, but has been disabled.
        child = placeholderBuilder.call(context);
      } else {
        // The video track is remote and has been received.
        child = _buildVideoTrackRenderer(context, trackState);
      }
    } else {
      // The video track is remote and hasn't been received yet.
      child = placeholderBuilder.call(context);
    }

    // What the call knows about this participant being on screen, and at what
    // size, comes from here — every viewport drawing them reports its own.
    return ViewportVisibilityReporter(
      registry: call.viewportVisibility,
      track: ViewportTrack(
        userId: participant.userId,
        sessionId: participant.sessionId,
        trackIdPrefix: participant.trackIdPrefix,
        trackType: videoTrackType,
      ),
      isTrackPublished: trackState != null,
      persistWhenHidden: persistTrackIfNotVisible,
      onSizeChanged: onSizeChanged,
      scopePrefix: rendererScopePrefix,
      child: child,
    );
  }

  Widget _buildVideoTrackRenderer(BuildContext context, TrackState trackState) {
    // If the track is muted, display the placeholder.
    if (trackState.muted) {
      return placeholderBuilder.call(context);
    }

    final videoTrack = call.getTrack(
      participant.trackIdPrefix,
      videoTrackType,
    );

    // If the track is not available, display the placeholder.
    if (videoTrack == null) {
      return placeholderBuilder.call(context);
    }

    var mirror =
        (trackState is RemoteTrackState && trackState.mirrorVideo) ||
        participant.isLocal;

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
        '${rendererScopePrefix ?? ''}${participant.uniqueParticipantKey}-$videoTrackType-renderer',
      ),
      videoFit: videoFit,
      videoTrack: videoTrack,
      mirror: mirror,
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
  final _logger = taggedLogger(tag: 'SV:VideoTrackRenderer');

  /// Renderer to display WebRTC video stream.
  final _videoRenderer = rtc.RTCVideoRenderer();

  /// If [rtc.RTCVideoRenderer] is initialized.
  bool _isInitialized = false;

  // The id of the track whose frame size this renderer last reported, so it
  // can be taken back.
  String? _reportedTrackId;

  @override
  void initState() {
    super.initState();
    // Only native size and rotation events, unlike the renderer's listeners,
    // which also fire when the stream is set and still hold the size of the
    // previous one.
    _videoRenderer.onResize = _reportVideoSize;
    _initializeRenderer();
  }

  Future<void> _initializeRenderer() async {
    try {
      await _videoRenderer.initialize();
    } catch (e, stk) {
      _logger.e(() => 'Could not initialise the video renderer: $e\n$stk');
      _disposeRenderer();
      return;
    }
    if (!mounted) {
      // Disposed while initialising; the texture only exists now.
      _disposeRenderer();
      return;
    }
    // Reads the current widget, so a track swapped in meanwhile is the one set.
    _videoRenderer.srcObject = widget.videoTrack.mediaStream;
    setState(() => _isInitialized = true);
  }

  @override
  void didUpdateWidget(covariant VideoTrackRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Until initialised, [_initializeRenderer] sets the stream itself.
    if (!_isInitialized) return;
    final streamChanged =
        widget.videoTrack.mediaStream != oldWidget.videoTrack.mediaStream;
    if (widget.videoTrack != oldWidget.videoTrack || streamChanged) {
      // A new track with the same id, such as after a reconnect, keeps its
      // size until its own frames report one.
      final reportedTrackId = _reportedTrackId;
      if (reportedTrackId != null &&
          reportedTrackId != widget.videoTrack.trackId) {
        RenderedVideoSizes.instance.remove(reportedTrackId, this);
        _reportedTrackId = null;
      }
      _videoRenderer.srcObject = widget.videoTrack.mediaStream;
    }
  }

  // Shares the size of the frames shown here, so that the Android
  // picture-in-picture window can take the video's shape.
  void _reportVideoSize() {
    final value = _videoRenderer.value;
    if (value.width <= 0 || value.height <= 0) return;

    final isRotated = value.rotation == 90 || value.rotation == 270;
    final trackId = _reportedTrackId = widget.videoTrack.trackId;
    RenderedVideoSizes.instance.report(
      trackId,
      this,
      isRotated
          ? Size(value.height, value.width)
          : Size(value.width, value.height),
      context: context,
    );
  }

  @override
  void dispose() {
    _videoRenderer.onResize = null;
    if (_reportedTrackId case final trackId?) {
      RenderedVideoSizes.instance.remove(trackId, this);
    }
    // Until initialised, [_initializeRenderer] disposes it once it resolves.
    if (_isInitialized) {
      _videoRenderer.srcObject = null;
      _disposeRenderer();
    }
    super.dispose();
  }

  void _disposeRenderer() {
    _videoRenderer.dispose().catchError((Object e, StackTrace stk) {
      _logger.e(() => 'Could not dispose the video renderer: $e\n$stk');
    });
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
