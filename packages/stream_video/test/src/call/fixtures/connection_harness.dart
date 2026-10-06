import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/coordinator/models/coordinator_models.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_state.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';
import 'call_test_helpers.dart';
import 'data.dart';
import 'recording_client_event_reporter.dart';

/// The mocks a connection test drives a real [Call] through: network status,
/// coordinator events and join responses, the SFU sessions handed out in
/// order, and a telemetry reporter that records aborts.
class ConnectionHarness {
  ConnectionHarness({int sessionCount = 1})
    : sessions = List.generate(sessionCount, (i) {
        final session = setupMockCallSession();
        when(() => session.sessionId).thenReturn('session-$i');
        return session;
      }) {
    coordinatorClient = setupMockCoordinatorClient(events: coordinatorEvents);
    sessionFactory = setupMockSessionFactory(callSessions: sessions);
    stubMakeCallSession(() async {});
    streamVideo = setupMockStreamVideo()
      ..clientEventReporterOverride = reporter;
  }

  final internetStatus = BehaviorSubject<InternetStatus>.seeded(
    InternetStatus.connected,
  );
  final coordinatorEvents = MutableSharedEmitter<CoordinatorEvent>();
  final reporter = RecordingClientEventReporter();

  /// The SFU sessions, handed out by [sessionFactory] in order.
  final List<MockCallSession> sessions;

  late final MockCoordinatorClient coordinatorClient;
  late final MockSessionFactory sessionFactory;
  late final MockStreamVideo streamVideo;
  final permissionsManager = MockPermissionsManager();

  /// The first SFU session, the one the initial join gets.
  MockCallSession get session => sessions.first;

  /// The state manager of the call [buildCall] built last.
  late CallStateNotifier stateManager;

  final _calls = <Call>[];

  Call buildCall({
    CallPreferences? preferences,
    CallStatus? status,
    RetryPolicy? retryPolicy,
  }) {
    var callState = CallState(
      preferences: preferences ?? DefaultCallPreferences(),
      currentUserId: SampleCallData.defaultUserInfo.id,
      callCid: SampleCallData.defaultCid,
    );
    if (status != null) callState = callState.copyWith(status: status);
    stateManager = CallStateNotifier(callState);

    final call = createTestCall(
      coordinatorClient: coordinatorClient,
      streamVideo: streamVideo,
      stateManager: stateManager,
      permissionManager: permissionsManager,
      networkMonitor: setupMockInternetConnection(statusStream: internetStatus),
      retryPolicy: retryPolicy,
      sessionFactory: sessionFactory,
    );
    _calls.add(call);
    return call;
  }

  /// Answers every coordinator join with [answer].
  void stubJoinCall(Future<Result<CoordinatorJoined>> Function() answer) {
    when(
      () => coordinatorClient.joinCall(
        callCid: any(named: 'callCid'),
        create: any(named: 'create'),
        migratingFrom: any(named: 'migratingFrom'),
        migratingFromList: any(named: 'migratingFromList'),
        video: any(named: 'video'),
        membersLimit: any(named: 'membersLimit'),
        e2ee: any(named: 'e2ee'),
      ),
    ).thenAnswer((_) => answer());
  }

  void verifyJoinCallCount(int count) {
    (count == 0 ? verifyNever : verify)(
      () => coordinatorClient.joinCall(
        callCid: any(named: 'callCid'),
        create: any(named: 'create'),
        migratingFrom: any(named: 'migratingFrom'),
        migratingFromList: any(named: 'migratingFromList'),
        video: any(named: 'video'),
        membersLimit: any(named: 'membersLimit'),
        e2ee: any(named: 'e2ee'),
      ),
    ).called(count);
  }

  /// The `onReconnectionNeeded` callback each session was made with, in the
  /// order the sessions were made.
  final reconnectionCallbacks = <OnReconnectionNeeded>[];

  /// Asks for a reconnect with [strategy] the way the publisher of the
  /// [index]th session made would.
  void requestReconnect(int index, SfuReconnectionStrategy strategy) {
    final publisher = _MockStreamPeerConnection();
    when(() => publisher.type).thenReturn(StreamPeerType.publisher);
    reconnectionCallbacks[index](publisher, strategy);
  }

  /// Runs [before] ahead of handing out each session.
  void stubMakeCallSession(Future<void> Function() before) {
    final queue = [...sessions];
    when(
      () => sessionFactory.makeCallSession(
        onSuspendedAudioTrackRecorded: any(
          named: 'onSuspendedAudioTrackRecorded',
        ),
        sessionId: any(named: 'sessionId'),
        sessionSeq: any(named: 'sessionSeq'),
        credentials: any(named: 'credentials'),
        stateManager: any(named: 'stateManager'),
        dynascaleManager: any(named: 'dynascaleManager'),
        networkMonitor: any(named: 'networkMonitor'),
        statsOptions: any(named: 'statsOptions'),
        onReconnectionNeeded: any(named: 'onReconnectionNeeded'),
        clientPublishOptions: any(named: 'clientPublishOptions'),
        streamVideo: any(named: 'streamVideo'),
        leftoverTraceRecords: any(named: 'leftoverTraceRecords'),
        pcFactory: any(named: 'pcFactory'),
        e2eeManager: any(named: 'e2eeManager'),
      ),
    ).thenAnswer((invocation) async {
      reconnectionCallbacks.add(
        invocation.namedArguments[#onReconnectionNeeded]
            as OnReconnectionNeeded,
      );
      await before();
      return queue.length > 1 ? queue.removeAt(0) : queue.first;
    });
  }

  void verifyMakeCallSessionCount(int count) {
    (count == 0 ? verifyNever : verify)(
      () => sessionFactory.makeCallSession(
        onSuspendedAudioTrackRecorded: any(
          named: 'onSuspendedAudioTrackRecorded',
        ),
        sessionId: any(named: 'sessionId'),
        sessionSeq: any(named: 'sessionSeq'),
        credentials: any(named: 'credentials'),
        stateManager: any(named: 'stateManager'),
        dynascaleManager: any(named: 'dynascaleManager'),
        networkMonitor: any(named: 'networkMonitor'),
        statsOptions: any(named: 'statsOptions'),
        onReconnectionNeeded: any(named: 'onReconnectionNeeded'),
        clientPublishOptions: any(named: 'clientPublishOptions'),
        streamVideo: any(named: 'streamVideo'),
        leftoverTraceRecords: any(named: 'leftoverTraceRecords'),
        pcFactory: any(named: 'pcFactory'),
        e2eeManager: any(named: 'e2eeManager'),
      ),
    ).called(count);
  }

  /// Answers every SFU session start on [session] with [answer].
  void stubSessionStart(
    MockCallSession session,
    Future<Result<SessionStartResult>> Function() answer,
  ) {
    when(
      () => session.start(
        reconnectDetails: any(named: 'reconnectDetails'),
        onRtcManagerCreatedCallback: any(named: 'onRtcManagerCreatedCallback'),
        isAnonymousUser: any(named: 'isAnonymousUser'),
        capabilities: any(named: 'capabilities'),
        unifiedSessionId: any(named: 'unifiedSessionId'),
        clientEventRetryCount: any(named: 'clientEventRetryCount'),
      ),
    ).thenAnswer((_) => answer());
  }

  /// Answers every fast reconnect on [session] with [answer].
  void stubFastReconnect(
    MockCallSession session,
    Future<Result<SessionStartResult?>> Function() answer,
  ) {
    when(
      () => session.fastReconnect(
        reconnectDetails: any(named: 'reconnectDetails'),
        capabilities: any(named: 'capabilities'),
        unifiedSessionId: any(named: 'unifiedSessionId'),
      ),
    ).thenAnswer((_) => answer());
  }

  /// Emits [event] on [session]'s SFU event stream and lets it settle.
  Future<void> emitSfu(MockCallSession session, SfuEvent event) async {
    (session.events as MutableSharedEmitter<SfuEvent>).emit(event);
    await pumpEventQueue();
  }

  /// Leaves every call [buildCall] built, so no join or reconnect keeps
  /// running into the next test, and closes the streams.
  Future<void> dispose() async {
    for (final call in _calls) {
      await call.leave();
    }
    await coordinatorEvents.close();
    await internetStatus.close();
  }

  /// Captures the `sessionId` and `sessionSeq` of every SFU session made.
  List<({String? sessionId, int sessionSeq})> captureMakeCallSessionIds() {
    final captured = verify(
      () => sessionFactory.makeCallSession(
        onSuspendedAudioTrackRecorded: any(
          named: 'onSuspendedAudioTrackRecorded',
        ),
        sessionId: captureAny(named: 'sessionId'),
        sessionSeq: captureAny(named: 'sessionSeq'),
        credentials: any(named: 'credentials'),
        stateManager: any(named: 'stateManager'),
        dynascaleManager: any(named: 'dynascaleManager'),
        networkMonitor: any(named: 'networkMonitor'),
        statsOptions: any(named: 'statsOptions'),
        onReconnectionNeeded: any(named: 'onReconnectionNeeded'),
        clientPublishOptions: any(named: 'clientPublishOptions'),
        streamVideo: any(named: 'streamVideo'),
        leftoverTraceRecords: any(named: 'leftoverTraceRecords'),
        pcFactory: any(named: 'pcFactory'),
        e2eeManager: any(named: 'e2eeManager'),
      ),
    ).captured;
    // Each call contributes both captures, in an order mocktail picks.
    return [
      for (var i = 0; i < captured.length; i += 2)
        (
          sessionId: [
            captured[i],
            captured[i + 1],
          ].whereType<String>().firstOrNull,
          sessionSeq: [captured[i], captured[i + 1]].whereType<int>().single,
        ),
    ];
  }

  /// Waits for the abort count to reach [count], then for a grace period in
  /// which no further abort may arrive.
  Future<void> settleAborts(
    int count, {
    Duration grace = const Duration(seconds: 1),
  }) async {
    await waitUntil(() => reporter.aborts.length >= count);
    await Future<void>.delayed(grace);
  }
}

/// What a successful SFU session start or fast reconnect returns.
typedef SessionStartResult = ({
  SfuCallState callState,
  Duration fastReconnectDeadline,
});

Result<SessionStartResult> sessionStartSuccess() {
  return Result.success((
    callState: createTestSfuCallState(),
    fastReconnectDeadline: Duration.zero,
  ));
}

/// A coordinator refusal the join does not retry.
Result<CoordinatorJoined> unrecoverableJoinFailure() {
  return const Result.failure(
    StreamVideoExceptionWithCause(
      message: 'forbidden',
      cause: StreamApiException(message: 'forbidden', statusCode: 403),
    ),
  );
}

/// A coordinator failure the join classes as retryable (503).
Result<CoordinatorJoined> recoverableJoinFailure() {
  return const Result.failure(
    StreamVideoExceptionWithCause(
      message: 'unavailable',
      cause: StreamApiException(message: 'unavailable', statusCode: 503),
    ),
  );
}

/// An SFU failure that tells the client not to retry.
Result<SessionStartResult> unrecoverableSfuFailure() {
  return const Result.failure(
    StreamVideoExceptionWithCause(
      message: 'SFU disconnect',
      cause: SfuError(
        message: 'SFU disconnect',
        code: SfuErrorCode.unspecified,
        shouldRetry: false,
        reconnectStrategy: SfuReconnectionStrategy.disconnect,
      ),
    ),
  );
}

/// A reconnectable SFU socket closure.
const sfuSocketDropped = SfuSocketDisconnected(
  sessionId: 'test-session-id',
  url: 'wss://sfu.invalid',
  reason: DisconnectionReason(
    isReconnectable: true,
    closeCode: 1006,
    closeReason: 'abnormal',
  ),
);

/// Records every distinct status of [call], starting with the current one.
List<CallStatus> recordStatuses(Call call) {
  final statuses = <CallStatus>[];
  call.state.map((s) => s.status).distinct().listen(statuses.add);
  return statuses;
}

/// Waits until [condition] holds, polling every few milliseconds.
Future<void> waitUntil(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('condition not met', timeout);
    }
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}

class _MockStreamPeerConnection extends Mock implements StreamPeerConnection {
  @override
  Future<void> dispose() async {}
}
