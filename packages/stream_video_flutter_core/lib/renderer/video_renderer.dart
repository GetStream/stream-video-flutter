import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart'
    show
        MediaStream,
        MediaStreamTrack,
        RTCVideoRenderer,
        RTCVideoView,
        RTCVideoViewObjectFit;
import 'package:stream_video/stream_video.dart';

enum VideoViewMirrorMode {
  auto,
  off,
  mirror,
}

/// Widget that renders a [VideoTrack].
class StreamVideoTrackRenderer extends StatefulWidget {
  final MediaStream track;
  final RTCVideoViewObjectFit fit;
  final VideoViewMirrorMode mirrorMode;
  final TrackController controller;
  const StreamVideoTrackRenderer({
    required this.track,
    this.fit = RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    this.mirrorMode = VideoViewMirrorMode.auto,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StreamVideoTrackRendererState();
}

class _StreamVideoTrackRendererState extends State<StreamVideoTrackRenderer> {
  final _renderer = RTCVideoRenderer();
  bool _rendererReady = false;
  // EventsListener<TrackEvent>? _listener;
  // Used to compute visibility information
  // late GlobalKey _internalKey;

  @override
  void initState() {
    super.initState();
    // _internalKey = widget.track.addViewKey();

    (() async {
      await _renderer.initialize();
      await _attach();
      setState(() => _rendererReady = true);
    })();
  }

  @override
  void dispose() {
    // widget.track.removeViewKey(_internalKey);
    // _listener?.dispose();
    _renderer.srcObject = null;
    _renderer.dispose();
    super.dispose();
  }

  Future<void> _attach() async {
    _renderer.srcObject = widget.track;
    // await _listener?.dispose();
    // _listener = widget.track.createListener()
    widget.controller.on<TrackUpdatedEvent>((event) {
      //TODO: maybe filter by
      if (!mounted) return;
      _renderer.srcObject = event.payload;
    });
    //TODO: use our events
    //   ..on<TrackStreamUpdatedEvent>((event) {
    //     if (!mounted) return;
    //     _renderer.srcObject = event.stream;
    //   })
    //   ..on<LocalTrackOptionsUpdatedEvent>((event) {
    //     if (!mounted) return;
    //     // force recompute of mirror mode
    //     setState(() {});
    //   });
  }

  @override
  void didUpdateWidget(covariant StreamVideoTrackRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    //
    // if (widget.track != oldWidget.track) {
    //   oldWidget.track.removeViewKey(_internalKey);
    //   _internalKey = widget.track.addViewKey();
    //   // TODO: re-attach only if needed
    //   (() async {
    //     await _attach();
    //   })();
    // }
  }

  @override
  Widget build(BuildContext context) => !_rendererReady
      ? Container()
      : Builder(
          // key: _internalKey,
          builder: (ctx) {
            // // let it render before notifying build
            // WidgetsBindingCompatible.instance
            //     ?.addPostFrameCallback((timeStamp) {
            //   widget.track.onVideoViewBuild?.call(_internalKey);
            // });
            // return RTCVideoView(
            //   _renderer,
            //   mirror: _shouldMirror(),
            //   filterQuality: FilterQuality.medium,
            //   objectFit: widget.fit,
            // );
            return RTCVideoView(
              _renderer,
              mirror: true, //_shouldMirror(),
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
      print("mirror mode not handled yet");
      // final track = widget.track;
      // if (track is LocalVideoTrack) {
      //   final options = track.currentOptions;
      //   if (options is CameraCaptureOptions) {
      //     // mirror if front camera
      //     return options.cameraPosition == CameraPosition.front;
      //   }
      // }
    }
    // default to false
    return false;
  }
}
