import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/src/event_emitter.dart';
import 'package:stream_video/src/events.dart';
import 'package:stream_video/src/internal/events.dart';
import 'package:stream_video/src/track/local/video.dart';
import 'package:stream_video/src/track/options.dart';
import 'package:stream_video/src/track/track.dart';

enum VideoViewMirrorMode {
  auto,
  off,
  mirror,
}

/// Widget that renders a [VideoTrack].
class VideoTrackRenderer extends StatefulWidget {
  const VideoTrackRenderer(
    this.track, {
    super.key,
    this.fit = rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    this.mirrorMode = VideoViewMirrorMode.auto,
  });

  final VideoTrack track;
  final rtc.RTCVideoViewObjectFit fit;
  final VideoViewMirrorMode mirrorMode;

  @override
  State<StatefulWidget> createState() => _VideoTrackRendererState();
}

class _VideoTrackRendererState extends State<VideoTrackRenderer> {
  final _renderer = rtc.RTCVideoRenderer();
  bool _rendererReady = false;
  // Used to compute size and visibility information
  late GlobalKey _internalKey;

  EventListener<TrackEvent>? _trackEventListener;

  @override
  void initState() {
    super.initState();
    _internalKey = widget.track.addViewKey();
    _initRenderer();
  }

  Future<void> _initRenderer() async {
    await _renderer.initialize();
    _attachTrack();
    setState(() => _rendererReady = true);
  }

  @override
  void dispose() async {
    widget.track.removeViewKey(_internalKey);
    _trackEventListener?.dispose();

    // always dispose renderer
    _renderer.srcObject = null;
    await _renderer.dispose();
    super.dispose();
  }

  void _attachTrack() {
    _renderer.srcObject = widget.track.mediaStream;

    // recreate listener
    _trackEventListener?.dispose();
    _trackEventListener = widget.track.events.createListener();

    // listen for events
    _trackEventListener!
      ..on<TrackStreamUpdatedEvent>((event) {
        if (!mounted) return;
        _renderer.srcObject = event.stream;
      })
      ..on<LocalTrackOptionsUpdatedEvent>((event) {
        if (!mounted) return;
        // force recompute of mirror mode
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant VideoTrackRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.track != oldWidget.track) {
      oldWidget.track.removeViewKey(_internalKey);
      _internalKey = widget.track.addViewKey();
      _attachTrack();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_rendererReady) return Container();
    return NotificationListener(
      onNotification: (SizeChangedLayoutNotification notification) {
        // let it render before notifying size change
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.track.onVideoViewSizeChange?.call(_internalKey);
        });
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Builder(
          key: _internalKey,
          builder: (ctx) {
            // let it render before notifying build
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              widget.track.onVideoViewBuild?.call(_internalKey);
            });
            return rtc.RTCVideoView(
              _renderer,
              mirror: _shouldMirror,
              filterQuality: FilterQuality.medium,
              objectFit: widget.fit,
            );
          },
        ),
      ),
    );
  }

  bool get _shouldMirror {
    switch (widget.mirrorMode) {
      case VideoViewMirrorMode.mirror:
        return true;
      case VideoViewMirrorMode.off:
        return false;
      case VideoViewMirrorMode.auto:
        final track = widget.track;
        if (track is LocalVideoTrack) {
          final options = track.currentOptions;
          if (options is CameraCaptureOptions) {
            // mirror if front camera
            return options.cameraPosition == CameraPosition.front;
          }
        }
    }

    return false;
  }
}
