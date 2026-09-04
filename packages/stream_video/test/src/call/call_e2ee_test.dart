import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

class MockEncryptionManager extends Mock implements EncryptionManager {}

/// A state manager for a second, distinct call.
CallStateNotifier _otherCallStateManager() {
  return CallStateNotifier(
    createTestCallState(
      callCid: StreamCallCid.from(
        id: 'other-call',
        type: StreamCallType.defaultType(),
      ),
    ),
  );
}

class MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() {
    return Future.value();
  }
}

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Call E2EE', () {
    late MockEncryptionManager e2ee;

    setUp(() {
      e2ee = MockEncryptionManager();
      when(() => e2ee.userId).thenReturn('test-user');
      when(() => e2ee.algorithm).thenReturn(EncryptionAlgorithm.aes128Gcm);
      when(
        () => e2ee.events,
      ).thenAnswer((_) => const Stream<E2eeEvent>.empty());
      when(() => e2ee.isDisposed).thenReturn(false);
      when(() => e2ee.dispose()).thenAnswer((_) async {});
    });

    // The claim registry is static and every case here shares one cid.
    tearDown(Call.resetE2EEClaims);

    test('refuses a manager once the call is already connecting', () async {
      final call = createTestCall();

      // The window this closes: the join request carries
      // `e2ee: <manager != null>` and the session captures the manager by
      // value, both well before an RtcManager exists. A manager accepted here
      // would be held by the Call and used by neither, so every local track
      // would publish in the clear while `e2eeManager` reported otherwise.
      //
      // Reachable from the SDK itself: `_onCallAccept` starts the join without
      // awaiting it and then hands the call to `onCallAccepted`.
      await call.join();

      expect(call.state.value.status.isActive, isTrue);
      expect(() => call.setE2EEManager(e2ee), throwsStateError);
      expect(call.e2eeManager, isNull);
    });

    test('is off until a manager is attached', () {
      final call = createTestCall();

      expect(call.e2eeManager, isNull);
    });

    test('exposes the manager once attached', () async {
      final call = createTestCall();

      await call.setE2EEManager(e2ee);

      expect(call.e2eeManager, same(e2ee));
    });

    test(
      'join reports an encrypted session when a manager is attached',
      () async {
        final coordinatorClient = setupMockCoordinatorClient();
        final call = createTestCall(coordinatorClient: coordinatorClient);

        await call.setE2EEManager(e2ee);
        final result = await call.join();

        expect(result.isSuccess, isTrue);
        verify(
          () => coordinatorClient.joinCall(
            callCid: SampleCallData.defaultCid,
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
            hintHighScaleLivestreamPublisher: any(
              named: 'hintHighScaleLivestreamPublisher',
            ),
            e2ee: true,
          ),
        ).called(1);
      },
    );

    test(
      'join reports an unencrypted session when no manager is attached',
      () async {
        final coordinatorClient = setupMockCoordinatorClient();
        final call = createTestCall(coordinatorClient: coordinatorClient);

        await call.join();

        verify(
          () => coordinatorClient.joinCall(
            callCid: SampleCallData.defaultCid,
            ringing: any(named: 'ringing'),
            create: any(named: 'create'),
            migratingFrom: any(named: 'migratingFrom'),
            migratingFromList: any(named: 'migratingFromList'),
            video: any(named: 'video'),
            membersLimit: any(named: 'membersLimit'),
            hintHighScaleLivestreamPublisher: any(
              named: 'hintHighScaleLivestreamPublisher',
            ),
            e2ee: false,
          ),
        ).called(1);
      },
    );

    test(
      'the manager reaches the session that builds the peer connections',
      () async {
        final callSession = setupMockCallSession();
        final sessionFactory = setupMockSessionFactory(
          callSession: callSession,
        );
        final call = createTestCall(sessionFactory: sessionFactory);

        await call.setE2EEManager(e2ee);
        await call.join();

        final captured = verify(
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
            e2eeManager: captureAny(named: 'e2eeManager'),
          ),
        ).captured;

        expect(captured, isNotEmpty);
        expect(captured.last, same(e2ee));
      },
    );

    // Ringing calls sit in an active status for their whole pre-join life, and
    // the key resolver exists mostly for them, so a guard that keyed off
    // "active" locked encryption out of the flow it was built for.
    for (final (label, status) in [
      ('an accepted incoming call', CallStatus.incoming(acceptedByMe: true)),
      ('a ringing incoming call', CallStatus.incoming()),
      ('an outgoing ringing call', CallStatus.outgoing()),
    ]) {
      test('accepts a manager on $label', () async {
        final call = createTestCallWithState(
          initialState: createTestCallState().copyWith(status: status),
        );

        await call.setE2EEManager(e2ee);

        expect(call.e2eeManager, same(e2ee));
      });
    }

    test('refuses a manager once the connect has begun', () async {
      final call = createTestCallWithState(
        initialState: createTestCallState().copyWith(
          status: CallStatus.connecting(),
        ),
      );

      // The join request carries `e2ee: <manager != null>` and the session
      // captures the manager as it is built, so this is the cutoff.
      expect(() => call.setE2EEManager(e2ee), throwsStateError);
      expect(call.e2eeManager, isNull);
    });

    test('rejects a manager once peer connections exist', () async {
      final callSession = setupMockCallSession();
      when(() => callSession.rtcManager).thenReturn(MockRtcManager());

      final call = createTestCall(
        sessionFactory: setupMockSessionFactory(callSession: callSession),
      );

      await call.join();

      // Those peer connections were negotiated without an encryptor, so
      // adopting one now would publish cleartext while claiming encryption.
      expect(
        () => call.setE2EEManager(e2ee),
        throwsA(isA<StateError>()),
      );
      expect(call.e2eeManager, isNull);
    });

    test('refuses a manager already attached to another call', () async {
      final callA = createTestCall();
      final callB = createTestCall(stateManager: _otherCallStateManager());

      await callA.setE2EEManager(e2ee);

      // One key store between two calls means each overwrites the other's
      // key at the same index, and decryption starts failing for no visible
      // reason. Refuse instead.
      expect(() => callB.setE2EEManager(e2ee), throwsA(isA<StateError>()));
      expect(callB.e2eeManager, isNull);
      expect(callA.e2eeManager, same(e2ee));
    });

    test('re-attaching the same manager to the same call is allowed', () async {
      final call = createTestCall();

      await call.setE2EEManager(e2ee);
      await call.setE2EEManager(e2ee);

      expect(call.e2eeManager, same(e2ee));
    });

    test('refuses a second, different manager on the same call', () async {
      final call = createTestCall();
      final other = MockEncryptionManager();
      when(() => other.userId).thenReturn('test-user');
      when(() => other.isDisposed).thenReturn(false);
      when(
        () => other.events,
      ).thenAnswer((_) => const Stream<E2eeEvent>.empty());

      await call.setE2EEManager(e2ee);

      // Overwriting would drop the first manager while it still holds a
      // native key store: nothing else references it, so the handle leaks.
      expect(() => call.setE2EEManager(other), throwsA(isA<StateError>()));
      expect(call.e2eeManager, same(e2ee));
      verifyNever(() => e2ee.dispose());
    });

    test('refuses a disposed manager', () async {
      final call = createTestCall();
      when(() => e2ee.isDisposed).thenReturn(true);

      expect(() => call.setE2EEManager(e2ee), throwsA(isA<StateError>()));
      expect(call.e2eeManager, isNull);
    });

    test('clearE2EEManager releases the native manager', () async {
      final call = createTestCall();
      await call.setE2EEManager(e2ee);

      await call.clearE2EEManager();

      // Nothing else ever releases it: the manager outlives leave() by
      // design, and each live one holds a key store and a crypto thread.
      verify(() => e2ee.dispose()).called(1);
      expect(call.e2eeManager, isNull);
    });

    test('clearE2EEManager is a no-op when nothing is attached', () async {
      final call = createTestCall();

      await call.clearE2EEManager();

      verifyNever(() => e2ee.dispose());
      expect(call.e2eeManager, isNull);
    });

    test('a cleared call joins unencrypted again', () async {
      final coordinatorClient = setupMockCoordinatorClient();
      final call = createTestCall(coordinatorClient: coordinatorClient);

      await call.setE2EEManager(e2ee);
      await call.clearE2EEManager();
      await call.join();

      verify(
        () => coordinatorClient.joinCall(
          callCid: SampleCallData.defaultCid,
          ringing: any(named: 'ringing'),
          create: any(named: 'create'),
          migratingFrom: any(named: 'migratingFrom'),
          migratingFromList: any(named: 'migratingFromList'),
          video: any(named: 'video'),
          membersLimit: any(named: 'membersLimit'),
          hintHighScaleLivestreamPublisher: any(
            named: 'hintHighScaleLivestreamPublisher',
          ),
          e2ee: false,
        ),
      ).called(1);
    });

    test(
      'releases and disposes the manager when the call is left',
      () async {
        final coordinatorClient = setupMockCoordinatorClient();
        final call = createTestCall(coordinatorClient: coordinatorClient);

        await call.setE2EEManager(e2ee);
        await call.join();
        await call.leave();

        // A Call cannot be rejoined, so holding the manager would only pin a
        // native key store and a crypto thread with nothing left to use them.
        expect(call.e2eeManager, isNull);
        verify(() => e2ee.dispose()).called(1);
      },
    );

    test(
      'leaving frees the cid for the next call to bring its own manager',
      () async {
        final callA = createTestCall();

        await callA.setE2EEManager(e2ee);
        await callA.join();
        await callA.leave();

        // Ownership is released with it, so a fresh Call for the same cid can
        // take a new manager without tripping the one-manager-per-call guard.
        final callB = createTestCall();
        final other = MockEncryptionManager();
        when(() => other.userId).thenReturn('test-user');
        when(() => other.isDisposed).thenReturn(false);
        when(
          () => other.events,
        ).thenAnswer((_) => const Stream<E2eeEvent>.empty());

        await callB.setE2EEManager(other);

        expect(callB.e2eeManager, same(other));
      },
    );

    test(
      'refuses a manager when another instance of the call already has one',
      () async {
        final first = createTestCall();
        await first.setE2EEManager(e2ee);

        // Same cid, two key stores: whichever session a peer decrypts, the
        // other is noise, and that is indistinguishable from a wrong key.
        final second = createTestCall();
        final other = MockEncryptionManager();
        when(() => other.isDisposed).thenReturn(false);

        expect(
          () => second.setE2EEManager(other),
          throwsA(isA<StateError>()),
        );
        expect(second.e2eeManager, isNull);
        expect(first.e2eeManager, same(e2ee));
      },
    );

    test(
      'refuses the same manager on another instance of the call',
      () async {
        // Tempting to allow, since there is only one key store to disagree
        // about. But it would then have two owners: whichever call is released
        // first disposes it out from under the other, and both write keys at
        // the same indexes.
        final first = createTestCall();
        await first.setE2EEManager(e2ee);

        final second = createTestCall();

        expect(() => second.setE2EEManager(e2ee), throwsStateError);
        expect(second.e2eeManager, isNull);
      },
    );

    test('leaving disposes an attached manager', () async {
      final call = createTestCall();
      await call.setE2EEManager(e2ee);

      await call.leave();

      // Which is why the hand-off detaches first. Reattaching this one would
      // throw, since a disposed manager holds no keys.
      verify(() => e2ee.dispose()).called(1);
      expect(call.e2eeManager, isNull);
    });

    test('releasing the claim lets the next instance attach', () async {
      final first = createTestCall();
      await first.setE2EEManager(e2ee);
      await first.clearE2EEManager();

      final second = createTestCall();
      final other = MockEncryptionManager();
      when(() => other.isDisposed).thenReturn(false);
      when(
        () => other.events,
      ).thenAnswer((_) => const Stream<E2eeEvent>.empty());

      await second.setE2EEManager(other);

      expect(second.e2eeManager, same(other));
    });
  });

  group('Call E2EE state', () {
    test('the SFU decides whether the call reports as encrypted', () {
      final notifier = CallStateNotifier(
        createTestCallState(callCid: SampleCallData.defaultCid),
      );

      // Starts on the server's default rather than on local intent: an
      // attached manager proves nothing until the join response agrees.
      expect(notifier.callState.isE2eeEnabled, isFalse);

      notifier.sfuE2eeEnabledUpdated(true);
      expect(notifier.callState.isE2eeEnabled, isTrue);

      notifier.sfuE2eeEnabledUpdated(false);
      expect(notifier.callState.isE2eeEnabled, isFalse);
    });
  });

  group('EncryptionManager key validation', () {
    test('AES-128 wants 16 bytes, AES-256 wants 32', () {
      expect(EncryptionAlgorithm.aes128Gcm.keyLengthBytes, 16);
      expect(EncryptionAlgorithm.aes256Gcm.keyLengthBytes, 32);
    });
  });
}
