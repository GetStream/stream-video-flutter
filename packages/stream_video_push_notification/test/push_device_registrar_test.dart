import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/manager/push_device_registrar.dart';
import 'package:stream_video_push_notification/src/manager/push_token_source.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

// Pins what the registrar sends to the backend and remembers: the provider's
// token on each refresh, the APNs token when asked for, nothing twice, and
// every token deleted again on unregister.

const _voipToken = 'voip-token';
const _fcmToken = 'fcm-token';
const _apnToken = 'apn-token';

class _MockCoordinatorClient extends Mock implements CoordinatorClient {}

/// A token source scripted by the test.
class _FakeTokenSource extends PushTokenSource {
  _FakeTokenSource(this._token);

  String? _token;
  final _refreshes = StreamController<String>.broadcast();

  Future<void> close() => _refreshes.close();

  set current(String? token) => _token = token;

  void refresh(String token) => _refreshes.add(token);

  @override
  Future<String?> token() async => _token;

  @override
  Stream<String> get onRefresh => _refreshes.stream;
}

/// A token source whose reads wait until the test completes or fails them.
class _PendingTokenSource extends PushTokenSource {
  var _read = Completer<String?>();

  void fail(Object error) => _read.completeError(error);

  /// Completes the pending read, if it is still pending, and answers later
  /// reads with [token].
  void succeed(String token) {
    if (!_read.isCompleted) _read.complete(token);
    _read = Completer<String?>()..complete(token);
  }

  @override
  Future<String?> token() => _read.future;

  @override
  Stream<String> get onRefresh => const Stream.empty();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockCoordinatorClient client;
  late _FakeTokenSource voipTokens;
  late _FakeTokenSource fcmTokens;
  late _FakeTokenSource apnsTokens;

  setUpAll(() {
    registerFallbackValue(PushProvider.apn);
  });

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;

    client = _MockCoordinatorClient();
    when(
      () => client.createDevice(
        id: any(named: 'id'),
        pushProvider: any(named: 'pushProvider'),
        pushProviderName: any(named: 'pushProviderName'),
        voipToken: any(named: 'voipToken'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
    when(
      () => client.deleteDevice(id: any(named: 'id')),
    ).thenAnswer((_) async => const Result.success(none));

    voipTokens = _FakeTokenSource(_voipToken);
    fcmTokens = _FakeTokenSource(_fcmToken);
    apnsTokens = _FakeTokenSource(_apnToken);
  });

  tearDown(() async {
    CurrentPlatform.debugCurrentPlatformOverride = null;
    await voipTokens.close();
    await fcmTokens.close();
    await apnsTokens.close();
  });

  /// A registrar over the fake sources, with [storedValues] already in the
  /// preferences. The platform's own token is what the manager would hand it:
  /// the VoIP token on iOS, the Firebase token on Android.
  PushDeviceRegistrar registrar({
    bool registerApnDeviceToken = false,
    Map<String, Object> storedValues = const {},
  }) {
    SharedPreferences.setMockInitialValues(storedValues);
    final instance = PushDeviceRegistrar(
      client: client,
      iosPushProvider: StreamVideoPushProvider.apn(
        name: 'apn',
        tokenStreamProvider: () => voipTokens.tokens,
      ),
      androidPushProvider: StreamVideoPushProvider.firebase(
        name: 'fcm',
        tokenStreamProvider: () => fcmTokens.tokens,
      ),
      registerApnDeviceToken: registerApnDeviceToken,
      // What the manager's getDevicePushTokenVoIP answers per platform.
      currentDeviceToken: () async => switch (CurrentPlatform.type) {
        PlatformType.ios => voipTokens.token(),
        PlatformType.android => fcmTokens.token(),
        _ => null,
      },
      apnsTokenSource: apnsTokens,
    );
    addTearDown(instance.dispose);
    return instance;
  }

  /// A registrar whose iOS provider reads its tokens from [source], while the
  /// device token it deletes is the plain VoIP one.
  PushDeviceRegistrar registrarReading(_PendingTokenSource source) {
    SharedPreferences.setMockInitialValues({});
    final instance = PushDeviceRegistrar(
      client: client,
      iosPushProvider: StreamVideoPushProvider.apn(
        name: 'apn',
        tokenStreamProvider: () => source.tokens,
      ),
      androidPushProvider: StreamVideoPushProvider.firebase(
        name: 'fcm',
        tokenStreamProvider: () => fcmTokens.tokens,
      ),
      registerApnDeviceToken: false,
      currentDeviceToken: () async => _voipToken,
      apnsTokenSource: apnsTokens,
    );
    addTearDown(instance.dispose);
    return instance;
  }

  /// A registrar that registers the APNs token, read from [apns].
  PushDeviceRegistrar registrarWithApns(PushTokenSource apns) {
    SharedPreferences.setMockInitialValues({});
    final instance = PushDeviceRegistrar(
      client: client,
      iosPushProvider: StreamVideoPushProvider.apn(
        name: 'apn',
        tokenStreamProvider: () => voipTokens.tokens,
      ),
      androidPushProvider: StreamVideoPushProvider.firebase(
        name: 'fcm',
        tokenStreamProvider: () => fcmTokens.tokens,
      ),
      registerApnDeviceToken: true,
      currentDeviceToken: () async => _voipToken,
      apnsTokenSource: apns,
    );
    addTearDown(instance.dispose);
    return instance;
  }

  List<String> createdIds() => verify(
    () => client.createDevice(
      id: captureAny(named: 'id'),
      pushProvider: any(named: 'pushProvider'),
      pushProviderName: any(named: 'pushProviderName'),
      voipToken: any(named: 'voipToken'),
    ),
  ).captured.cast<String>();

  List<String> deletedIds() => verify(
    () => client.deleteDevice(id: captureAny(named: 'id')),
  ).captured.cast<String>();

  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();

  group('registerDevice', () {
    test('registers the VoIP token with the APN provider on iOS', () async {
      registrar().registerDevice();
      await pumpEventQueue();

      verify(
        () => client.createDevice(
          id: _voipToken,
          pushProvider: PushProvider.apn,
          pushProviderName: 'apn',
          voipToken: true,
        ),
      ).called(1);
      expect(
        (await prefs()).getString(PushDeviceRegistrar.userDeviceTokenVoIPKey),
        _voipToken,
      );
    });

    test(
      'registers the Firebase token with the Firebase provider on Android',
      () async {
        CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

        registrar().registerDevice();
        await pumpEventQueue();

        // Current behaviour, pinned: the Firebase token is sent as a VoIP token
        // too (bug 3 on FLU-1197; a change needs a backend check first).
        verify(
          () => client.createDevice(
            id: _fcmToken,
            pushProvider: PushProvider.firebase,
            pushProviderName: 'fcm',
            voipToken: true,
          ),
        ).called(1);
      },
    );

    test('does nothing on an unsupported platform', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;

      registrar().registerDevice();
      await pumpEventQueue();

      verifyNever(
        () => client.createDevice(
          id: any(named: 'id'),
          pushProvider: any(named: 'pushProvider'),
          pushProviderName: any(named: 'pushProviderName'),
          voipToken: any(named: 'voipToken'),
        ),
      );
    });

    test('registers the APNs token as well when asked to', () async {
      registrar(registerApnDeviceToken: true).registerDevice();
      await pumpEventQueue();

      verify(
        () => client.createDevice(
          id: _apnToken,
          pushProvider: PushProvider.apn,
          pushProviderName: 'apn',
          voipToken: false,
        ),
      ).called(1);
      expect(
        (await prefs()).getString(PushDeviceRegistrar.userDeviceTokenKey),
        _apnToken,
      );
    });

    test('skips the APNs token when the platform has none', () async {
      apnsTokens.current = null;

      registrar(registerApnDeviceToken: true).registerDevice();
      await pumpEventQueue();

      expect(createdIds(), [_voipToken]);
    });

    test('does not resend a token it registered before', () async {
      registrar(
        storedValues: {PushDeviceRegistrar.userDeviceTokenVoIPKey: _voipToken},
      ).registerDevice();
      await pumpEventQueue();

      verifyNever(
        () => client.createDevice(
          id: any(named: 'id'),
          pushProvider: any(named: 'pushProvider'),
          pushProviderName: any(named: 'pushProviderName'),
          voipToken: any(named: 'voipToken'),
        ),
      );
    });

    test('registers every refreshed token', () async {
      registrar().registerDevice();
      await pumpEventQueue();
      voipTokens.refresh('voip-token-2');
      await pumpEventQueue();

      expect(createdIds(), [_voipToken, 'voip-token-2']);
      expect(
        (await prefs()).getString(PushDeviceRegistrar.userDeviceTokenVoIPKey),
        'voip-token-2',
      );
    });

    test('does not remember a token the backend refused', () async {
      when(
        () => client.createDevice(
          id: any(named: 'id'),
          pushProvider: any(named: 'pushProvider'),
          pushProviderName: any(named: 'pushProviderName'),
          voipToken: any(named: 'voipToken'),
        ),
      ).thenAnswer((_) async => failureWithError('nope'));

      registrar().registerDevice();
      await pumpEventQueue();

      expect(
        (await prefs()).getString(PushDeviceRegistrar.userDeviceTokenVoIPKey),
        isNull,
      );
    });

    test(
      'a second call does not subscribe to the token stream twice',
      () async {
        final instance = registrar();
        instance.registerDevice();
        instance.registerDevice();
        await pumpEventQueue();
        voipTokens.refresh('voip-token-2');
        await pumpEventQueue();

        expect(createdIds(), [_voipToken, 'voip-token-2']);
      },
    );

    test(
      'an APNs token read after the device was unregistered is not registered',
      () async {
        final apns = _PendingTokenSource();
        final instance = registrarWithApns(apns);
        instance.registerDevice();
        await pumpEventQueue();

        final unregistered = instance.unregisterDevice();
        apns.succeed(_apnToken);
        await unregistered;
        await pumpEventQueue();

        expect(createdIds(), [_voipToken]);
      },
    );

    test('a failing APNs token read registers the provider token', () async {
      final apns = _PendingTokenSource();
      final instance = registrarWithApns(apns);

      instance.registerDevice();
      apns.fail(StateError('offline'));
      await pumpEventQueue();

      expect(createdIds(), [_voipToken]);
    });

    test('works before the preferences have loaded', () async {
      // Registration waits for the preferences to load.
      final completer = Completer<SharedPreferences>();
      SharedPreferences.setMockInitialValues({});
      final instance = PushDeviceRegistrar(
        client: client,
        iosPushProvider: StreamVideoPushProvider.apn(
          name: 'apn',
          tokenStreamProvider: () => voipTokens.tokens,
        ),
        androidPushProvider: const StreamVideoPushProvider.firebase(
          name: 'fcm',
        ),
        registerApnDeviceToken: false,
        currentDeviceToken: voipTokens.token,
        preferences: completer.future,
      );
      addTearDown(instance.dispose);

      instance.registerDevice();
      await pumpEventQueue();
      verifyNever(
        () => client.createDevice(
          id: any(named: 'id'),
          pushProvider: any(named: 'pushProvider'),
          pushProviderName: any(named: 'pushProviderName'),
          voipToken: any(named: 'voipToken'),
        ),
      );

      completer.complete(await SharedPreferences.getInstance());
      await pumpEventQueue();
      expect(createdIds(), [_voipToken]);
    });
  });

  group('unregisterDevice', () {
    test(
      'does not delete the APN token when registerApnDeviceToken is false',
      () async {
        // The APN token was never registered, so only the VoIP token goes.
        await registrar().unregisterDevice();

        expect(deletedIds(), [_voipToken]);
      },
    );

    test(
      'deletes the current APN token when registerApnDeviceToken is true',
      () async {
        await registrar(registerApnDeviceToken: true).unregisterDevice();

        expect(deletedIds(), [_voipToken, _apnToken]);
      },
    );

    test(
      'deletes a stored APN token after registerApnDeviceToken was disabled',
      () async {
        await registrar(
          storedValues: {PushDeviceRegistrar.userDeviceTokenKey: _apnToken},
        ).unregisterDevice();

        expect(deletedIds(), [_voipToken, _apnToken]);
      },
    );

    test(
      'deletes both the stored and the current VoIP token when they differ',
      () async {
        await registrar(
          storedValues: {
            PushDeviceRegistrar.userDeviceTokenVoIPKey: 'old-voip-token',
          },
        ).unregisterDevice();

        expect(deletedIds(), [_voipToken, 'old-voip-token']);
      },
    );

    test('deletes the same VoIP token only once', () async {
      await registrar(
        storedValues: {PushDeviceRegistrar.userDeviceTokenVoIPKey: _voipToken},
      ).unregisterDevice();

      expect(deletedIds(), [_voipToken]);
    });

    test('completes when the APNs token read fails', () async {
      final apns = _PendingTokenSource();
      final instance = registrarWithApns(apns);

      final unregistered = instance.unregisterDevice();
      await pumpEventQueue();
      apns.fail(StateError('offline'));
      await unregistered;

      expect(deletedIds(), [_voipToken]);
    });

    test(
      'deletes both the stored and the current APN token when they differ',
      () async {
        await registrar(
          registerApnDeviceToken: true,
          storedValues: {
            PushDeviceRegistrar.userDeviceTokenKey: 'old-apn-token',
          },
        ).unregisterDevice();

        expect(deletedIds(), [_voipToken, 'old-apn-token', _apnToken]);
      },
    );

    test('deletes the same APN token only once', () async {
      await registrar(
        registerApnDeviceToken: true,
        storedValues: {PushDeviceRegistrar.userDeviceTokenKey: _apnToken},
      ).unregisterDevice();

      expect(deletedIds(), [_voipToken, _apnToken]);
    });

    test('skips the APN token when the platform reports none', () async {
      apnsTokens.current = null;

      await registrar(registerApnDeviceToken: true).unregisterDevice();

      expect(deletedIds(), [_voipToken]);
    });

    test('deletes the Firebase token on Android', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

      await registrar(registerApnDeviceToken: true).unregisterDevice();

      // No APN token off iOS, whatever the flag says.
      expect(deletedIds(), [_fcmToken]);
    });

    test('clears the stored tokens', () async {
      await registrar(
        storedValues: {
          PushDeviceRegistrar.userDeviceTokenKey: _apnToken,
          PushDeviceRegistrar.userDeviceTokenVoIPKey: _voipToken,
        },
      ).unregisterDevice();

      final preferences = await prefs();
      expect(
        preferences.getString(PushDeviceRegistrar.userDeviceTokenKey),
        isNull,
      );
      expect(
        preferences.getString(PushDeviceRegistrar.userDeviceTokenVoIPKey),
        isNull,
      );
    });

    test('stops registering refreshed tokens', () async {
      final instance = registrar();
      instance.registerDevice();
      await pumpEventQueue();

      await instance.unregisterDevice();
      voipTokens.refresh('voip-token-2');
      await pumpEventQueue();

      expect(createdIds(), [_voipToken]);
    });

    test('works off mobile, where nothing was registered', () async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;

      await registrar(
        storedValues: {PushDeviceRegistrar.userDeviceTokenKey: _apnToken},
      ).unregisterDevice();

      // Only what the preferences remember; the platform has no token.
      expect(deletedIds(), [_apnToken]);
    });

    test(
      'stops registering refreshed tokens when no token can be read',
      () async {
        final instance = registrar();
        instance.registerDevice();
        await pumpEventQueue();
        voipTokens.current = null;

        await instance.unregisterDevice();
        voipTokens.refresh('voip-token-2');
        await pumpEventQueue();

        expect(createdIds(), [_voipToken]);
      },
    );

    test(
      'deletes the stored VoIP token when the current token read fails',
      () async {
        SharedPreferences.setMockInitialValues({
          PushDeviceRegistrar.userDeviceTokenKey: _apnToken,
          PushDeviceRegistrar.userDeviceTokenVoIPKey: _voipToken,
        });
        final instance = PushDeviceRegistrar(
          client: client,
          iosPushProvider: StreamVideoPushProvider.apn(
            name: 'apn',
            tokenStreamProvider: () => voipTokens.tokens,
          ),
          androidPushProvider: StreamVideoPushProvider.firebase(
            name: 'fcm',
            tokenStreamProvider: () => fcmTokens.tokens,
          ),
          registerApnDeviceToken: false,
          currentDeviceToken: () async => throw StateError('offline'),
          apnsTokenSource: apnsTokens,
        );
        addTearDown(instance.dispose);

        await instance.unregisterDevice();

        expect(deletedIds(), [_voipToken, _apnToken]);
        final preferences = await SharedPreferences.getInstance();
        expect(preferences.getKeys(), isEmpty);
      },
    );

    test('a registration still in flight does not store its token', () async {
      final created = Completer<Result<None>>();
      when(
        () => client.createDevice(
          id: any(named: 'id'),
          pushProvider: any(named: 'pushProvider'),
          pushProviderName: any(named: 'pushProviderName'),
          voipToken: any(named: 'voipToken'),
        ),
      ).thenAnswer((_) => created.future);
      final instance = registrar();
      instance.registerDevice();
      await pumpEventQueue();

      await instance.unregisterDevice();
      created.complete(const Result.success(none));
      await pumpEventQueue();

      final preferences = await SharedPreferences.getInstance();
      expect(
        preferences.getString(PushDeviceRegistrar.userDeviceTokenVoIPKey),
        isNull,
      );
    });

    test('completes while the first token read is still pending', () async {
      final pending = _PendingTokenSource();
      final instance = registrarReading(pending);
      instance.registerDevice();
      await pumpEventQueue();

      await instance.unregisterDevice().timeout(const Duration(seconds: 1));

      expect(deletedIds(), [_voipToken]);
    });

    test('completes when the pending first token read fails', () async {
      final pending = _PendingTokenSource();
      final instance = registrarReading(pending);
      instance.registerDevice();
      await pumpEventQueue();

      final unregistered = instance.unregisterDevice();
      pending.fail(StateError('offline'));

      await expectLater(unregistered, completes);
    });

    test('a registration after it subscribes to the tokens again', () async {
      final instance = registrar();
      instance.registerDevice();
      await pumpEventQueue();
      await instance.unregisterDevice();

      instance.registerDevice();
      await pumpEventQueue();
      voipTokens.refresh('voip-token-2');
      await pumpEventQueue();

      // The stored token was forgotten by the unregister, so the current one
      // is sent again, then the refreshed one.
      expect(createdIds(), [_voipToken, _voipToken, 'voip-token-2']);
    });
  });

  group('dispose', () {
    test('stops registering refreshed tokens', () async {
      final instance = registrar();
      instance.registerDevice();
      await pumpEventQueue();

      await instance.dispose();
      voipTokens.refresh('voip-token-2');
      await pumpEventQueue();

      expect(createdIds(), [_voipToken]);
    });

    test('completes while the first token read is still pending', () async {
      final instance = registrarReading(_PendingTokenSource());
      instance.registerDevice();
      await pumpEventQueue();

      await instance.dispose().timeout(const Duration(seconds: 1));
    });
  });

  group('a failing token stream', () {
    test('is subscribed to again by the next registration', () async {
      final failing = _PendingTokenSource();
      final instance = registrarReading(failing);
      instance.registerDevice();
      failing.fail(StateError('offline'));
      await pumpEventQueue();

      instance.registerDevice();
      failing.succeed(_voipToken);
      await pumpEventQueue();

      expect(createdIds(), [_voipToken]);
    });
  });
}
