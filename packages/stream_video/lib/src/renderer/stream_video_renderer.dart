import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stream_video/src/event_emitter.dart';
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/internal/events.dart';
import 'package:stream_video/src/track/local/video.dart';
import 'package:stream_video/src/track/options.dart';
import 'package:stream_video/src/track/track.dart';

/// Video mirror mode.
enum MirrorMode {
  /// Enables the mirror mode.
  enabled,

  /// Disables the mirror mode.
  disabled,

  /// The mirror mode is determined by the SDK.
  auto,
}

/// Options for scaling the bounds of a video.
enum VideoFit {
  /// Center the video in the widget, but perform no scaling.
  contain,

  /// Scale the video uniformly (maintain the video's aspect ratio)
  /// to cover the entire widget area.
  cover,
}

/// {@template streamVideoRenderer}
/// Widget that renders a single [VideoTrack].
/// {@endtemplate}
class StreamVideoRenderer extends StatefulWidget {
  /// {@macro streamVideoRenderer}
  const StreamVideoRenderer({
    super.key,
    required this.videoTrack,
    this.videoFit = VideoFit.cover,
    this.mirrorMode = MirrorMode.auto,
  });

  /// The video track to display.
  final VideoTrack videoTrack;

  /// The scale type of the video.
  final VideoFit videoFit;

  /// The video mirror mode.
  final MirrorMode mirrorMode;

  @override
  State<StatefulWidget> createState() => _StreamVideoRendererState();
}

class _StreamVideoRendererState extends State<StreamVideoRenderer> {
  /// Renderer to display WebRTC video stream.
  final _videoRenderer = rtc.RTCVideoRenderer();

  /// If we are ready to display the video stream.
  bool _isRendererReady = false;

  /// A unique key used to update video dimensions.
  late GlobalKey _viewKey;

  /// Listener for the track events.
  EventListener<TrackEvent>? _trackEventListener;

  /// The video track to display.
  VideoTrack get _videoTrack => widget.videoTrack;

  @override
  void initState() {
    super.initState();
    _viewKey = _videoTrack.addViewKey();

    (() async {
      await _videoRenderer.initialize();
      _attachVideoTrack();
      setState(() => _isRendererReady = true);
    })();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRendererReady) return Container();

    return NotificationListener(
      onNotification: (SizeChangedLayoutNotification notification) {
        // Let it render before notifying size change.
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _videoTrack.onVideoViewSizeChange?.call(_viewKey);
        });
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Builder(
          key: _viewKey,
          builder: (context) {
            // Let it render before notifying build.
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _videoTrack.onVideoViewBuild?.call(_viewKey);
            });
            return rtc.RTCVideoView(
              _videoRenderer,
              mirror: _isVideoMirrored(),
              filterQuality: FilterQuality.medium,
              objectFit: _getVideoViewObjectFit(widget.videoFit),
            );
          },
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant StreamVideoRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_videoTrack != oldWidget.videoTrack) {
      oldWidget.videoTrack.removeViewKey(_viewKey);
      _viewKey = _videoTrack.addViewKey();
      _attachVideoTrack();
    }
  }

  @override
  void dispose() async {
    _videoTrack.removeViewKey(_viewKey);
    _trackEventListener?.dispose();
    _videoRenderer.srcObject = null;
    await _videoRenderer.dispose();
    super.dispose();
  }

  void _attachVideoTrack() {
    _videoRenderer.srcObject = _videoTrack.mediaStream;

    _trackEventListener?.dispose();
    _trackEventListener = _videoTrack.events.createListener()
      ..on<TrackStreamUpdatedEvent>((event) {
        if (!mounted) return;
        _videoRenderer.srcObject = event.stream;
      })
      ..on<LocalTrackOptionsUpdatedEvent>((event) {
        if (!mounted) return;
        // Reevaluate mirror mode.
        setState(() {});
      });
  }

  /// Maps the [VideoFit] values to [RTCVideoViewObjectFit] values.
  RTCVideoViewObjectFit _getVideoViewObjectFit(VideoFit videoFit) {
    switch (videoFit) {
      case VideoFit.cover:
        return RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;
      case VideoFit.contain:
        return RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
    }
  }

  /// If the video should be mirrored.
  bool _isVideoMirrored() {
    switch (widget.mirrorMode) {
      case MirrorMode.enabled:
        return true;
      case MirrorMode.disabled:
        return false;
      case MirrorMode.auto:
        final videoTrack = _videoTrack;
        if (videoTrack is LocalVideoTrack) {
          final currentOptions = videoTrack.currentOptions;
          if (currentOptions is CameraCaptureOptions) {
            return currentOptions.cameraPosition == CameraPosition.front;
          }
        }
    }
    return false;
  }
}
