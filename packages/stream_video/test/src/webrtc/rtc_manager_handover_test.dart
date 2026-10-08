// ignore_for_file: missing_override_of_must_be_overridden

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../test_helpers.dart';
import '../call/fixtures/data.dart';

class _MockTracedPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class _MockStreamPeerConnectionFactory extends Mock
    implements StreamPeerConnectionFactory {}

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  _FakeMediaStreamTrack({this.enabled = true});

  int stopCallCount = 0;

  @override
  bool enabled;

  @override
  Future<void> stop() async {
    stopCallCount++;
  }
}

class _FakeMediaStream extends Fake implements rtc.MediaStream {
  int disposeCallCount = 0;

  @override
  Future<void> dispose() async {
    disposeCallCount++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RtcManager rtcManager;

  setUp(() {
    final streamVideo = MockCallHost();
    when(() => streamVideo.options).thenReturn(
      StreamVideoOptions(clientEventsReportingEnabled: false),
    );

    final subscriber = _MockTracedPeerConnection();
    when(subscriber.dispose).thenAnswer((_) async {});

    rtcManager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: null,
      subscriber: subscriber,
      publishOptions: [],
      stateManager: MockCallStateNotifier(),
      streamVideo: streamVideo,
      pcFactory: _MockStreamPeerConnectionFactory(),
    );
  });

  ({
    _FakeMediaStreamTrack primary,
    _FakeMediaStreamTrack clone,
    _FakeMediaStream stream,
  })
  addCameraTrack({bool enabled = true}) {
    final primary = _FakeMediaStreamTrack(enabled: enabled);
    final clone = _FakeMediaStreamTrack(enabled: enabled);
    final stream = _FakeMediaStream();
    final track = RtcLocalCameraTrack(
      trackIdPrefix: 'test-publisher',
      trackType: SfuTrackType.video,
      mediaStream: stream,
      mediaTrack: primary,
      mediaConstraints: const CameraConstraints(),
      clonedTracks: [clone],
    );
    rtcManager.tracks[track.trackId] = track;
    return (primary: primary, clone: clone, stream: stream);
  }

  test('hands over a live track with the local prefix and no clones', () {
    final camera = addCameraTrack();

    final handedOver = rtcManager.handOverLocalTracks();

    expect(handedOver, hasLength(1));
    final track = handedOver.single;
    expect(track.trackIdPrefix, kLocalTrackIdPrefix);
    expect(track.trackType, SfuTrackType.video);
    expect(track.mediaTrack, same(camera.primary));
    expect(track.mediaStream, same(camera.stream));
    expect(track.clonedTracks, isEmpty);
    // The old senders keep sending until the manager is disposed.
    expect(rtcManager.tracks, hasLength(1));
  });

  test(
    'dispose after a handover stops only the clones, not the track the next '
    'session publishes',
    () async {
      final camera = addCameraTrack();
      rtcManager.handOverLocalTracks();

      await rtcManager.dispose();

      expect(camera.clone.stopCallCount, 1);
      expect(camera.primary.stopCallCount, 0);
      expect(camera.stream.disposeCallCount, 0);
    },
  );

  test('a muted track is not handed over and dispose stops it', () async {
    final camera = addCameraTrack(enabled: false);

    expect(rtcManager.handOverLocalTracks(), isEmpty);

    await rtcManager.dispose();

    expect(camera.primary.stopCallCount, 1);
    expect(camera.clone.stopCallCount, 1);
    expect(camera.stream.disposeCallCount, 1);
  });

  test(
    'a track recreated after the handover is stopped in full on dispose',
    () async {
      addCameraTrack();
      rtcManager.handOverLocalTracks();
      // A recreate that finishes after the handover stores a new capture
      // under the same id; this manager is the only one holding it.
      final recreated = _FakeMediaStreamTrack();
      final recreatedStream = _FakeMediaStream();
      final trackId = rtcManager.tracks.keys.single;
      rtcManager.tracks[trackId] =
          (rtcManager.tracks[trackId]! as RtcLocalCameraTrack).copyWith(
            mediaTrack: recreated,
            mediaStream: recreatedStream,
            clonedTracks: const [],
          );

      await rtcManager.dispose();

      expect(recreated.stopCallCount, 1);
      expect(recreatedStream.disposeCallCount, 1);
    },
  );

  test('a second handover returns nothing', () {
    addCameraTrack();

    rtcManager.handOverLocalTracks();

    expect(rtcManager.handOverLocalTracks(), isEmpty);
  });
}
