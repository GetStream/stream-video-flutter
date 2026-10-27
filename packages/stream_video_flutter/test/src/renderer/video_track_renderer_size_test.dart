import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/src/renderer/rendered_video_sizes.dart';
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
    RenderedVideoSizes.instance.debugReset();
  });

  Future<void> pumpRenderer(
    WidgetTester tester, {
    required Size viewSize,
    required Size videoSize,
    int rotation = 0,
  }) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox.fromSize(
            size: viewSize,
            child: VideoTrackRenderer(videoTrack: track),
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
    if (rotation != 0) {
      textureEvents!.success({
        'event': 'didTextureChangeRotation',
        'rotation': rotation,
      });
    }
    // The mock event channel delivers on a real async gap, not a microtask.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
  }

  const portraitView = Size(200, 400);
  const landscapeVideo = Size(1920, 1080);
  const portraitVideo = Size(1080, 1920);

  group('VideoTrackRenderer reports its video size', () {
    testWidgets('as the frames arrive', (tester) async {
      await pumpRenderer(
        tester,
        viewSize: portraitView,
        videoSize: landscapeVideo,
      );

      expect(RenderedVideoSizes.instance.sizeOf('alice:video'), landscapeVideo);
    });

    testWidgets('with the rotation applied', (tester) async {
      await pumpRenderer(
        tester,
        viewSize: portraitView,
        videoSize: landscapeVideo,
        rotation: 90,
      );

      expect(RenderedVideoSizes.instance.sizeOf('alice:video'), portraitVideo);
    });

    testWidgets('across a new track with the same id', (tester) async {
      await pumpRenderer(
        tester,
        viewSize: portraitView,
        videoSize: landscapeVideo,
      );

      final replacement = _MockRtcTrack();
      final replacementStream = _MockMediaStream();
      when(() => replacementStream.id).thenReturn('replacement-stream');
      when(() => replacementStream.ownerTag).thenReturn('remote');
      when(() => replacement.mediaStream).thenReturn(replacementStream);
      when(() => replacement.trackId).thenReturn('alice:video');
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox.fromSize(
              size: portraitView,
              child: VideoTrackRenderer(videoTrack: replacement),
            ),
          ),
        ),
      );

      expect(RenderedVideoSizes.instance.sizeOf('alice:video'), landscapeVideo);
    });

    testWidgets('only under the id of the track it shows', (tester) async {
      await pumpRenderer(
        tester,
        viewSize: portraitView,
        videoSize: landscapeVideo,
      );

      final other = _MockRtcTrack();
      final otherStream = _MockMediaStream();
      when(() => otherStream.id).thenReturn('other-stream');
      when(() => otherStream.ownerTag).thenReturn('remote');
      when(() => other.mediaStream).thenReturn(otherStream);
      when(() => other.trackId).thenReturn('bob:video');
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox.fromSize(
              size: portraitView,
              child: VideoTrackRenderer(videoTrack: other),
            ),
          ),
        ),
      );
      // Let the new stream be set, which must not report the old size.
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();

      expect(RenderedVideoSizes.instance.sizeOf('alice:video'), isNull);
      expect(RenderedVideoSizes.instance.sizeOf('bob:video'), isNull);
    });

    testWidgets('with where it is drawn', (tester) async {
      await pumpRenderer(
        tester,
        viewSize: portraitView,
        videoSize: landscapeVideo,
      );

      // Centred in the test view, at the size it was given.
      final rect = RenderedVideoSizes.instance.screenRectOf('alice:video');
      expect(rect?.size, portraitView);
      expect(
        rect?.center,
        Offset(
              tester.view.physicalSize.width,
              tester.view.physicalSize.height,
            ) /
            tester.view.devicePixelRatio /
            2,
      );
    });

    testWidgets('until it is removed', (tester) async {
      await pumpRenderer(
        tester,
        viewSize: portraitView,
        videoSize: landscapeVideo,
      );

      await tester.pumpWidget(const SizedBox.shrink());

      expect(RenderedVideoSizes.instance.sizeOf('alice:video'), isNull);
    });
  });
}
