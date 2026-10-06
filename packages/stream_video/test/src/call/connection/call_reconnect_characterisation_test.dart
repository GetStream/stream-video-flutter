import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_call_ended_reason.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

/// Pins how the reconnect loop gives up, and how it reacts to leaving and to
/// a remote end, so moving the connection code out of `Call` cannot change it
/// unnoticed.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness());
  tearDown(() => harness.dispose());

  void verifyFastReconnectCount(int count) {
    (count == 0 ? verifyNever : verify)(
      () => harness.session.fastReconnect(
        reconnectDetails: any(named: 'reconnectDetails'),
        capabilities: any(named: 'capabilities'),
        unifiedSessionId: any(named: 'unifiedSessionId'),
      ),
    ).called(count);
  }

  group('giving up', () {
    test(
      'reconnectTimeout expiry fails the reconnect and leaves the call',
      () async {
        final call = harness.buildCall(
          preferences: DefaultCallPreferences(
            reconnectTimeout: const Duration(milliseconds: 200),
          ),
        );
        await call.join();

        // From here on every attempt fails: the fast reconnects, and the
        // session starts of the rejoins they escalate to.
        harness
          ..stubFastReconnect(
            harness.session,
            () async => const Result.failure(
              StreamVideoException(message: 'fast reconnect failed'),
            ),
          )
          ..stubSessionStart(
            harness.session,
            () async => const Result.failure(
              StreamVideoException(message: 'sfu unreachable'),
            ),
          );
        final statuses = recordStatuses(call);

        await harness.emitSfu(harness.session, sfuSocketDropped);
        await waitUntil(() => call.state.value.status.isDisconnected);

        // How many attempts fit in the timeout varies; every status between
        // connected and giving up is a reconnecting one.
        expect(statuses.first, isA<CallStatusConnected>());
        expect(
          statuses.sublist(1, statuses.length - 2),
          everyElement(isA<CallStatusReconnecting>()),
        );
        expect(statuses.sublist(statuses.length - 2), [
          isA<CallStatusReconnectionFailed>(),
          isA<CallStatusDisconnected>(),
        ]);
        verify(
          () => harness.session.leave(reason: 'reconnection failed'),
        ).called(1);
        final status = call.state.value.status as CallStatusDisconnected;
        expect(status.reason, isA<DisconnectReasonReconnectionFailed>());
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.networkOffline,
        ]);
      },
    );

    test(
      'an unrecoverable API error raised in the loop ends it without retrying',
      () async {
        final call = harness.buildCall();
        await call.join();
        harness.reporter.onReportJoinAttempt = () {
          throw const StreamApiException(
            message: 'forbidden',
            statusCode: 403,
            unrecoverable: true,
          );
        };
        final statuses = recordStatuses(call);

        // A reconnect triggered by the network reports a join attempt, which
        // is where the error is raised. That call sits in the loop body
        // outside the join, so this pins the scope of the loop's catch.
        harness.internetStatus.add(InternetStatus.disconnected);
        await pumpEventQueue();
        harness.internetStatus.add(InternetStatus.connected);
        await waitUntil(() => call.state.value.status.isDisconnected);

        expect(harness.reporter.joinAttempts, [JoinReason.networkAvailable]);
        verifyFastReconnectCount(0);
        expect(statuses, contains(isA<CallStatusReconnectionFailed>()));
        final status = call.state.value.status as CallStatusDisconnected;
        expect(status.reason, isA<DisconnectReasonReconnectionFailed>());
      },
    );

    test(
      'an unrecoverable API error thrown by a fast reconnect leaves the call '
      'as a join failure, without ReconnectionFailed',
      () async {
        final call = harness.buildCall();
        await call.join();
        harness.stubFastReconnect(harness.session, () async {
          // The join turns a throw into a failure carrying it, and treats an
          // unrecoverable cause like an unrecoverable coordinator refusal.
          throw const StreamApiException(
            message: 'forbidden',
            statusCode: 403,
            unrecoverable: true,
          );
        });
        final statuses = recordStatuses(call);

        await harness.emitSfu(harness.session, sfuSocketDropped);
        await waitUntil(() => call.state.value.status.isDisconnected);
        await pumpEventQueue();

        verifyFastReconnectCount(1);
        expect(statuses, isNot(contains(isA<CallStatusReconnectionFailed>())));
        final status = call.state.value.status as CallStatusDisconnected;
        expect(status.reason, isA<DisconnectReasonFailure>());
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
        ]);
      },
    );
  });

  test('a socket drop during a leave does not reconnect', () async {
    final call = harness.buildCall();
    await call.join();
    final statuses = recordStatuses(call);
    final disposeGate = Completer<void>();
    when(harness.session.dispose).thenAnswer((_) => disposeGate.future);

    final leave = call.leave();
    await pumpEventQueue();
    await harness.emitSfu(harness.session, sfuSocketDropped);
    disposeGate.complete();
    await leave;
    await pumpEventQueue();

    verifyFastReconnectCount(0);
    expect(statuses, isNot(contains(isA<CallStatusReconnecting>())));
    expect(call.state.value.status, isA<CallStatusDisconnected>());
  });

  group('known hazard', () {
    // Changes with FLU-864: leaving during the network wait settles
    // disconnected without passing through ReconnectionFailed or reporting
    // the network as offline.
    test(
      'leave during the network wait passes through ReconnectionFailed and '
      'reports a second, offline abort',
      () async {
        final call = harness.buildCall();
        await call.join();
        final statuses = recordStatuses(call);

        harness.internetStatus.add(InternetStatus.disconnected);
        await pumpEventQueue();
        expect(call.state.value.status, isA<CallStatusReconnecting>());

        await call.leave();
        await pumpEventQueue();

        expect(statuses, contains(isA<CallStatusReconnectionFailed>()));
        expect(call.state.value.status, isA<CallStatusDisconnected>());
        expect(harness.reporter.aborts, [
          ClientEventStandardCode.clientAborted,
          ClientEventStandardCode.networkOffline,
        ]);
      },
    );

    // Changes with FLU-864: a remote end goes through the same leaving
    // transition as a local one, which tells the SFU.
    test(
      'an SFU call end during a reconnect settles disconnected without an '
      'SFU leave',
      () async {
        final call = harness.buildCall();
        await call.join();

        final reconnectGate = Completer<void>();
        harness.stubFastReconnect(harness.session, () async {
          await reconnectGate.future;
          return sessionStartSuccess();
        });
        await harness.emitSfu(harness.session, sfuSocketDropped);
        expect(call.state.value.status, isA<CallStatusReconnecting>());

        await harness.emitSfu(
          harness.session,
          const SfuCallEndedEvent(callEndedReason: SfuCallEndedReason.ended),
        );
        reconnectGate.complete();
        await pumpEventQueue();

        final status = call.state.value.status as CallStatusDisconnected;
        expect(status.reason, isA<DisconnectReasonEnded>());
        verifyNever(() => harness.session.leave(reason: any(named: 'reason')));
        expect(harness.reporter.aborts, isEmpty);
      },
    );
  });
}
