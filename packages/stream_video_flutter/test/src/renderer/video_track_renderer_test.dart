import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../mocks.dart';

class _MockMediaStream extends Mock implements rtc.MediaStream {}

const _textureId = 1;

void main() {
  const methodChannel = MethodChannel('FlutterWebRTC.Method');
  const textureChannel = MethodChannel('FlutterWebRTC/Texture$_textureId');

  late Completer<void> createRenderer;
  late List<MethodCall> calls;

  setUp(() {
    createRenderer = Completer<void>();
    calls = [];

    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(methodChannel, (call) async {
      calls.add(call);
      if (call.method == 'createVideoRenderer') {
        await createRenderer.future;
        return {'textureId': _textureId};
      }
      return null;
    });
    // The renderer listens to its texture's event channel once created.
    messenger.setMockMethodCallHandler(textureChannel, (_) async => null);
  });

  tearDown(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(methodChannel, null);
    messenger.setMockMethodCallHandler(textureChannel, null);
  });

  RtcLocalVideoTrack track(String streamId) {
    final stream = _MockMediaStream();
    when(() => stream.id).thenReturn(streamId);
    when(() => stream.ownerTag).thenReturn('local');

    final track = MockRtcLocalVideoTrack();
    when(() => track.mediaStream).thenReturn(stream);
    return track;
  }

  // Platform messages complete outside the test's fake clock.
  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
  }

  // Unmounts and lets the disposal's platform calls land in this test.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  }

  List<String> setStreamIds() => [
    for (final call in calls)
      if (call.method == 'videoRendererSetSrcObject')
        (call.arguments as Map)['streamId'] as String,
  ];

  testWidgets(
    'sets the latest track once initialised when the track changes before',
    (tester) async {
      await tester.pumpWidget(VideoTrackRenderer(videoTrack: track('first')));

      // A migration replaces the track while the renderer is still being
      // created on the platform side.
      await tester.pumpWidget(VideoTrackRenderer(videoTrack: track('second')));
      expect(tester.takeException(), isNull);

      createRenderer.complete();
      await settle(tester);

      expect(tester.takeException(), isNull);
      expect(setStreamIds(), ['second']);

      await unmount(tester);
    },
  );

  testWidgets('sets a changed track once initialised', (tester) async {
    createRenderer.complete();
    await tester.pumpWidget(VideoTrackRenderer(videoTrack: track('first')));
    await settle(tester);

    await tester.pumpWidget(VideoTrackRenderer(videoTrack: track('second')));
    await settle(tester);

    expect(tester.takeException(), isNull);
    expect(setStreamIds(), ['first', 'second']);

    await unmount(tester);
  });

  testWidgets(
    'releases the renderer without setting a stream when disposed before '
    'initialisation finishes',
    (tester) async {
      await tester.pumpWidget(VideoTrackRenderer(videoTrack: track('first')));
      await tester.pumpWidget(const SizedBox());

      createRenderer.complete();
      await settle(tester);

      expect(tester.takeException(), isNull);
      expect(setStreamIds(), isEmpty);
      expect(
        calls.where((call) => call.method == 'videoRendererDispose'),
        hasLength(1),
      );
    },
  );
}
