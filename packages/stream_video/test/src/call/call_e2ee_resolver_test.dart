import 'dart:typed_data';

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
  return state.copyWith(
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

    test('the resolver is told the mode the coordinator resolved', () async {
      final call = createTestCallWithState(
        initialState: _stateWith(
          resolver: resolverReturning(aes128()),
          mode: StreamEncryptionMode.autoOn,
        ),
      );

      await call.join();

      // Without this a resolver cannot answer "only for calls that need it",
      // and a key handed to a plain call gets the join rejected.
      expect(asked.single.encryptionMode, StreamEncryptionMode.autoOn);
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

    test('no key for a call that requires encryption fails the join', () async {
      final coordinatorClient = setupMockCoordinatorClient();
      final call = createTestCallWithState(
        initialState: _stateWith(
          resolver: resolverReturning(null),
          mode: StreamEncryptionMode.autoOn,
        ),
        coordinatorClient: coordinatorClient,
      );

      final result = await call.join();

      expect(result, isA<Failure>());
      // Fails here rather than being rejected by the server a round trip later.
      verifyNever(
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
          e2ee: any(named: 'e2ee'),
        ),
      );
    });

    test(
      'no resolver at all for a call that requires encryption fails',
      () async {
        final call = createTestCallWithState(
          initialState: _stateWith(mode: StreamEncryptionMode.autoOn),
        );

        final result = await call.join();

        expect(result, isA<Failure>());
        expect(
          (result as Failure).error.message,
          contains('setE2EEManager'),
        );
      },
    );

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
