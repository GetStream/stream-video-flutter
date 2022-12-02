import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

enum VideoViewMirrorMode {
  auto,
  off,
  mirror,
}

/// Widget that renders a [VideoTrack].
class VideoTrackRenderer extends StatefulWidget {
  final VideoTrack track;
  final rtc.RTCVideoViewObjectFit fit;
  final VideoViewMirrorMode mirrorMode;

  const VideoTrackRenderer(
    this.track, {
    this.fit = rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    this.mirrorMode = VideoViewMirrorMode.auto,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoTrackRendererState();
}

class _VideoTrackRendererState extends State<VideoTrackRenderer> {
  final _renderer = rtc.RTCVideoRenderer();

  bool _rendererReady = false;

  @override
  void initState() {
    super.initState();
    (() async {
      await _renderer.initialize();
      await Future.microtask(() => _attach());
      setState(() => _rendererReady = true);
    })();
  }

  @override
  void dispose() {
    _renderer.srcObject = null;
    _renderer.dispose();
    super.dispose();
  }

  void _attach() {
    _renderer.srcObject = widget.track.mediaStream;
  }

  @override
  void didUpdateWidget(covariant VideoTrackRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.track != widget.track) {
      _attach();
    }
  }

  @override
  Widget build(BuildContext context) => !_rendererReady
      ? const Center(
          child: Text('Loading...'),
        )
      : Builder(
          builder: (ctx) {
            return rtc.RTCVideoView(
              _renderer,
              mirror: _shouldMirror(),
              filterQuality: FilterQuality.medium,
              objectFit: widget.fit,
            );
          },
        );

  bool _shouldMirror() {
    // on
    if (widget.mirrorMode == VideoViewMirrorMode.mirror) return true;
    // auto
    if (widget.mirrorMode == VideoViewMirrorMode.auto) {
      final track = widget.track;
      if (track is LocalVideoTrack) {
        final options = track.currentOptions;
        if (options is CameraCaptureOptions) {
          // mirror if front camera
          return options.cameraPosition == CameraPosition.front;
        }
      }
    }
    // default to false
    return false;
  }
}
