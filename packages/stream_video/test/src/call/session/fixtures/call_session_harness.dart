// ignore_for_file: missing_override_of_must_be_overridden

import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/call/session/call_session_config.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_state.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/src/sfu/data/models/sfu_pin.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/ws/sfu_ws.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/rtc_manager_factory.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../../test_helpers.dart';
import '../../fixtures/call_test_helpers.dart';
import '../../fixtures/data.dart';
import '../../fixtures/recording_client_event_reporter.dart';

class MockSfuWebSocket extends Mock implements SfuWebSocket {}

class MockRtcManagerFactory extends Mock implements RtcManagerFactory {}

class MockStreamPeerConnectionFactory extends Mock
    implements StreamPeerConnectionFactory {}

class MockTracedPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class MockRTCPeerConnection extends Mock implements rtc.RTCPeerConnection {}

class MockRtcRemoteTrack extends Mock implements RtcRemoteTrack {}

/// The session id every harness session runs with.
const harnessSessionId = 'test-session';

/// The user id the harness's call state names as the current user.
const harnessUserId = 'test';

/// Registers the fallback values the harness's stubs match with `any()`.
void registerCallSessionHarnessFallbacks() {
  registerMockFallbackValues();
  registerFallbackValue(sfu_events.SfuRequest());
  registerFallbackValue(sfu.SendAnswerRequest());
  registerFallbackValue(sfu.SetPublisherRequest());
  registerFallbackValue(sfu.UpdateMuteStatesRequest());
  registerFallbackValue(sfu_models.ICETrickle());
  registerFallbackValue(rtc.TransceiverDirection.RecvOnly);
  registerFallbackValue(MockSfuClient());
  registerFallbackValue(SampleCallData.defaultMediaDevice);
  registerFallbackValue(SfuTrackType.audio);
  registerFallbackValue(Duration.zero);
  registerFallbackValue(CloseCode.normalClosure);
  registerFallbackValue(StreamPeerType.publisher);
  registerFallbackValue(MockTracedPeerConnection());
  registerFallbackValue(
    const SfuSubscriberOfferEvent(
      sdp: '',
      iceRestart: false,
      negotiationId: 0,
    ),
  );
  registerFallbackValue(
    const SfuIceRestartEvent(peerType: StreamPeerType.publisher),
  );
  final participant = harnessSfuParticipant();
  registerFallbackValue(
    SfuJoinResponseEvent(callState: harnessSfuCallState()),
  );
  registerFallbackValue(
    SfuParticipantJoinedEvent(callCid: 'cid', participant: participant),
  );
  registerFallbackValue(
    SfuParticipantUpdatedEvent(callCid: 'cid', participant: participant),
  );
  registerFallbackValue(
    SfuParticipantLeftEvent(callCid: 'cid', participant: participant),
  );
  registerFallbackValue(
    SfuTrackPublishedEvent(
      userId: 'alice',
      sessionId: 'alice-session',
      trackType: SfuTrackType.video,
      participant: participant,
    ),
  );
  registerFallbackValue(
    SfuTrackUnpublishedEvent(
      userId: 'alice',
      sessionId: 'alice-session',
      trackType: SfuTrackType.video,
      participant: participant,
    ),
  );
  registerFallbackValue(
    const SfuError(
      message: '',
      code: SfuErrorCode.unspecified,
      shouldRetry: false,
      reconnectStrategy: SfuReconnectionStrategy.unspecified,
    ),
  );
}

/// An SFU participant for the harness's events.
SfuParticipant harnessSfuParticipant({
  String userId = 'alice',
  String sessionId = 'alice-session',
  String trackLookupPrefix = 'alice-prefix',
}) {
  return SfuParticipant(
    userId: userId,
    userName: userId,
    userImage: '',
    sessionId: sessionId,
    custom: const {},
    customData: const {},
    publishedTracks: const [],
    joinedAt: DateTime(2026),
    trackLookupPrefix: trackLookupPrefix,
    connectionQuality: SfuConnectionQuality.excellent,
    isSpeaking: false,
    isDominantSpeaker: false,
    audioLevel: 0,
    roles: const [],
    participantSource: SfuParticipantSource.webrtc,
  );
}

/// A call participant as the harness's call state holds it.
CallParticipantState harnessParticipant({
  String userId = 'alice',
  String sessionId = 'alice-session',
  String trackIdPrefix = 'alice-prefix',
  bool isLocal = false,
}) {
  return CallParticipantState(
    name: userId,
    userId: userId,
    sessionId: sessionId,
    custom: const {},
    roles: const [],
    trackIdPrefix: trackIdPrefix,
    isLocal: isLocal,
  );
}

/// A [CallSession] built on fakes: a scriptable SFU socket, a mock SFU
/// client, a mock `RtcManager` the factory hands out, and a call state the
/// test can replace.
class CallSessionHarness {
  CallSessionHarness({
    Duration joinResponseTimeout = const Duration(seconds: 5),
    Duration fastReconnectJoinResponseTimeout = const Duration(seconds: 15),
    ClientPublishOptions? clientPublishOptions,
  }) {
    _stubStateManager();
    _stubSocket();
    _stubSfuClient();
    _stubRtcManager();
    _stubFactories();

    host = setupMockCallHost()..clientEventReporterOverride = reporter;
    when(() => host.apiKey).thenReturn('test-api-key');
    when(() => host.webrtcInitialized).thenAnswer((_) async {});

    session = CallSession(
      retryPolicy: const RetryPolicy(),
      callCid: SampleCallData.defaultCid,
      sessionSeq: 0,
      sessionId: harnessSessionId,
      config: const CallSessionConfig(
        sfuName: 'test-sfu',
        sfuToken: 'test-token',
        sfuUrl: 'https://test.example.com',
        sfuWsEndpoint: 'wss://test.example.com/ws',
        rtcConfig: RTCConfiguration(),
      ),
      stateManager: stateManager,
      dynascaleManager: MockDynascaleManager(),
      onReconnectionNeeded: (pc, strategy, reason) =>
          reconnects.add((pc, strategy, reason)),
      onIceConnected: (_) {},
      onSuspendedAudioTrackRecorded: suspendedTrackIds.add,
      sdpEditor: MockSdpEditor(),
      networkMonitor: setupMockInternetConnection(
        statusStream: networkStatus,
      ),
      statsOptions: const StatsOptions(
        enableRtcStats: false,
        reportingIntervalMs: 500,
      ),
      host: host,
      tracer: Tracer(null),
      pcFactory: pcFactory,
      clientPublishOptions: clientPublishOptions,
      joinResponseTimeout: joinResponseTimeout,
      fastReconnectJoinResponseTimeout: fastReconnectJoinResponseTimeout,
      sfuClient: sfuClient,
      sfuWS: sfuWS,
      rtcManagerFactory: rtcManagerFactory,
    );
  }

  late final CallSession session;
  late final MockCallHost host;

  final reporter = RecordingClientEventReporter();
  final stateManager = MockCallStateNotifier();
  final events = MutableSharedEmitter<SfuEvent>();
  final sfuWS = MockSfuWebSocket();
  final sfuClient = MockSfuClient();
  final pcFactory = MockStreamPeerConnectionFactory();
  final rtcManagerFactory = MockRtcManagerFactory();
  final rtcManager = MockRtcManager();
  final subscriber = MockTracedPeerConnection();
  final publisher = MockTracedPeerConnection();
  final publisherPc = MockRTCPeerConnection();

  /// Network status changes the session sees. Starts without a value, so
  /// only what a test emits is traced.
  // ignore: close_sinks, lives as long as the test.
  final networkStatus = BehaviorSubject<InternetStatus>();

  /// Every reconnect the session asked for, in order.
  final reconnects =
      <
        (
          StreamPeerConnection,
          SfuReconnectionStrategy,
          ReconnectionNeededReason,
        )
      >[];

  /// Every track id the session recorded as suspended, in order.
  final suspendedTrackIds = <String>[];

  /// Every request the session sent over the SFU socket, in order.
  final sentRequests = <sfu_events.SfuRequest>[];

  /// Answers a sent join request, after the session starts waiting for it.
  /// `null` leaves the join unanswered.
  SfuEvent? Function()? joinAnswer = () => SfuJoinResponseEvent(
    callState: harnessSfuCallState(),
  );

  /// Answers a fast reconnect's join; the SFU resumes the session unless a
  /// test says otherwise.
  SfuEvent? Function()? fastReconnectAnswer = () => SfuJoinResponseEvent(
    callState: harnessSfuCallState(),
    isReconnected: true,
  );

  late final _callState = MutableStateEmitter<CallState>(
    createTestCallState(currentUserId: harnessUserId),
    sync: true,
  );

  /// The call state the session reads.
  CallState get state => _callState.value;
  set state(CallState value) => _callState.value = value;

  /// The tags of everything the session traced, in order. Takes the trace.
  List<String> takeTraceTags() => [
    for (final slice in session.getTrace())
      for (final record in slice.snapshot) record.tag,
  ];

  void _stubStateManager() {
    when(() => stateManager.callState).thenAnswer((_) => _callState.value);
    when(() => stateManager.callStateStream).thenAnswer((_) => _callState);
    when(() => stateManager.audioOutputSelectedByUser).thenReturn(false);
  }

  void _stubSocket() {
    when(() => sfuWS.events).thenAnswer((_) => events);
    when(() => sfuWS.isConnected).thenReturn(true);
    when(sfuWS.connect).thenAnswer((_) async => const Result.success(none));
    when(sfuWS.recreate).thenAnswer((_) async => const Result.success(none));
    when(
      () => sfuWS.disconnect(any(), any()),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      () => sfuWS.leave(
        sessionId: any(named: 'sessionId'),
        reason: any(named: 'reason'),
      ),
    ).thenReturn(null);
    when(() => sfuWS.send(any())).thenAnswer((invocation) {
      final request =
          invocation.positionalArguments.single as sfu_events.SfuRequest;
      sentRequests.add(request);
      final isFastReconnect =
          request.joinRequest.reconnectDetails.strategy ==
          sfu_models
              .WebsocketReconnectStrategy
              .WEBSOCKET_RECONNECT_STRATEGY_FAST;
      final answer = !request.hasJoinRequest()
          ? null
          : isFastReconnect
          ? fastReconnectAnswer?.call()
          : joinAnswer?.call();
      if (answer != null) {
        Timer.run(() => events.emit(answer));
      }
      return const Result<void>.success(null);
    });
    when(
      () => sfuWS.waitForJoinResponse(timeLimit: any(named: 'timeLimit')),
    ).thenAnswer((invocation) {
      final timeLimit = invocation.namedArguments[#timeLimit] as Duration;
      return _waitForJoinResponse(timeLimit);
    });
  }

  /// How many join waits are still listening to [events].
  int get pendingJoinWaits => _pendingJoinWaits;
  var _pendingJoinWaits = 0;

  // Settles the way the socket does: on the answer, an SFU error, the socket
  // closing (an `SfuSocketDisconnected` here) or the time limit. A socket
  // that is already down when the wait starts is not modelled.
  Future<Result<SfuJoinResponseEvent>> _waitForJoinResponse(
    Duration timeLimit,
  ) {
    final completer = Completer<Result<SfuJoinResponseEvent>>();
    void settle(Result<SfuJoinResponseEvent> result) {
      if (!completer.isCompleted) completer.complete(result);
    }

    _pendingJoinWaits++;
    final subscription = events.listen((event) {
      if (event is SfuJoinResponseEvent) {
        settle(Result.success(event));
      } else if (event is SfuErrorEvent) {
        settle(failureWithError(event.error.message, cause: event.error));
      } else if (event is SfuSocketDisconnected) {
        settle(failureWithError('SFU WS closed before the join response'));
      }
    });
    final timer = Timer(timeLimit, () {
      settle(
        failureWithError(
          'No join response within ${timeLimit.inMilliseconds}ms',
          cause: TimeoutException('No join response', timeLimit),
        ),
      );
    });

    return completer.future.whenComplete(() {
      _pendingJoinWaits--;
      timer.cancel();
      unawaited(subscription.cancel());
    });
  }

  void _stubSfuClient() {
    when(() => sfuClient.updateMuteState(any())).thenAnswer(
      (_) async => Result.success(sfu.UpdateMuteStatesResponse()),
    );
    when(() => sfuClient.iceTrickle(any())).thenAnswer(
      (_) async => Result.success(sfu.ICETrickleResponse()),
    );
    when(() => sfuClient.sendAnswer(any())).thenAnswer(
      (_) async => Result.success(sfu.SendAnswerResponse()),
    );
  }

  void _stubRtcManager() {
    when(rtcManager.dispose).thenAnswer((_) async {});
    when(rtcManager.flushPendingDecryptors).thenAnswer((_) async {});
    when(() => rtcManager.discardPendingDecryptors(any())).thenReturn(null);
    when(() => rtcManager.removeSubscriber(any())).thenAnswer((_) async {});
    when(() => rtcManager.publishOptions).thenReturn(const []);
    when(() => rtcManager.remoteTracks).thenReturn(const {});
    when(() => rtcManager.localTracks).thenReturn(const {});
    when(() => rtcManager.getTrack(any())).thenReturn(null);
    when(rtcManager.isPublisherEmpty).thenAnswer((_) async => true);
    when(() => rtcManager.subscriber).thenReturn(subscriber);
    when(() => rtcManager.publisher).thenReturn(publisher);

    for (final pc in [subscriber, publisher]) {
      when(() => pc.setReconnecting(any())).thenReturn(null);
      when(pc.restartIce).thenAnswer((_) async => const Result.success(null));
    }
    when(() => subscriber.type).thenReturn(StreamPeerType.subscriber);
    when(() => publisher.type).thenReturn(StreamPeerType.publisher);
    when(() => publisher.pc).thenReturn(publisherPc);
    when(publisherPc.restartIce).thenAnswer((_) async {});
  }

  void _stubFactories() {
    when(
      () => pcFactory.getGenericSdp(rtc.TransceiverDirection.RecvOnly),
    ).thenAnswer((_) async => 'subscriber-sdp');
    when(
      () => pcFactory.getGenericSdp(rtc.TransceiverDirection.SendOnly),
    ).thenAnswer((_) async => 'publisher-sdp');

    when(() => rtcManagerFactory.pcFactory).thenReturn(pcFactory);
    when(
      () => rtcManagerFactory.makeRtcManager(
        sfuClient: any(named: 'sfuClient'),
        stateManager: any(named: 'stateManager'),
        host: any(named: 'host'),
        clientDetails: any(named: 'clientDetails'),
        publisherId: any(named: 'publisherId'),
        sessionSequence: any(named: 'sessionSequence'),
        publishOptions: any(named: 'publishOptions'),
        statsOptions: any(named: 'statsOptions'),
        callSessionConfig: any(named: 'callSessionConfig'),
        clientEventRetryCount: any(named: 'clientEventRetryCount'),
        e2eeManager: any(named: 'e2eeManager'),
      ),
    ).thenAnswer((_) async => rtcManager);
  }

  /// Holds `makeRtcManager` until the returned completer is completed.
  Completer<RtcManager> holdRtcManager() {
    final completer = Completer<RtcManager>();
    when(
      () => rtcManagerFactory.makeRtcManager(
        sfuClient: any(named: 'sfuClient'),
        stateManager: any(named: 'stateManager'),
        host: any(named: 'host'),
        clientDetails: any(named: 'clientDetails'),
        publisherId: any(named: 'publisherId'),
        sessionSequence: any(named: 'sessionSequence'),
        publishOptions: any(named: 'publishOptions'),
        statsOptions: any(named: 'statsOptions'),
        callSessionConfig: any(named: 'callSessionConfig'),
        clientEventRetryCount: any(named: 'clientEventRetryCount'),
        e2eeManager: any(named: 'e2eeManager'),
      ),
    ).thenAnswer((_) => completer.future);
    return completer;
  }

  /// The `publisherId` the session handed the factory on its only
  /// `makeRtcManager` call.
  String? capturedPublisherId() {
    return verify(
          () => rtcManagerFactory.makeRtcManager(
            sfuClient: any(named: 'sfuClient'),
            stateManager: any(named: 'stateManager'),
            host: any(named: 'host'),
            clientDetails: any(named: 'clientDetails'),
            publisherId: captureAny(named: 'publisherId'),
            sessionSequence: any(named: 'sessionSequence'),
            publishOptions: any(named: 'publishOptions'),
            statsOptions: any(named: 'statsOptions'),
            callSessionConfig: any(named: 'callSessionConfig'),
            clientEventRetryCount: any(named: 'clientEventRetryCount'),
            e2eeManager: any(named: 'e2eeManager'),
          ),
        ).captured.single
        as String?;
  }

  /// The join requests the session sent, in order.
  List<sfu_events.JoinRequest> get joinRequests => [
    for (final request in sentRequests)
      if (request.hasJoinRequest()) request.joinRequest,
  ];
}

/// Publish options whose codec no client option names, to tell the
/// manager's options apart from the client's in a join request.
final harnessPublishOptions = [
  SfuPublishOptions(
    id: 1,
    codec: const SfuCodec(
      payloadType: 96,
      name: 'vp8',
      fmtpLine: '',
      clockRate: 90000,
      encodingParameters: '',
    ),
    trackType: SfuTrackType.video,
  ),
];

/// An SFU call state with the harness's local participant in it.
SfuCallState harnessSfuCallState({
  List<SfuParticipant>? participants,
  List<SfuPin> pins = const [],
  bool e2eeEnabled = false,
}) {
  return SfuCallState(
    participants:
        participants ??
        [
          harnessSfuParticipant(
            userId: harnessUserId,
            sessionId: harnessSessionId,
            trackLookupPrefix: 'local-prefix',
          ),
        ],
    participantCount: const SfuParticipantCount(total: 1, anonymous: 0),
    startedAt: DateTime(2026),
    pins: pins,
    e2eeEnabled: e2eeEnabled,
  );
}
