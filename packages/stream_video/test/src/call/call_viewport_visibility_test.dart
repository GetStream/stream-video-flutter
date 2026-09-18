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
  const bobSession = 'bob-session';

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

  /// The viewports these are about: a grid tile, a filmstrip and a self-view.
  late ViewportHandle grid;
  late ViewportHandle strip;
  late ViewportHandle selfView;

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
          participant(sessionId: bobSession, userId: 'bob'),
        ],
      ),
    );

    call.dynascaleManager.init(sfuClient: sfuClient, sessionId: 'sfu-session');

    grid = call.viewportVisibility.attach();
    strip = call.viewportVisibility.attach();
    selfView = call.viewportVisibility.attach();
  });

  test(
    'a viewport showing a remote track subscribes it at that size',
    () async {
      grid.report(trackOf(aliceSession, 'alice'), showing(640, 360));
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

    strip.report(track, showing(160, 90));
    grid.report(track, showing(640, 360));
    await settle();

    expect(
      videoOf(aliceSession)!.videoDimension,
      const RtcVideoDimension(width: 640, height: 360),
      reason: 'the smaller viewport can scale down, the larger cannot scale up',
    );
  });

  test('the last viewport leaving unsubscribes the track', () async {
    final track = trackOf(aliceSession, 'alice');

    grid.report(track, showing(640, 360));
    await settle();

    grid.release();
    await settle();

    expect(
      participantOf(aliceSession)!.viewportVisibility,
      ViewportVisibility.hidden,
    );
    expect(videoOf(aliceSession)!.subscribed, isFalse);
  });

  test('a viewport keeping a hidden track leaves it subscribed', () async {
    final track = trackOf(aliceSession, 'alice');

    grid.report(track, showing(640, 360));
    await settle();

    grid.report(
      track,
      const ViewportMeasurement(
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
    selfView.report(trackOf(localSession, 'local'), showing(320, 180));
    await settle();

    expect(
      participantOf(localSession)!.viewportVisibility,
      ViewportVisibility.visible,
    );
    verifyNever(() => sfuClient.updateSubscriptions(any()));
  });

  test('a track nobody has published is not subscribed', () async {
    grid.report(trackOf(carolSession, 'carol'), showing(320, 180));
    await settle();

    verifyNever(() => sfuClient.updateSubscriptions(any()));
  });

  // A viewport draws one track at a time. What it stops drawing is not what
  // the call stops subscribing to — that depends on everyone else.
  test(
    'a viewport moved to another track unsubscribes the one it left',
    () async {
      grid.report(trackOf(aliceSession, 'alice'), showing(640, 360));
      await settle();
      expect(videoOf(aliceSession)!.subscribed, isTrue);

      grid.report(trackOf(bobSession, 'bob'), showing(640, 360));
      await settle();

      expect(
        videoOf(aliceSession)!.subscribed,
        isFalse,
        reason: 'nobody draws the track it left',
      );
      expect(videoOf(bobSession)!.subscribed, isTrue);
    },
  );

  test('a track another viewport still shows keeps it, at that size', () async {
    final alice = trackOf(aliceSession, 'alice');

    grid.report(alice, showing(640, 360));
    strip.report(alice, showing(160, 90));
    await settle();

    expect(
      videoOf(aliceSession)!.videoDimension,
      const RtcVideoDimension(width: 640, height: 360),
      reason: 'the strip reported last, but the grid is the larger',
    );

    grid.report(trackOf(bobSession, 'bob'), showing(640, 360));
    await settle();

    expect(videoOf(aliceSession)!.subscribed, isTrue);
    expect(
      videoOf(aliceSession)!.videoDimension,
      const RtcVideoDimension(width: 160, height: 90),
      reason: 'the strip is the largest viewport left showing it',
    );
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
    final joiningGrid = joining.viewportVisibility.attach();

    // The tile is already on screen when the call joins. A viewport reports
    // what changes about it, so it has nothing to say to the new session on
    // its own.
    joiningGrid.report(trackOf(aliceSession, 'alice'), showing(640, 360));
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

    grid.report(ghost, showing(640, 360));
    await settle();

    verifyNever(() => sfuClient.updateSubscriptions(any()));

    // Not remembered as said: a second viewport that does not move the answer
    // still has it offered again, so the track is subscribed once whoever
    // draws it joins the call.
    strip.report(ghost, showing(320, 180));
    await settle();

    expect(
      call.state.value.callParticipants.map((it) => it.sessionId),
      isNot(contains('ghost-session')),
    );
  });
}
