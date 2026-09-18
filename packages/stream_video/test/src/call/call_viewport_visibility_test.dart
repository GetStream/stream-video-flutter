import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

// The registry answers for a track; this is the call acting on that answer.
// What every viewport adds up to has to reach the call state the UI reads and
// the subscription the SFU serves, and stop reaching them once nobody draws
// the track.

void main() {
  const aliceSession = 'alice-session';
  const localSession = 'local-session';
  const carolSession = 'carol-session';

  CallParticipantState participant({
    required String sessionId,
    required String userId,
    bool isLocal = false,
    bool publishesVideo = true,
  }) {
    return CallParticipantState(
      userId: userId,
      roles: const [],
      name: userId,
      custom: const {},
      sessionId: sessionId,
      trackIdPrefix: userId,
      isLocal: isLocal,
      publishedTracks: {
        if (publishesVideo)
          SfuTrackType.video: isLocal
              ? TrackState.local()
              : TrackState.remote(),
      },
    );
  }

  ViewportTrack trackOf(String sessionId, String userId) => ViewportTrack(
    userId: userId,
    sessionId: sessionId,
    trackIdPrefix: userId,
    trackType: SfuTrackType.video,
  );

  ViewportMeasurement showing(int width, int height) => ViewportMeasurement(
    visibility: ViewportVisibility.visible,
    dimension: RtcVideoDimension(width: width, height: height),
  );

  late MockSfuClient sfuClient;
  late Call call;

  CallParticipantState? participantOf(String sessionId) {
    for (final it in call.state.value.callParticipants) {
      if (it.sessionId == sessionId) return it;
    }
    return null;
  }

  RemoteTrackState? videoOf(String sessionId) {
    final track = participantOf(sessionId)?.publishedTracks[SfuTrackType.video];
    return track is RemoteTrackState ? track : null;
  }

  // A subscription change is debounced before it reaches the SFU, and the
  // state it writes back comes after that.
  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 400));

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
    registerFallbackValue(sfu.UpdateSubscriptionsRequest());
    registerFallbackValue(
      const VisibilityChange(
        sessionId: 'fallback',
        userId: 'fallback',
        visibility: ViewportVisibility.unknown,
      ),
    );
  });

  setUp(() {
    sfuClient = MockSfuClient();
    when(() => sfuClient.updateSubscriptions(any())).thenAnswer(
      (_) async => Result.success(sfu.UpdateSubscriptionsResponse()),
    );

    call = createTestCallWithState(
      initialState: createActiveCallState().copyWith(
        callParticipants: [
          participant(sessionId: aliceSession, userId: 'alice'),
          participant(
            sessionId: localSession,
            userId: 'local',
            isLocal: true,
          ),
          participant(
            sessionId: carolSession,
            userId: 'carol',
            publishesVideo: false,
          ),
        ],
      ),
    );

    call.dynascaleManager.init(sfuClient: sfuClient, sessionId: 'sfu-session');
  });

  test(
    'a viewport showing a remote track subscribes it at that size',
    () async {
      call.viewportVisibility.report(
        viewportId: 'grid',
        track: trackOf(aliceSession, 'alice'),
        measurement: showing(640, 360),
      );
      await settle();

      expect(
        participantOf(aliceSession)!.viewportVisibility,
        ViewportVisibility.visible,
      );
      expect(videoOf(aliceSession)!.subscribed, isTrue);
      expect(
        videoOf(aliceSession)!.videoDimension,
        const RtcVideoDimension(width: 640, height: 360),
      );
    },
  );

  test('the largest viewport showing a track sizes the subscription', () async {
    final track = trackOf(aliceSession, 'alice');

    call.viewportVisibility.report(
      viewportId: 'strip',
      track: track,
      measurement: showing(160, 90),
    );
    call.viewportVisibility.report(
      viewportId: 'grid',
      track: track,
      measurement: showing(640, 360),
    );
    await settle();

    expect(
      videoOf(aliceSession)!.videoDimension,
      const RtcVideoDimension(width: 640, height: 360),
      reason: 'the smaller viewport can scale down, the larger cannot scale up',
    );
  });

  test('the last viewport leaving unsubscribes the track', () async {
    final track = trackOf(aliceSession, 'alice');

    call.viewportVisibility.report(
      viewportId: 'grid',
      track: track,
      measurement: showing(640, 360),
    );
    await settle();

    call.viewportVisibility.release(viewportId: 'grid', track: track);
    await settle();

    expect(
      participantOf(aliceSession)!.viewportVisibility,
      ViewportVisibility.hidden,
    );
    expect(videoOf(aliceSession)!.subscribed, isFalse);
  });

  test('a viewport keeping a hidden track leaves it subscribed', () async {
    final track = trackOf(aliceSession, 'alice');

    call.viewportVisibility.report(
      viewportId: 'grid',
      track: track,
      measurement: showing(640, 360),
    );
    await settle();

    call.viewportVisibility.report(
      viewportId: 'grid',
      track: track,
      measurement: const ViewportMeasurement(
        visibility: ViewportVisibility.hidden,
        persistWhenHidden: true,
      ),
    );
    await settle();

    expect(
      videoOf(aliceSession)!.subscribed,
      isTrue,
      reason: 'a screen share off screen is still wanted',
    );
  });

  test('a local track is not subscribed', () async {
    call.viewportVisibility.report(
      viewportId: 'selfView',
      track: trackOf(localSession, 'local'),
      measurement: showing(320, 180),
    );
    await settle();

    expect(
      participantOf(localSession)!.viewportVisibility,
      ViewportVisibility.visible,
    );
    verifyNever(() => sfuClient.updateSubscriptions(any()));
  });

  test('a track nobody has published is not subscribed', () async {
    call.viewportVisibility.report(
      viewportId: 'grid',
      track: trackOf(carolSession, 'carol'),
      measurement: showing(320, 180),
    );
    await settle();

    verifyNever(() => sfuClient.updateSubscriptions(any()));
  });

  test('a track on screen is told to the session a join creates', () async {
    final callSession = setupMockCallSession();
    when(() => callSession.updateViewportVisibility(any())).thenAnswer(
      (_) async => const Result.success(none),
    );

    final joining = createTestCall(
      stateManager: CallStateNotifier(
        createTestCallState().copyWith(
          callParticipants: [
            participant(sessionId: aliceSession, userId: 'alice'),
          ],
        ),
      ),
      sessionFactory: setupMockSessionFactory(callSession: callSession),
    );
    joining.dynascaleManager.init(
      sfuClient: sfuClient,
      sessionId: 'sfu-session',
    );

    // The tile is already on screen when the call joins. A viewport reports
    // what changes about it, so it has nothing to say to the new session on
    // its own.
    joining.viewportVisibility.report(
      viewportId: 'grid',
      track: trackOf(aliceSession, 'alice'),
      measurement: showing(640, 360),
    );
    await settle();
    clearInteractions(callSession);

    final joined = await joining.join();
    expect(joined.isSuccess, isTrue);
    await settle();

    verify(
      () => callSession.updateViewportVisibility(any()),
    ).called(greaterThan(0));
  });

  test('a track for nobody in the call is not said to have landed', () async {
    final ghost = trackOf('ghost-session', 'ghost');

    call.viewportVisibility.report(
      viewportId: 'grid',
      track: ghost,
      measurement: showing(640, 360),
    );
    await settle();

    verifyNever(() => sfuClient.updateSubscriptions(any()));

    // Not remembered as said: a second viewport that does not move the answer
    // still has it offered again, so the track is subscribed once whoever
    // draws it joins the call.
    call.viewportVisibility.report(
      viewportId: 'strip',
      track: ghost,
      measurement: showing(320, 180),
    );
    await settle();

    expect(
      call.state.value.callParticipants.map((it) => it.sessionId),
      isNot(contains('ghost-session')),
    );
  });
}
