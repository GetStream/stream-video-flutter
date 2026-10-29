import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart'
    as sfu_events;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/call/session/call_session_config.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/events/sfu_event_mapper_extensions.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/sfu_client.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';
import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
    registerFallbackValue(sfu.SendAnswerRequest());
  });

  late MockSfuClient sfuClient;
  late MockRtcManager rtcManager;
  late CallSession session;

  setUp(() {
    sfuClient = MockSfuClient();
    when(() => sfuClient.sendAnswer(any())).thenAnswer(
      (_) async => Result.success(sfu.SendAnswerResponse()),
    );
    rtcManager = MockRtcManager();
    when(rtcManager.dispose).thenAnswer((_) async {});
    session = _buildTestSession(sfuClient: sfuClient)..rtcManager = rtcManager;
  });

  test('the answer echoes the offer negotiation id', () async {
    when(
      () => rtcManager.onSubscriberOffer(any()),
    ).thenAnswer((_) async => 'answer-sdp');

    await session.debugHandleSfuEvent(_offer);

    final request =
        verify(() => sfuClient.sendAnswer(captureAny())).captured.single
            as sfu.SendAnswerRequest;
    expect(request.sdp, 'answer-sdp');
    expect(request.sessionId, 'test-session');
    expect(request.negotiationId, 42);
  });

  test('no answer is sent when the session closes mid-offer', () async {
    final answer = Completer<String?>();
    when(
      () => rtcManager.onSubscriberOffer(any()),
    ).thenAnswer((_) => answer.future);

    final handled = session.debugHandleSfuEvent(_offer);
    await session.close(CloseCode.normalClosure);
    answer.complete('answer-sdp');
    await handled;

    verifyNever(() => sfuClient.sendAnswer(any()));
  });

  test('no answer is sent when the session leaves mid-offer', () async {
    final answer = Completer<String?>();
    when(
      () => rtcManager.onSubscriberOffer(any()),
    ).thenAnswer((_) => answer.future);

    final handled = session.debugHandleSfuEvent(_offer);
    session.leave(reason: 'test');
    answer.complete('answer-sdp');
    await handled;

    verifyNever(() => sfuClient.sendAnswer(any()));
  });

  test('the SFU subscriber offer maps its negotiation id', () {
    final event = sfu_events.SfuEvent(
      subscriberOffer: sfu_events.SubscriberOffer(
        sdp: 'offer-sdp',
        iceRestart: true,
        negotiationId: 7,
      ),
    ).toDomain();

    expect(
      event,
      const SfuSubscriberOfferEvent(
        sdp: 'offer-sdp',
        iceRestart: true,
        negotiationId: 7,
      ),
    );
  });
}

const _offer = SfuSubscriberOfferEvent(
  sdp: 'offer-sdp',
  iceRestart: false,
  negotiationId: 42,
);

CallSession _buildTestSession({required SfuClient sfuClient}) {
  final callCid = SampleCallData.defaultCid;
  final stateManager = createTestCallStateManager();
  final host = setupMockCallHost();
  when(() => host.apiKey).thenReturn('test-api-key');

  return CallSession(
    retryPolicy: const RetryPolicy(),
    callCid: callCid,
    sessionSeq: 0,
    sessionId: 'test-session',
    config: const CallSessionConfig(
      sfuName: 'test-sfu',
      sfuToken: 'test-token',
      sfuUrl: 'https://test.example.com',
      sfuWsEndpoint: 'wss://test.example.com/ws',
      rtcConfig: RTCConfiguration(),
    ),
    stateManager: stateManager,
    dynascaleManager: DynascaleManager(stateManager: stateManager),
    onReconnectionNeeded: (_, _, _) {},
    onIceConnected: (_) {},
    onSuspendedAudioTrackRecorded: (_) {},
    sdpEditor: MockSdpEditor(),
    networkMonitor: setupMockInternetConnection(),
    statsOptions: const StatsOptions(
      enableRtcStats: false,
      reportingIntervalMs: 500,
    ),
    host: host,
    tracer: Tracer(null),
    pcFactory: StreamPeerConnectionFactory(callCid: callCid),
    sfuClient: sfuClient,
  );
}
