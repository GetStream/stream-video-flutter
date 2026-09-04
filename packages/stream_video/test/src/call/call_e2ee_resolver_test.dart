import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

class MockEncryptionManager extends Mock implements EncryptionManager {}

/// A call state carrying [resolver], and the encryption mode the coordinator
/// resolved when one is given.
CallState _stateWith({
  CallEncryptionKeyResolver? resolver,
  StreamEncryptionMode? mode,
}) {
  final state = CallState(
    preferences: DefaultCallPreferences(encryptionKeyResolver: resolver),
    currentUserId: SampleCallData.defaultUserInfo.id,
    callCid: SampleCallData.defaultCid,
  );

  if (mode == null) return state;

  // `createdAt` too, not just the settings: it is what tells the SDK the call
  // has actually been described by the coordinator. Seeding the mode alone
  // leaves it looking unknown, which is what let a bug hide here.
  return state.copyWith(
    createdAt: DateTime.now(),
    settings: CallSettings(encryption: StreamEncryptionSettings(mode: mode)),
  );
}

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    registerFallbackValue(Uint8List(0));
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Call encryption key resolver', () {
    late MockEncryptionManager manager;

    /// The requests the resolver was given.
    late List<CallEncryptionKeyRequest> asked;

    setUp(() {
      manager = MockEncryptionManager();
      asked = [];

      when(() => manager.userId).thenReturn(SampleCallData.defaultUserInfo.id);
      when(() => manager.algorithm).thenReturn(EncryptionAlgorithm.aes128Gcm);
      when(
        () => manager.events,
      ).thenAnswer((_) => const Stream<E2eeEvent>.empty());
      when(() => manager.isDisposed).thenReturn(false);
      when(() => manager.dispose()).thenAnswer((_) async {});
      when(() => manager.setSharedKey(any(), any())).thenAnswer((_) async {});
    });

    tearDown(Call.resetE2EEClaims);

    CallEncryptionKeyResolver resolverReturning(
      CallEncryptionKey? key, {
      Exception? throws,
    }) {
      return (request) async {
        asked.add(request);
        if (throws != null) throw throws;
        return key;
      };
    }

    CallEncryptionKey aes128([int keyIndex = 0]) =>
        CallEncryptionKey.shared(bytes: Uint8List(16), keyIndex: keyIndex);

    test('is asked with the call id alone', () async {
      // A bare makeCall() then join(): nothing has fetched or created the call.
      // The resolver is asked all the same, and answers from what the app knows
      // rather than from anything the SDK half-knows about the call.
      final call = createTestCallWithState(
        initialState: _stateWith(resolver: resolverReturning(null)),
      );

      final result = await call.join();

      expect(asked.single, CallEncryptionKeyRequest(callCid: call.callCid));
      // Declining is not treated as a requirement failure here, so the join is
      // left to the server to accept or reject.
      expect(result.isSuccess, isTrue);
    });

    test('an attached manager wins and the resolver is never asked', () async {
      final call = createTestCallWithState(
        initialState: _stateWith(resolver: resolverReturning(aes128())),
      );

      await call.setE2EEManager(manager);
      await call.join();

      expect(asked, isEmpty);
      expect(call.e2eeManager, same(manager));
    });

    test('no key and no requirement joins unencrypted', () async {
      final coordinatorClient = setupMockCoordinatorClient();
      final call = createTestCallWithState(
        initialState: _stateWith(resolver: resolverReturning(null)),
        coordinatorClient: coordinatorClient,
      );

      final result = await call.join();

      expect(result.isSuccess, isTrue);
      expect(call.e2eeManager, isNull);
      expect(asked.single.callCid, SampleCallData.defaultCid);
    });

    test('a call that already has a manager is not resolved again', () async {
      late Call call;
      call = createTestCallWithState(
        initialState: _stateWith(
          resolver: (request) async {
            asked.add(request);
            await call.setE2EEManager(manager);
            return null;
          },
        ),
      );

      await call.join();
      await call.join();

      // How resolving once per call actually works: the attached manager is
      // what the second join sees. Re-importing at a live key index would
      // break decryption of frames still in flight.
      expect(asked, hasLength(1));
    });

    test('a manager the platform cannot build fails the join', () async {
      final call = createTestCallWithState(
        initialState: _stateWith(resolver: resolverReturning(aes128())),
      );

      final result = await call.join();

      // No platform channel under test, so this stands in for any failure
      // between "a key was resolved" and "a manager holds it". Either way the
      // join has to fail rather than quietly proceed unencrypted.
      expect(result, isA<Failure>());
      expect(call.e2eeManager, isNull);
    });

    test('declining leaves an encrypted call to the server to reject', () async {
      final coordinatorClient = setupMockCoordinatorClient();
      final call = createTestCallWithState(
        initialState: _stateWith(
          resolver: resolverReturning(null),
          mode: StreamEncryptionMode.autoOn,
        ),
        coordinatorClient: coordinatorClient,
      );

      final result = await call.join();

      // No client-side pre-check, matching the other Stream SDKs: the join goes
      // out reporting no encryption and Stream rejects it on the mismatch. The
      // client cannot reliably know the mode before the join, so guessing here
      // would only ever be a second, less reliable authority.
      expect(result.isSuccess, isTrue);
      verify(
        () => coordinatorClient.joinCall(
          callCid: any(named: 'callCid'),
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

    test('no resolver means the resolver path does nothing at all', () async {
      final call = createTestCallWithState(
        initialState: _stateWith(mode: StreamEncryptionMode.autoOn),
      );

      final result = await call.join();

      expect(result.isSuccess, isTrue);
      expect(call.e2eeManager, isNull);
    });

    test(
      'a resolver that throws fails the join rather than downgrading it',
      () async {
        final call = createTestCallWithState(
          initialState: _stateWith(
            resolver: resolverReturning(
              null,
              throws: Exception('vault unreachable'),
            ),
          ),
        );

        final result = await call.join();

        // Even though this call does not require encryption: the resolver
        // failing says nothing about whether the call was meant to be protected.
        expect(result, isA<Failure>());
        expect(call.e2eeManager, isNull);
      },
    );
  });

  group('CallEncryptionKey', () {
    test('rejects a key of the wrong length for its algorithm', () {
      expect(
        () => CallEncryptionKey.shared(
          bytes: Uint8List(16),
          algorithm: EncryptionAlgorithm.aes256Gcm,
        ),
        throwsArgumentError,
      );
      expect(
        () => CallEncryptionKey.shared(bytes: Uint8List(32)),
        throwsArgumentError,
      );
    });

    test('rejects an index no frame could carry', () {
      expect(
        () => CallEncryptionKey.shared(bytes: Uint8List(16), keyIndex: -1),
        throwsArgumentError,
      );
      expect(
        () => CallEncryptionKey.shared(bytes: Uint8List(16), keyIndex: 256),
        throwsArgumentError,
      );
    });

    test('keeps the key out of toString', () {
      final key = CallEncryptionKey.shared(
        bytes: Uint8List.fromList(List.filled(16, 0xAB)),
      );

      expect(key.toString(), isNot(contains('171')));
      expect(key.toString(), isNot(contains('ab')));
    });
  });
}
