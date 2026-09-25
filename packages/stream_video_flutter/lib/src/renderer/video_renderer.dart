import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../stream_video_flutter.dart';
import 'element_frame_capture.dart';
import 'last_frame_cache.dart';

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

    // A track that is gone or turned off must not come back showing the
    // picture from before.
    if (trackState == null || trackState.muted) {
      _lastFrameCache.remove(_lastFrameKey);
    }

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
      // The video track is remote and hasn't been received yet: show what it
      // last showed, if anything, until it is.
      child = _buildLastFrameOrPlaceholder(context);
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
      return _buildLastFrameOrPlaceholder(context);
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
      placeholderBuilder: _buildLastFrameOrPlaceholder,
      onLastFrame: _storeLastFrame,
    );
  }

  LastVideoFrameCache get _lastFrameCache => LastVideoFrameCache.of(call);

  String get _lastFrameKey =>
      LastVideoFrameCache.keyFor(participant, videoTrackType);

  Widget _buildLastFrameOrPlaceholder(BuildContext context) {
    return LastVideoFrameOrPlaceholder(
      cache: _lastFrameCache,
      frameKey: _lastFrameKey,
      videoFit: videoFit,
      placeholderBuilder: placeholderBuilder,
    );
  }

  void _storeLastFrame(LastVideoFrame frame) {
    // A capture can finish after the track was turned off or unpublished;
    // keep it only while the track is still there to come back.
    final current = call.state.value.callParticipants.firstWhereOrNull(
      (it) => it.sessionId == participant.sessionId,
    );
    final trackState = current?.publishedTracks[videoTrackType];
    if (trackState == null || trackState.muted) {
      frame.image.dispose();
      return;
    }

    _lastFrameCache.put(_lastFrameKey, frame);
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
    this.onLastFrame,
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

  /// Called with the last frame shown when this renderer is taken out of the
  /// tree, so it can be shown while the track comes back.
  final ValueSetter<LastVideoFrame>? onLastFrame;

  @override
  State<VideoTrackRenderer> createState() => _VideoTrackRendererState();
}

class _VideoTrackRendererState extends State<VideoTrackRenderer> {
  /// Renderer to display WebRTC video stream.
  final _videoRenderer = rtc.RTCVideoRenderer();

  /// If [rtc.RTCVideoRenderer] is initialized.
  bool _isInitialized = false;

  /// Marks what is painted of the video, for capturing its last frame.
  final _boundaryKey = GlobalKey();

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
  void deactivate() {
    _captureLastFrame();
    super.deactivate();
  }

  /// Hands the frame on screen to [VideoTrackRenderer.onLastFrame].
  ///
  /// Runs as the renderer leaves the tree, while its layer still holds the
  /// last frame painted.
  void _captureLastFrame() {
    final onLastFrame = widget.onLastFrame;
    if (onLastFrame == null || !_isInitialized) return;
    if (!_hasFirstFrame(_videoRenderer.value)) return;

    if (kIsWeb) {
      // The web video is an HTML element, invisible to a layer snapshot. It
      // is read unmirrored, so the mirroring is applied when it is drawn.
      final mirror = widget.mirror;
      captureElementFrame(_videoRenderer.textureId).then(
        (image) {
          if (image != null) {
            onLastFrame(LastVideoFrame(image: image, mirror: mirror));
          }
        },
        onError: (Object e) =>
            debugPrint('VideoTrackRenderer: last frame capture failed, $e'),
      );
      return;
    }

    final boundary = _boundaryKey.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary || !boundary.hasSize) return;

    final ui.Image image;
    try {
      final pixelRatio = MediaQuery.maybeDevicePixelRatioOf(context) ?? 1;
      image = boundary.toImageSync(pixelRatio: pixelRatio);
    } catch (e) {
      debugPrint('VideoTrackRenderer: last frame capture failed, $e');
      return;
    }

    // The snapshot is taken as painted, so mirroring is already applied.
    onLastFrame(LastVideoFrame(image: image));
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
        final video = RepaintBoundary(
          key: _boundaryKey,
          child: rtc.RTCVideoView(
            _videoRenderer,
            mirror: widget.mirror,
            objectFit: _getVideoViewObjectFit(videoFit, value),
            filterQuality: FilterQuality.medium,
          ),
        );
        if (_hasFirstFrame(value)) return video;

        // The video stays in the tree so it can load, covered until it has a
        // frame to show.
        return Stack(
          fit: StackFit.expand,
          children: [video, widget.placeholderBuilder(context)],
        );
      },
    );
  }

  /// Whether the renderer has a decoded frame to show.
  ///
  /// On the web [rtc.RTCVideoValue.renderVideo] turns true as soon as a stream
  /// is attached, before its first frame; the video size is only known once
  /// one is.
  bool _hasFirstFrame(rtc.RTCVideoValue value) =>
      value.renderVideo && value.width > 0 && value.height > 0;

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
