import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

class _MockRtcTrack extends Mock implements RtcTrack {}

class _MockMediaStream extends Mock implements rtc.MediaStream {}

const _textureId = 7;
const _methodChannel = MethodChannel('FlutterWebRTC.Method');
const _textureChannel = EventChannel('FlutterWebRTC/Texture$_textureId');

void main() {
  late RtcTrack track;
  MockStreamHandlerEventSink? textureEvents;

  setUp(() {
    final stream = _MockMediaStream();
    when(() => stream.id).thenReturn('stream');
    when(() => stream.ownerTag).thenReturn('remote');
    track = _MockRtcTrack();
    when(() => track.mediaStream).thenReturn(stream);
    when(() => track.trackId).thenReturn('alice:video');

    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(_methodChannel, (call) async {
      if (call.method == 'createVideoRenderer') {
        return {'textureId': _textureId};
      }
      return null;
    });
    messenger.setMockStreamHandler(
      _textureChannel,
      MockStreamHandler.inline(
        onListen: (_, sink) {
          textureEvents = sink;
        },
        onCancel: (_) {
          textureEvents = null;
        },
      ),
    );
  });

  tearDown(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(_methodChannel, null);
    messenger.setMockStreamHandler(_textureChannel, null);
  });

  Future<void> pumpRenderer(
    WidgetTester tester, {
    required Size viewSize,
    required Size videoSize,
    VideoFit videoFit = VideoFit.adaptive,
  }) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox.fromSize(
            size: viewSize,
            child: VideoTrackRenderer(videoTrack: track, videoFit: videoFit),
          ),
        ),
      ),
    );
    // Let initialize() resolve and the texture channel subscribe.
    await tester.pump();
    await tester.pump();

    textureEvents!.success({
      'event': 'didTextureChangeVideoSize',
      'width': videoSize.width,
      'height': videoSize.height,
    });
    // The mock event channel delivers on a real async gap, not a microtask.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
  }

  rtc.RTCVideoViewObjectFit objectFit(WidgetTester tester) =>
      tester.widget<rtc.RTCVideoView>(find.byType(rtc.RTCVideoView)).objectFit;

  const portraitView = Size(200, 400);
  const landscapeView = Size(400, 200);
  const landscapeVideo = Size(1920, 1080);
  const portraitVideo = Size(1080, 1920);

  group('VideoTrackRenderer with adaptive', () {
    testWidgets('letterboxes a landscape feed in a portrait view', (
      tester,
    ) async {
      await pumpRenderer(
        tester,
        viewSize: portraitView,
        videoSize: landscapeVideo,
      );

      expect(
        objectFit(tester),
        rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
      );
    });

    testWidgets('fills a landscape view with a landscape feed', (
      tester,
    ) async {
      await pumpRenderer(
        tester,
        viewSize: landscapeView,
        videoSize: landscapeVideo,
      );

      expect(
        objectFit(tester),
        rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      );
    });

    testWidgets('fills a portrait view with a portrait feed', (tester) async {
      await pumpRenderer(
        tester,
        viewSize: portraitView,
        videoSize: portraitVideo,
      );

      expect(
        objectFit(tester),
        rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      );
    });

    testWidgets('letterboxes a portrait feed in a landscape view', (
      tester,
    ) async {
      await pumpRenderer(
        tester,
        viewSize: landscapeView,
        videoSize: portraitVideo,
      );

      expect(
        objectFit(tester),
        rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
      );
    });
  });

  testWidgets('switching fits keeps the same video view element', (
    tester,
  ) async {
    await pumpRenderer(
      tester,
      viewSize: portraitView,
      videoSize: landscapeVideo,
      videoFit: VideoFit.contain,
    );
    final before = tester.element(find.byType(rtc.RTCVideoView));

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox.fromSize(
            size: portraitView,
            child: VideoTrackRenderer(
              videoTrack: track,
              videoFit: VideoFit.adaptive,
            ),
          ),
        ),
      ),
    );

    expect(tester.element(find.byType(rtc.RTCVideoView)), same(before));
  });
}
