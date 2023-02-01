import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../../stream_video.dart';

Widget _defaultPlaceholderBuilder(BuildContext context) => const Placeholder();

class VideoTrackRenderer extends StatelessWidget {
  const VideoTrackRenderer({
    super.key,
    required this.call,
    required this.participant,
    this.placeholderBuilder = _defaultPlaceholderBuilder,
  });

  final CallV2 call;
  final CallParticipantStateV2 participant;
  final WidgetBuilder placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    final userId = participant.userId;
    final trackState = participant.publishedTracks[SfuTrackType.video];
    print('(D/SV:ParticipantView) [buildRtcVideoView] userId: $userId, '
        'trackState: $trackState');

    // Haven't published video track yet.
    if (trackState == null) {
      return placeholderBuilder.call(context);
    }

    final isLocalParticipant = participant.isLocal;

    Widget buildRtcVideoView() {
      final track = call.getTrack(
        participant.trackIdPrefix,
        SfuTrackType.video,
      )!;

      print('(D/SV:ParticipantView) [buildRtcVideoView] userId: $userId, '
          'trackState.muted: ${trackState.muted}');

      if (trackState.muted) return placeholderBuilder.call(context);

      return VideoRenderer(
        track: track,
        mirror: isLocalParticipant,
        placeholderBuilder: placeholderBuilder,
      );
    }

    if (isLocalParticipant) {
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
        print('(D/SV:VideoTrackRenderer) [build] size: $size');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          call.apply(
            UpdateSubscription(
              userId: participant.userId,
              sessionId: participant.sessionId,
              trackIdPrefix: participant.trackIdPrefix,
              trackType: SfuTrackType.video,
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
      _videoRenderer.srcObject = widget.track.stream;
      setState(() {});
    })();
  }

  @override
  void didUpdateWidget(covariant VideoRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.track != oldWidget.track) {
      _videoRenderer.srcObject = widget.track.stream;
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
      placeholderBuilder: widget.placeholderBuilder,
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
