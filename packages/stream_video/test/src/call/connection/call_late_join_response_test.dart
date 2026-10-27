import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/coordinator/models/coordinator_models.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';
import '../fixtures/data.dart';

/// A coordinator answer for a call with auto-on noise cancellation, whose
/// user may enable it.
CoordinatorJoined _autoOnJoined() {
  final details = SampleCallData.defaultCallMetadata.details;
  return CoordinatorJoined(
    wasCreated: true,
    members: const {},
    users: const {},
    duration: '0',
    statsOptions: const StatsOptions(
      enableRtcStats: true,
      reportingIntervalMs: 5000,
    ),
    ownCapabilities: const [CallPermission.enableNoiseCancellation],
    metadata: CallMetadata(
      cid: SampleCallData.defaultCid,
      details: CallDetails(
        createdAt: details.createdAt,
        updatedAt: details.updatedAt,
        createdBy: details.createdBy,
        team: details.team,
        ownCapabilities: const [CallPermission.enableNoiseCancellation],
        blockedUserIds: const [],
        broadcasting: false,
        recording: false,
        backstage: false,
        transcribing: false,
        captioning: false,
        custom: const {},
        egress: const CallEgress(),
        rtmpIngress: '',
      ),
      settings: const CallSettings(
        audio: StreamAudioSettings(
          noiseCancellation: StreamNoiceCancellingSettings(
            mode: NoiseCancellationSettingsMode.autoOn,
          ),
        ),
      ),
      session: const CallSessionData(),
      users: const {},
      members: const {},
    ),
    credentials: SampleCallData.defaultCredentials,
  );
}

/// The coordinator join request is not cancelled by a leave, so its answer
/// can arrive after one. That answer must leave the call as the leave did.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;
  late Completer<Result<CoordinatorJoined>> joinAnswer;
  late bool joinRequested;

  setUp(() {
    harness = ConnectionHarness();
    joinAnswer = Completer();
    joinRequested = false;
    harness.stubJoinCall(() {
      joinRequested = true;
      return joinAnswer.future;
    });

    when(harness.streamVideo.isAudioProcessorConfigured).thenReturn(true);
    when(
      harness.streamVideo.deviceSupportsAdvancedAudioProcessing,
    ).thenAnswer((_) async => const Result.success(true));
    when(
      () => harness.streamVideo.setAudioProcessingEnabled(any()),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      () => harness.permissionsManager.hasPermission(
        CallPermission.enableNoiseCancellation,
      ),
    ).thenReturn(true);
  });
  tearDown(() => harness.dispose());

  /// Starts a join, leaves while the coordinator has not answered, then
  /// answers it successfully.
  Future<Call> leaveBeforeTheAnswer() async {
    final call = harness.buildCall();
    final join = call.join();
    await waitUntil(() => joinRequested);
    // Resets the count, so a test can tell a retry from this request.
    harness.verifyJoinCallCount(1);

    await call.leave();
    joinAnswer.complete(Result.success(_autoOnJoined()));
    await join;
    await pumpEventQueue();
    return call;
  }

  test('starts no SFU session and does not retry', () async {
    await leaveBeforeTheAnswer();

    harness
      ..verifyMakeCallSessionCount(0)
      ..verifyJoinCallCount(0);
  });

  test('does not apply the answer to the left call', () async {
    final call = await leaveBeforeTheAnswer();

    final state = call.state.value;
    expect(state.status, isA<CallStatusDisconnected>());
    expect(state.ownCapabilities, isEmpty);
    expect(state.settings.audio.noiseCancellation, isNull);
  });

  test('does not start auto-on noise cancellation', () async {
    await leaveBeforeTheAnswer();

    verifyNever(harness.streamVideo.deviceSupportsAdvancedAudioProcessing);
    verifyNever(() => harness.streamVideo.setAudioProcessingEnabled(true));
  });

  test('an end during the join closes the coordinator join stage', () async {
    when(
      () => harness.permissionsManager.endCall(),
    ).thenAnswer((_) async => const Result.success(none));
    final call = harness.buildCall();
    final join = call.join();
    await waitUntil(() => joinRequested);

    // Unlike a leave, an end aborts no telemetry stage.
    await call.end();
    joinAnswer.complete(Result.success(_autoOnJoined()));
    await join;
    await pumpEventQueue();

    expect(harness.reporter.aborts, isEmpty);
    expect(harness.reporter.stageFailures, [
      ClientEventStandardCode.clientAborted,
    ]);
    harness.verifyMakeCallSessionCount(0);
    expect(call.state.value.ownCapabilities, isEmpty);
  });

  test('the same answer before a leave is applied', () async {
    when(
      harness.session.notifyNoiseCancellationStarted,
    ).thenAnswer((_) async => const Result.success(none));
    final call = harness.buildCall();
    joinAnswer.complete(Result.success(_autoOnJoined()));

    await call.join();
    await pumpEventQueue();

    harness.verifyMakeCallSessionCount(1);
    expect(
      call.state.value.ownCapabilities,
      contains(CallPermission.enableNoiseCancellation),
    );
    verify(() => harness.streamVideo.setAudioProcessingEnabled(true)).called(1);
  });
}
