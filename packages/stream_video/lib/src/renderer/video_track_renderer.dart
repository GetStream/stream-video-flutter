import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../stream_video.dart';

Widget _defaultPlaceholderBuilder(BuildContext context) => const Placeholder();

/// Widget that renders a single video track based.
class VideoTrackRenderer extends StatelessWidget {
  /// Creates a new instance of [VideoTrackRenderer].
  const VideoTrackRenderer({
    super.key,
    required this.call,
    required this.participant,
    required this.videoTrackType,
    this.placeholderBuilder = _defaultPlaceholderBuilder,
  });

  /// Represents a call.
  final Call call;

  /// The participant who is publishing the track.
  final CallParticipantState participant;

  /// The type of video track to display.
  final SfuTrackTypeVideo videoTrackType;

  /// A builder for the placeholder.
  final WidgetBuilder placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    final trackState = participant.publishedTracks[videoTrackType];

    // Haven't published video track yet.
    if (trackState == null) {
      return placeholderBuilder.call(context);
    }

    Widget buildRtcVideoView() {
      final track = call.getTrack(
        participant.trackIdPrefix,
        videoTrackType,
      )!;

      if (trackState.muted) return placeholderBuilder.call(context);

      return VideoRenderer(
        track: track,
        mirror: participant.isLocal,
        placeholderBuilder: placeholderBuilder,
      );
    }

    if (trackState is! RemoteTrackState) {
      return buildRtcVideoView();
    }

    final Widget child;
    if (trackState.received && !trackState.muted) {
      child = buildRtcVideoView();
    } else {
      child = placeholderBuilder.call(context);
    }
    return _SizeChangedLayoutNotifier(
      onSizeChanged: (size) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          call.apply(
            UpdateSubscription(
              userId: participant.userId,
              sessionId: participant.sessionId,
              trackIdPrefix: participant.trackIdPrefix,
              trackType: videoTrackType,
              videoDimension: RtcVideoDimension(
                width: size.width.toInt(),
                height: size.height.toInt(),
              ),
            ),
          );
        });
      },
      child: child,
    );
  }
}

class VideoRenderer extends StatefulWidget {
  const VideoRenderer({
    super.key,
    required this.track,
    this.mirror = false,
    this.placeholderBuilder,
  });

  final RtcTrack track;
  final bool mirror;
  final WidgetBuilder? placeholderBuilder;

  @override
  State<VideoRenderer> createState() => _VideoRendererState();
}

class _VideoRendererState extends State<VideoRenderer> {
  /// Renderer to display WebRTC video stream.
  final _videoRenderer = rtc.RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    (() async {
      await _videoRenderer.initialize();
      _videoRenderer.srcObject = widget.track.mediaStream;
      setState(() {});
    })();
  }

  @override
  void didUpdateWidget(covariant VideoRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.track != oldWidget.track) {
      _videoRenderer.srcObject = widget.track.mediaStream;
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
    return rtc.RTCVideoView(
      _videoRenderer,
      mirror: widget.mirror,
      /*placeholderBuilder: widget.placeholderBuilder,*/
    );
  }
}

typedef OnSizeChanged = void Function(Size size);

class _SizeChangedLayoutNotifier extends SingleChildRenderObjectWidget {
  const _SizeChangedLayoutNotifier({
    super.key,
    super.child,
    this.onSizeChanged,
  });

  final OnSizeChanged? onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSizeChangedWithCallback(
      onSizeChanged: (size) {
        onSizeChanged?.call(size);
      },
    );
  }
}

class _RenderSizeChangedWithCallback extends RenderProxyBox {
  _RenderSizeChangedWithCallback({
    RenderBox? child,
    required this.onSizeChanged,
  }) : super(child);

  // There's a 1:1 relationship between the _RenderSizeChangedWithCallback and
  // the `context` that is captured by the closure created by createRenderObject
  // above to assign to onLayoutChangedCallback, and thus we know that the
  // onLayoutChangedCallback will never change nor need to change.

  final OnSizeChanged onSizeChanged;

  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      onSizeChanged.call(size);
    }
    _oldSize = size;
  }
}
