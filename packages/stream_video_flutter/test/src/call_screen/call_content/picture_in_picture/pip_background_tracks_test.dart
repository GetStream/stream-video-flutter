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
  _FakeMediaStreamTrack([this.id = 'alice-video']);

  @override
  bool enabled = true;

  // Handed to the native window, which draws the track by its id.
  @override
  final String? id;
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
    Comparator<CallParticipantState>? sort,
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        child: StreamPictureInPictureUiKitView(
          call: call,
          pictureInPictureConfiguration: PictureInPictureConfiguration(
            enablePictureInPicture: true,
            sort: sort == null ? null : CallParticipantSort(sort),
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

  group('with the window moving between participants', () {
    late Map<String, _FakeMediaStreamTrack> videoTracks;

    MockCallParticipantState joining(String userId, {required bool video}) {
      final other = MockCallParticipantState();
      when(() => other.userId).thenReturn(userId);
      when(() => other.sessionId).thenReturn('$userId-session');
      when(() => other.trackIdPrefix).thenReturn(userId);
      when(() => other.name).thenReturn(userId);
      when(() => other.image).thenReturn(null);
      when(() => other.isLocal).thenReturn(false);
      when(() => other.isSpeaking).thenReturn(false);
      when(() => other.isAudioEnabled).thenReturn(true);
      when(() => other.isVideoEnabled).thenReturn(video);
      when(() => other.isScreenShareEnabled).thenReturn(false);
      when(() => other.screenShareTrack).thenReturn(null);
      when(() => other.publishedTracks).thenReturn({
        if (video)
          SfuTrackType.video: TrackState.remote(
            subscribed: true,
            received: true,
          ),
      });
      when(
        () => other.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      if (video) videoTracks[userId] = _FakeMediaStreamTrack('$userId-video');
      return other;
    }

    // Puts [first] on top of the window, with Alice still in the call.
    void rank(CallParticipantState first) {
      final state = MockCallState();
      when(() => state.status).thenReturn(CallStatus.connected());
      when(() => state.callParticipants).thenReturn([participant, first]);
      when(() => state.localParticipant).thenReturn(null);
      when(() => state.iOSMultitaskingCameraAccessEnabled).thenReturn(true);
      emitter.value = state;
    }

    setUp(() {
      videoTracks = {'alice': mediaTrack};
      when(() => call.getTrack(any(), any())).thenAnswer((invocation) {
        final [prefix, type] = invocation.positionalArguments;
        if (type != SfuTrackType.video) return null;
        final mediaTrack = videoTracks[prefix];
        if (mediaTrack == null) return null;
        final track = _MockRtcTrack();
        when(() => track.mediaTrack).thenReturn(mediaTrack);
        return track;
      });

      // Like the native side: it keeps its track through an update without
      // one, and turns it off once given another while picture-in-picture
      // can be open.
      String? heldTrackId;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (methodCall) async {
            nativeCalls.add(methodCall);
            if (methodCall.method != 'updateParticipant') return null;
            final arguments = methodCall.arguments as Map<Object?, Object?>;
            final trackId = arguments['trackId'] as String?;
            if (trackId == null || trackId == heldTrackId) return null;
            final pictureInPictureCanBeOpen =
                WidgetsBinding.instance.lifecycleState !=
                AppLifecycleState.resumed;
            for (final track in videoTracks.values) {
              if (!pictureInPictureCanBeOpen) break;
              if (track.id == heldTrackId) track.enabled = false;
            }
            heldTrackId = trackId;
            return null;
          });

      // Speaking, so the app leaves Alice's track alone in the background.
      when(() => participant.isSpeaking).thenReturn(true);
    });

    // Whoever joined last comes first in the window.
    int lastJoinedFirst(CallParticipantState a, CallParticipantState b) =>
        (a.userId == 'alice' ? 1 : 0) - (b.userId == 'alice' ? 1 : 0);

    testWidgets('turns on a track shown in an earlier trip', (tester) async {
      await pumpPip(tester, sort: lastJoinedFirst);

      // The window is given Alice, and holds her track past resuming.
      await background(tester);
      await foreground(tester);
      expect(mediaTrack.enabled, isTrue);

      // Bob joins on the next trip, and the window moves to him while
      // picture-in-picture is open.
      await background(tester);
      rank(joining('bob', video: true));
      await tester.pump();
      expect(mediaTrack.enabled, isFalse);

      await foreground(tester);
      expect(mediaTrack.enabled, isTrue);
    });

    testWidgets('turns on a track the window was given in the foreground', (
      tester,
    ) async {
      // The window is given Alice in the foreground.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await pumpPip(tester, sort: lastJoinedFirst);

      // Bob joins, and the window moves to him once the app is away.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      rank(joining('bob', video: true));
      await background(tester);
      expect(mediaTrack.enabled, isFalse);

      await foreground(tester);
      expect(mediaTrack.enabled, isTrue);
    });

    testWidgets('remembers the track kept through a participant without one', (
      tester,
    ) async {
      await pumpPip(tester, sort: lastJoinedFirst);
      await background(tester);
      await foreground(tester);

      // Bob has no video, so the window keeps drawing Alice's track.
      rank(joining('bob', video: false));
      await background(tester);
      expect(mediaTrack.enabled, isTrue);
      await foreground(tester);

      // Carol has video, so the window moves away from Alice's track once
      // picture-in-picture is open.
      await background(tester);
      rank(joining('carol', video: true));
      await tester.pump();
      expect(mediaTrack.enabled, isFalse);

      await foreground(tester);
      expect(mediaTrack.enabled, isTrue);
    });
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

  testWidgets('turns on the local camera picture-in-picture moved away from', (
    tester,
  ) async {
    // Speaking, so the app leaves the camera alone in the background.
    when(() => participant.isLocal).thenReturn(true);
    when(() => participant.isSpeaking).thenReturn(true);
    when(() => callState.localParticipant).thenReturn(participant);
    await pumpPip(tester);
    await background(tester);

    // The window moves on to someone else, and the native side turns the
    // camera off.
    mediaTrack.enabled = false;

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

  testWidgets('does not send an unchanged participant again', (tester) async {
    await pumpPip(tester);
    await background(tester);
    await foreground(tester);

    expect(
      nativeCalls.where((call) => call.method == 'updateParticipant'),
      hasLength(1),
    );
  });

  testWidgets('sends a track rebuilt under the same id again', (tester) async {
    await pumpPip(tester);

    // A rejoin or a migration rebuilds the subscriber, and the remote track
    // comes back with the publisher's id.
    final rebuilt = _MockRtcTrack();
    when(() => rebuilt.mediaTrack).thenReturn(_FakeMediaStreamTrack());
    when(() => call.getTrack(any(), any())).thenReturn(rebuilt);
    final rejoined = MockCallState();
    when(() => rejoined.status).thenReturn(CallStatus.connected());
    when(() => rejoined.callParticipants).thenReturn([participant]);
    when(() => rejoined.iOSMultitaskingCameraAccessEnabled).thenReturn(true);
    emitter.value = rejoined;
    await tester.pump();

    final updates = nativeCalls.where(
      (call) => call.method == 'updateParticipant',
    );
    expect(updates, hasLength(2));
    expect(
      (updates.last.arguments as Map<Object?, Object?>)['trackId'],
      'alice-video',
    );
  });

  testWidgets('leaves alone a track the window was given in the foreground', (
    tester,
  ) async {
    // Speaking, so the app leaves the track alone in the background.
    when(() => participant.isSpeaking).thenReturn(true);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await pumpPip(tester);

    // Turned off by something else, and only through Control Center away.
    mediaTrack.enabled = false;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await foreground(tester);

    expect(mediaTrack.enabled, isFalse);
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
