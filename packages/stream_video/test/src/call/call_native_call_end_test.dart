import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';
import 'fixtures/connection_harness.dart';
import 'fixtures/data.dart';

class _MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

/// Runs the defaults [PushNotificationManager] gives a class that extends
/// it; everything else is mocked. Mixing in mocktail's class is what keeps
/// the defaults.
// ignore: prefer_mixin
class _DefaultsManager extends PushNotificationManager with Mock {}

/// Pins what a call tells the native call UI (CallKit on iOS, the
/// notification and Telecom on Android) through [PushNotificationManager]:
/// that its ring is over or that it was left once it is left, that a ring
/// the user has not answered is left when the backend ends the call or
/// nobody is left in it, and that the user accepted it in the app. What each
/// of these does natively is the push manager's.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  final cid = SampleCallData.defaultCid.value;

  late ConnectionHarness harness;
  late _MockPushNotificationManager manager;

  setUp(() {
    harness = ConnectionHarness();
    manager = _MockPushNotificationManager();
    when(
      () => harness.streamVideo.pushNotificationManager,
    ).thenReturn(manager);
    when(() => manager.onRingEnded(any())).thenAnswer((_) async {});
    when(() => manager.onCallLeft(any())).thenAnswer((_) async {});
    when(() => manager.onCallAccepted(any())).thenAnswer((_) async {});
    when(
      () => harness.coordinatorClient.rejectCall(
        cid: any(named: 'cid'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
  });
  tearDown(() => harness.dispose());

  void verifyNothingTold() {
    verifyNever(() => manager.onRingEnded(any()));
    verifyNever(() => manager.onCallLeft(any()));
    // Core says what happened; ending is the manager's.
    verifyNever(
      () => manager.endCallByCid(any(), silent: any(named: 'silent')),
    );
  }

  /// A ring of [cid] the current user has not answered, or has.
  Call ringingCall({bool acceptedByMe = false}) => harness.buildCall(
    status: CallStatus.incoming(acceptedByMe: acceptedByMe),
    isRingingFlow: true,
  );

  /// Marks [call] as the one that accepted [cid] on this device.
  void acceptedHereBy(Call call) {
    final state = harness.streamVideo.state;
    when(
      () => state.callAcceptedOnThisDevice(SampleCallData.defaultCid),
    ).thenReturn(call);
  }

  group('leaving', () {
    test('a joined call tells the native call UI it was left', () async {
      final call = harness.buildCall();
      await call.join();

      await call.leave();

      verify(() => manager.onCallLeft(cid)).called(1);
      verifyNever(() => manager.onRingEnded(any()));
    });

    test(
      'a joined call tells nothing when another instance joined the same '
      'call',
      () async {
        final call = harness.buildCall();
        await call.join();
        final other = createStubCall(
          stateManager: createTestCallStateManager(),
        );
        (harness.streamVideo.state.activeCalls
                as MutableStateEmitter<List<Call>>)
            .value = [
          other,
        ];

        await call.leave();

        verifyNothingTold();
      },
    );

    test(
      'a call still listed as active itself tells that it was left',
      () async {
        final call = harness.buildCall();
        await call.join();
        (harness.streamVideo.state.activeCalls
                as MutableStateEmitter<List<Call>>)
            .value = [
          call,
        ];

        await call.leave();

        verify(() => manager.onCallLeft(cid)).called(1);
      },
    );

    test('a ring the user has not answered tells its ring is over', () async {
      final call = ringingCall();

      await call.leave();

      verify(() => manager.onRingEnded(cid)).called(1);
      verifyNever(() => manager.onCallLeft(any()));
    });

    test(
      'a ring whose join waits for the answer tells its ring is over',
      () async {
        final call = ringingCall();
        // An incoming-call screen that joins as soon as the call rings: the
        // join waits for the user to answer.
        final joining = call.join();
        await pumpEventQueue();

        await call.leave();
        await joining;

        verify(() => manager.onRingEnded(cid)).called(1);
        verifyNever(() => manager.onCallLeft(any()));
      },
    );

    test(
      'a ring accepted elsewhere and not joined here tells its ring is over',
      () async {
        final call = ringingCall(acceptedByMe: true);

        await call.leave();

        verify(() => manager.onRingEnded(cid)).called(1);
      },
    );

    test(
      'a ring this instance accepted tells it was left, like a joined call',
      () async {
        final call = ringingCall(acceptedByMe: true);
        acceptedHereBy(call);

        await call.leave();

        verify(() => manager.onCallLeft(cid)).called(1);
        verifyNever(() => manager.onRingEnded(any()));
      },
    );

    test(
      'a ring another instance accepted on this device tells nothing',
      () async {
        final call = ringingCall();
        acceptedHereBy(
          createStubCall(stateManager: createTestCallStateManager()),
        );

        await call.leave();

        verifyNothingTold();
      },
    );

    test('an outgoing ring tells its ring is over', () async {
      final call = harness.buildCall(
        status: CallStatus.outgoing(),
        isRingingFlow: true,
      );

      await call.leave();

      verify(() => manager.onRingEnded(cid)).called(1);
    });

    test('a call only watched tells nothing', () async {
      final call = harness.buildCall(status: CallStatus.idle());

      await call.leave();

      verifyNothingTold();
    });

    test('a second time tells nothing again', () async {
      final call = harness.buildCall();
      await call.join();
      await call.leave();

      await call.leave();

      verify(() => manager.onCallLeft(cid)).called(1);
    });

    test('a teardown that throws still tells the call was left', () async {
      final call = harness.buildCall();
      await call.join();
      // Stubbed on the state itself: a stub through the host's getter
      // would make the getter throw instead.
      final hostState = harness.streamVideo.state;
      when(
        () => hostState.removeActiveCall(any()),
      ).thenThrow(StateError('teardown failed'));

      await expectLater(call.leave(), throwsStateError);

      verify(() => manager.onCallLeft(cid)).called(1);
    });

    test('a native call UI that fails still leaves the call', () async {
      when(
        () => manager.onRingEnded(any()),
      ).thenThrow(StateError('channel'));
      final call = ringingCall();

      await call.leave();

      expect(call.state.value.status, isA<CallStatusDisconnected>());
    });
  });

  group('disposing', () {
    test('a ring the user has not answered tells its ring is over', () async {
      final call = ringingCall();

      await call.dispose();

      verify(() => manager.onRingEnded(cid)).called(1);
    });

    test('a ring this instance accepted tells it was left', () async {
      final call = ringingCall(acceptedByMe: true);
      acceptedHereBy(call);

      await call.dispose();

      verify(() => manager.onCallLeft(cid)).called(1);
      verifyNever(() => manager.onRingEnded(any()));
    });

    test('a ring another instance accepted tells nothing', () async {
      final call = ringingCall();
      acceptedHereBy(
        createStubCall(stateManager: createTestCallStateManager()),
      );

      await call.dispose();

      verifyNothingTold();
    });
  });

  group('a ring the user has not answered', () {
    StreamCallEndedEvent ended() => StreamCallEndedEvent(
      SampleCallData.defaultCid,
      endedBy: SampleCallData.defaultCallUser,
      createdAt: DateTime.now(),
      metadata: SampleCallData.defaultCallMetadata,
      type: 'call.ended',
    );

    StreamCallSessionParticipantCountUpdatedEvent participants(
      Map<String, int> byRole,
    ) => StreamCallSessionParticipantCountUpdatedEvent(
      SampleCallData.defaultCid,
      createdAt: DateTime.now(),
      sessionId: 'session',
      participantsCountByRole: byRole,
      anonymousParticipantCount: 0,
    );

    test('is left when the backend ends the call', () async {
      final call = ringingCall();

      harness.coordinatorEvents.emit(ended());
      await pumpEventQueue();

      expect(
        call.state.value.status,
        isA<CallStatusDisconnected>().having(
          (status) => status.reason,
          'reason',
          const DisconnectReason.ended(),
        ),
      );
      verify(() => manager.onRingEnded(cid)).called(1);
    });

    test('is left once nobody is left in the call', () async {
      final call = ringingCall();

      harness.coordinatorEvents.emit(participants(const {'user': 0}));
      await pumpEventQueue();

      expect(
        call.state.value.status,
        isA<CallStatusDisconnected>().having(
          (status) => status.reason,
          'reason',
          DisconnectReason.lastParticipantLeft(),
        ),
      );
      verify(() => manager.onRingEnded(cid)).called(1);
    });

    test('is left when the user accepts it on another device', () async {
      final call = ringingCall();

      harness.coordinatorEvents.emit(
        StreamCallAcceptedEvent(
          call.callCid,
          acceptedBy: SampleCallData.defaultCallUser,
          createdAt: DateTime.now(),
          metadata: SampleCallData.createCallMetadata(),
        ),
      );
      await pumpEventQueue();

      expect(call.state.value.status, isA<CallStatusDisconnected>());
      verify(() => manager.onRingEnded(cid)).called(1);
    });

    test('is left when the user declines it on another device', () async {
      final call = ringingCall();

      harness.coordinatorEvents.emit(
        StreamCallRejectedEvent(
          call.callCid,
          rejectedBy: SampleCallData.defaultCallUser,
          createdAt: DateTime.now(),
          metadata: SampleCallData.createCallMetadata(),
        ),
      );
      await pumpEventQueue();

      expect(call.state.value.status, isA<CallStatusDisconnected>());
      verify(() => manager.onRingEnded(cid)).called(1);
    });

    test('keeps ringing while someone is in the call', () async {
      final call = ringingCall();

      harness.coordinatorEvents.emit(participants(const {'user': 1}));
      await pumpEventQueue();

      expect(call.state.value.status, isA<CallStatusIncoming>());
      verifyNothingTold();
    });

    test('that the user accepted is not left once nobody is left', () async {
      final call = ringingCall(acceptedByMe: true);

      harness.coordinatorEvents.emit(participants(const {}));
      await pumpEventQueue();

      expect(call.state.value.status, isA<CallStatusIncoming>());
      verifyNothingTold();
    });
  });

  group('accepting in the app', () {
    setUp(() {
      when(
        () => harness.coordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => const Result.success(none));
    });

    test('tells the native call UI the user accepted it', () async {
      final call = ringingCall();

      final result = await call.accept();

      expect(result.isSuccess, isTrue);
      verify(() => manager.onCallAccepted(cid)).called(1);
      verifyNothingTold();
    });

    test('tells nothing when the accept fails', () async {
      when(
        () => harness.coordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => failureWithError('rejected'));
      final call = ringingCall();

      final result = await call.accept();

      expect(result.isFailure, isTrue);
      verifyNever(() => manager.onCallAccepted(any()));
    });

    test(
      'tells it for an accept the server applied, though its response failed',
      () async {
        final call = ringingCall();
        when(
          () => harness.coordinatorClient.acceptCall(cid: any(named: 'cid')),
        ).thenAnswer((_) async {
          harness.coordinatorEvents.emit(
            StreamCallAcceptedEvent(
              call.callCid,
              acceptedBy: SampleCallData.defaultCallUser,
              createdAt: DateTime.now(),
              metadata: SampleCallData.createCallMetadata(),
            ),
          );
          await pumpEventQueue();
          return failureWithError('timed out');
        });

        final result = await call.accept();

        expect(result.isSuccess, isTrue);
        verify(() => manager.onCallAccepted(cid)).called(1);
      },
    );

    test('a native call UI that fails still accepts', () async {
      when(
        () => manager.onCallAccepted(any()),
      ).thenThrow(StateError('channel'));
      final call = ringingCall();

      final result = await call.accept();

      expect(result.isSuccess, isTrue);
    });
  });

  group('the manager defaults', () {
    late _DefaultsManager defaults;

    setUp(() {
      defaults = _DefaultsManager();
      when(
        () => defaults.endCallByCid(any(), silent: any(named: 'silent')),
      ).thenAnswer((_) async {});
      when(defaults.activeCalls).thenAnswer((_) async => const []);
    });

    test('end a ring that is over silently', () async {
      await defaults.onRingEnded(cid);

      verify(() => defaults.endCallByCid(cid, silent: true)).called(1);
    });

    test('keep a ring answered on the native call screen', () async {
      when(defaults.activeCalls).thenAnswer(
        (_) async => [CallData(callCid: cid, isAccepted: true)],
      );

      await defaults.onRingEnded(cid);

      verifyNever(
        () => defaults.endCallByCid(any(), silent: any(named: 'silent')),
      );
    });

    test('end a call left', () async {
      await defaults.onCallLeft(cid);

      verify(() => defaults.endCallByCid(cid)).called(1);
    });

    test('do nothing for an accept', () async {
      await defaults.onCallAccepted(cid);

      verifyNever(defaults.activeCalls);
      verifyNever(
        () => defaults.endCallByCid(any(), silent: any(named: 'silent')),
      );
    });
  });
}
