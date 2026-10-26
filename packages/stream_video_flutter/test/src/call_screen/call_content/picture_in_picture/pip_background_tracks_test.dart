import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../../test_utils/test_wrapper.dart';
import '../../../mocks.dart';

class _MockRtcTrack extends Mock implements RtcTrack {}

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  @override
  bool enabled = true;

  // Handed to the native window, which draws the track by its id.
  @override
  String? get id => 'alice-video';
}

// In the background the window turns off the tracks it isn't showing, and
// turns the same ones back on in the foreground, whatever the participants
// look like by then.

void main() {
  const channel = MethodChannel('stream_video_flutter_pip');

  late MockCall call;
  late MockCallState callState;
  late MockCallParticipantState participant;
  late MutableStateEmitter<CallState> emitter;
  late _FakeMediaStreamTrack mediaTrack;
  late List<MethodCall> nativeCalls;

  setUpAll(() {
    registerFallbackValue(SfuTrackType.video);
  });

  void publishVideo({bool subscribed = true}) {
    when(() => participant.publishedTracks).thenReturn({
      SfuTrackType.video: TrackState.remote(
        subscribed: subscribed,
        received: subscribed,
      ),
    });
  }

  setUp(() {
    ViewportVisibilityRegistry.defaultReleaseGrace = Duration.zero;

    call = MockCall();
    callState = MockCallState();
    participant = MockCallParticipantState();
    mediaTrack = _FakeMediaStreamTrack();
    nativeCalls = [];

    when(() => participant.userId).thenReturn('alice');
    when(() => participant.sessionId).thenReturn('alice-session');
    when(() => participant.trackIdPrefix).thenReturn('alice');
    when(() => participant.name).thenReturn('Alice');
    when(() => participant.image).thenReturn(null);
    when(() => participant.isLocal).thenReturn(false);
    when(() => participant.isSpeaking).thenReturn(false);
    when(() => participant.isAudioEnabled).thenReturn(true);
    when(() => participant.isVideoEnabled).thenReturn(true);
    when(() => participant.isScreenShareEnabled).thenReturn(false);
    when(() => participant.screenShareTrack).thenReturn(null);
    when(
      () => participant.connectionQuality,
    ).thenReturn(SfuConnectionQuality.excellent);
    publishVideo();

    when(() => callState.status).thenReturn(CallStatus.connected());
    when(() => callState.callParticipants).thenReturn([participant]);
    when(() => callState.localParticipant).thenReturn(null);
    when(() => callState.iOSMultitaskingCameraAccessEnabled).thenReturn(true);

    emitter = MutableStateEmitter<CallState>(callState, sync: true);
    when(() => call.state).thenAnswer((_) => emitter);
    when(
      () => call.participantsStream,
    ).thenAnswer((_) => emitter.map((state) => state.callParticipants));

    final track = _MockRtcTrack();
    when(() => track.mediaTrack).thenReturn(mediaTrack);
    when(() => call.getTrack(any(), any())).thenAnswer((invocation) {
      final [prefix, type] = invocation.positionalArguments;
      return prefix == 'alice' && type == SfuTrackType.video ? track : null;
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
          nativeCalls.add(methodCall);
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  Future<void> pumpPip(
    WidgetTester tester, {
    bool includeLocalParticipantVideo = true,
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        child: StreamPictureInPictureUiKitView(
          call: call,
          pictureInPictureConfiguration: PictureInPictureConfiguration(
            enablePictureInPicture: true,
            iOSPiPConfiguration: IOSPictureInPictureConfiguration(
              includeLocalParticipantVideo: includeLocalParticipantVideo,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> background(WidgetTester tester) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    // Past the delay backgrounding schedules to re-check the call status.
    await tester.pump(const Duration(milliseconds: 200));
  }

  Future<void> foreground(WidgetTester tester) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
  }

  testWidgets('turns a track off in the background and on again after', (
    tester,
  ) async {
    await pumpPip(tester);

    await background(tester);
    expect(mediaTrack.enabled, isFalse);

    await foreground(tester);
    expect(mediaTrack.enabled, isTrue);
  });

  testWidgets('turns a track on again when its subscription lapsed', (
    tester,
  ) async {
    await pumpPip(tester);
    await background(tester);

    publishVideo(subscribed: false);
    await foreground(tester);

    expect(mediaTrack.enabled, isTrue);
  });

  testWidgets('turns a track on again when its camera was off on resume', (
    tester,
  ) async {
    await pumpPip(tester);
    await background(tester);

    // Turned off in the background, and back on after the app returns.
    when(() => participant.isVideoEnabled).thenReturn(false);
    await foreground(tester);

    expect(mediaTrack.enabled, isTrue);
  });

  testWidgets('leaves alone a track that was already off', (tester) async {
    // The local camera, left out of the window, so it is never shown there.
    when(() => participant.isLocal).thenReturn(true);
    mediaTrack.enabled = false;
    await pumpPip(tester, includeLocalParticipantVideo: false);

    await background(tester);
    await foreground(tester);

    expect(mediaTrack.enabled, isFalse);
  });

  testWidgets('keeps the track of a speaking participant', (tester) async {
    when(() => participant.isSpeaking).thenReturn(true);
    await pumpPip(tester);

    await background(tester);

    expect(mediaTrack.enabled, isTrue);
  });

  testWidgets('turns on a track picture-in-picture moved away from', (
    tester,
  ) async {
    // Speaking, so the app leaves the track alone in the background.
    when(() => participant.isSpeaking).thenReturn(true);
    // Backgrounding replays the participants, which gives the window the
    // participant to draw.
    await pumpPip(tester);
    await background(tester);

    // Then it moves on to someone else, and the native side turns this one
    // off.
    mediaTrack.enabled = false;

    await foreground(tester);

    expect(mediaTrack.enabled, isTrue);
  });

  testWidgets('leaves the local camera to the LLC when it stopped it', (
    tester,
  ) async {
    when(() => participant.isLocal).thenReturn(true);
    when(() => callState.localParticipant).thenReturn(participant);
    await pumpPip(tester);
    await background(tester);
    expect(mediaTrack.enabled, isFalse);

    // Without multitasking camera access the LLC stops the camera in the
    // background. It recreates it on resume only if it finds it disabled.
    when(() => participant.isVideoEnabled).thenReturn(false);
    await foreground(tester);

    expect(mediaTrack.enabled, isFalse);
  });

  testWidgets('turns the local camera on again when it stayed on', (
    tester,
  ) async {
    when(() => participant.isLocal).thenReturn(true);
    when(() => callState.localParticipant).thenReturn(participant);
    await pumpPip(tester);

    await background(tester);
    expect(mediaTrack.enabled, isFalse);

    await foreground(tester);
    expect(mediaTrack.enabled, isTrue);
  });

  testWidgets('gives the window its participant before the app is paused', (
    tester,
  ) async {
    // Picture-in-picture can start from inline before the app is paused, and
    // opens in the shape of the track it already has.
    await pumpPip(tester);

    final update = nativeCalls.lastWhere(
      (call) => call.method == 'updateParticipant',
    );
    expect(
      (update.arguments as Map<Object?, Object?>)['trackId'],
      'alice-video',
    );
  });

  testWidgets('turns the track on again when removed in the background', (
    tester,
  ) async {
    await pumpPip(tester);
    await background(tester);

    // Frames only run again from inactive, which the window does not treat
    // as coming back to the foreground.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    expect(mediaTrack.enabled, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());

    expect(mediaTrack.enabled, isTrue);
  });
}
