import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/src/v2/webrtc/rtc_track.dart';
import '../../../stream_video.dart';
import '../action/call_control_action.dart';
import '../call/call.dart';
import '../call_participant_state.dart';
import '../sfu/data/models/sfu_track_type.dart';

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
    final videoTrackStatus = participant.publishedTracks[SfuTrackType.video];

    // Haven't published video track yet.
    if (videoTrackStatus == null) {
      return placeholderBuilder.call(context);
    }

    Widget buildRtcVideoView() {
      final track = call.getTrack(
        participant.trackIdPrefix,
        SfuTrackType.video,
      )!;

      if (!track.muted) {
        return VideoRenderer(
          track: track,
          placeholderBuilder: placeholderBuilder,
        );
      }

      return placeholderBuilder.call(context);
    }

    final isLocalParticipant = participant.isLocal;
    if (isLocalParticipant) {
      if (videoTrackStatus.isPublished) {
        return buildRtcVideoView();
      }

      return placeholderBuilder.call(context);
    }

    final child = videoTrackStatus.when(
      published: () => placeholderBuilder.call(context),
      subscribed: (_) => placeholderBuilder.call(context),
      received: (_) => buildRtcVideoView(),
    );

    return _SizeChangedLayoutNotifier(
      onSizeChanged: (size) {
        print('(D/SV:VideoTrackRenderer) [build] size: $size');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          call.apply(
            SubscribeTrack(
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
    _videoRenderer.srcObject = null;
    await _videoRenderer.dispose();
    super.dispose();
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
  /// Creates a [_SizeChangedLayoutNotifier] that dispatches layout changed
  /// notifications when [child] changes layout size.
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
