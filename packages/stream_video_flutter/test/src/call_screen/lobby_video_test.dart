import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

class _MockStreamVideo extends Mock implements StreamVideo {}

class _MockNativeFactory extends Mock
    implements rtc.NativePeerConnectionFactory {}

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  _FakeMediaStreamTrack(this.kind);

  @override
  final String kind;

  @override
  String get id => '$kind-track';

  @override
  String get label => kind;

  @override
  bool enabled = true;

  @override
  bool? get muted => false;

  int stopCount = 0;

  @override
  Future<void> stop() async => stopCount++;
}

class _FakeMediaStream extends Fake implements rtc.MediaStream {
  _FakeMediaStream(this.track);

  final _FakeMediaStreamTrack track;

  @override
  String get id => 'stream';

  @override
  List<rtc.MediaStreamTrack> getTracks() => [track];

  @override
  List<rtc.MediaStreamTrack> getAudioTracks() =>
      track.kind == 'audio' ? [track] : [];

  @override
  List<rtc.MediaStreamTrack> getVideoTracks() =>
      track.kind == 'video' ? [track] : [];

  @override
  Future<void> dispose() async {}
}

void main() {
  late MockCall call;
  late MockStateEmitter<CallState> callStateEmitter;
  late MockCallState callState;
  late _MockStreamVideo streamVideo;
  late _MockNativeFactory nativeFactory;

  /// The media kinds requested from the native factory, in order.
  late List<String> requestedKinds;

  /// Answers each getUserMedia request; by default with a fresh track.
  late Future<rtc.MediaStream> Function(String kind) answer;

  void givenDefaults({required bool mic, required bool camera}) {
    when(() => callState.settings).thenReturn(
      CallSettings(
        audio: StreamAudioSettings(micDefaultOn: mic),
        video: StreamVideoSettings(cameraDefaultOn: camera),
      ),
    );
  }

  setUp(() {
    call = MockCall();
    callStateEmitter = MockStateEmitter<CallState>();
    callState = MockCallState();
    streamVideo = _MockStreamVideo();
    nativeFactory = _MockNativeFactory();
    requestedKinds = [];
    answer = (kind) async => _FakeMediaStream(_FakeMediaStreamTrack(kind));

    when(() => call.state).thenReturn(callStateEmitter);
    when(() => callStateEmitter.value).thenReturn(callState);
    when(call.ensureNativeFactory).thenAnswer((_) async => nativeFactory);
    when(() => nativeFactory.factoryId).thenReturn('factory');
    when(() => nativeFactory.getUserMedia(any())).thenAnswer((invocation) {
      final constraints =
          invocation.positionalArguments.first as Map<String, dynamic>;
      final kind = constraints['audio'] != null && constraints['audio'] != false
          ? 'audio'
          : 'video';
      requestedKinds.add(kind);
      return answer(kind);
    });
    when(() => streamVideo.currentUser).thenReturn(
      const UserInfo(id: 'user', name: 'User'),
    );
  });

  Future<void> pumpPreview(
    WidgetTester tester, {
    bool? initialMicrophoneEnabled,
    bool? initialCameraEnabled,
    void Function(RtcLocalAudioTrack?)? onMicrophoneTrackSet,
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        child: StreamLobbyVideo(
          call: call,
          streamVideo: streamVideo,
          initialMicrophoneEnabled: initialMicrophoneEnabled,
          initialCameraEnabled: initialCameraEnabled,
          onMicrophoneTrackSet: onMicrophoneTrackSet,
        ),
      ),
    );
    // The defaults are applied from a zero-delay timer after mounting.
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump();
  }

  group('StreamLobbyVideo initial microphone and camera state', () {
    testWidgets('follows the call defaults when not overridden', (
      tester,
    ) async {
      givenDefaults(mic: true, camera: false);

      await pumpPreview(tester);

      expect(requestedKinds, ['audio']);
    });

    testWidgets('an override of false beats the call defaults', (
      tester,
    ) async {
      givenDefaults(mic: true, camera: true);

      await pumpPreview(
        tester,
        initialMicrophoneEnabled: false,
        initialCameraEnabled: false,
      );

      expect(requestedKinds, isEmpty);
    });

    testWidgets('an override of true beats the call defaults', (
      tester,
    ) async {
      givenDefaults(mic: false, camera: false);
      // The camera request fails so no video renderer is needed; that it was
      // made is what this test is about.
      answer = (kind) async => kind == 'audio'
          ? _FakeMediaStream(_FakeMediaStreamTrack(kind))
          : throw Exception('no camera in tests');

      await pumpPreview(
        tester,
        initialMicrophoneEnabled: true,
        initialCameraEnabled: true,
      );

      expect(requestedKinds, unorderedEquals(['audio', 'video']));
    });
  });

  group('StreamLobbyVideo removed while a track is starting', () {
    testWidgets('stops the track instead of handing it out', (tester) async {
      givenDefaults(mic: true, camera: false);
      final pending = Completer<rtc.MediaStream>();
      answer = (_) => pending.future;
      final handedOut = <RtcLocalAudioTrack?>[];

      await pumpPreview(tester, onMicrophoneTrackSet: handedOut.add);
      expect(requestedKinds, ['audio']);

      await tester.pumpWidget(const TestWrapper(child: SizedBox()));

      final track = _FakeMediaStreamTrack('audio');
      pending.complete(_FakeMediaStream(track));
      await tester.pump();

      expect(handedOut, isEmpty);
      expect(track.stopCount, 1);
    });
  });
}
