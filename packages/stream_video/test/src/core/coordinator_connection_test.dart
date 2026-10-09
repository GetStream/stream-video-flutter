import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/core/connection_state.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/stream_video_fixture.dart';

class _MockPushNotificationManager extends Mock
    implements PushNotificationManager {}

/// Pins connect, disconnect and dispose of the coordinator connection, and
/// how they interleave.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const UserInfo(id: 'fallback'));
  });

  late _MockPushNotificationManager push;
  late StreamVideoFixture fixture;

  ConnectionState connection() => fixture.streamVideo.state.connection.value;

  void connectUserAnswers(Future<Result<None>> Function() answer) {
    when(
      () => fixture.client.connectUser(
        any(),
        includeUserDetails: any(named: 'includeUserDetails'),
      ),
    ).thenAnswer((_) => answer());
  }

  VerificationResult verifyConnectUser() => verify(
    () => fixture.client.connectUser(
      any(),
      includeUserDetails: any(named: 'includeUserDetails'),
    ),
  );

  setUp(() {
    push = _MockPushNotificationManager();
    when(push.unregisterDevice).thenAnswer((_) async {});
    when(push.dispose).thenAnswer((_) async {});
    fixture = StreamVideoFixture(
      pushNotificationManagerProvider: (_, _) => push,
    );
  });

  tearDown(() => fixture.dispose());

  test('connect connects the user and registers the push device', () async {
    final result = await fixture.streamVideo.connect();

    expect(result.isSuccess, isTrue);
    expect(connection().isConnected, isTrue);
    verifyConnectUser().called(1);
    verify(push.registerDevice).called(1);
  });

  test('connects that overlap open one connection', () async {
    final opened = Completer<Result<None>>();
    connectUserAnswers(() => opened.future);

    final first = fixture.streamVideo.connect();
    final second = fixture.streamVideo.connect(includeUserDetails: false);
    await pumpEventQueue();
    opened.complete(const Result.success(none));

    expect((await first).isSuccess, isTrue);
    expect((await second).isSuccess, isTrue);
    // The first connect opened it, with its own user details.
    verify(
      () => fixture.client.connectUser(any(), includeUserDetails: true),
    ).called(1);
    verify(push.registerDevice).called(1);
  });

  test(
    'a later connect registers the push device an earlier one skipped',
    () async {
      await fixture.streamVideo.connect(registerPushDevice: false);
      verifyNever(push.registerDevice);

      await fixture.streamVideo.connect();
      await fixture.streamVideo.connect();

      verify(push.registerDevice).called(1);
    },
  );

  test('a disconnect during a connect leaves the user disconnected', () async {
    final opened = Completer<Result<None>>();
    connectUserAnswers(() => opened.future);

    final connecting = fixture.streamVideo.connect();
    await pumpEventQueue();
    final disconnecting = fixture.streamVideo.disconnect();
    await pumpEventQueue();
    // The disconnect waits for the connect, so the socket is not closed
    // under it.
    verifyNever(fixture.client.disconnectUser);

    opened.complete(const Result.success(none));

    expect((await connecting).isSuccess, isTrue);
    expect((await disconnecting).isSuccess, isTrue);
    verify(fixture.client.disconnectUser).called(1);
    expect(connection().isDisconnected, isTrue);
  });

  test('a connect during a disconnect leaves the user connected', () async {
    await fixture.streamVideo.connect();
    final closed = Completer<Result<None>>();
    when(fixture.client.disconnectUser).thenAnswer((_) => closed.future);

    final disconnecting = fixture.streamVideo.disconnect();
    await pumpEventQueue();
    final connecting = fixture.streamVideo.connect();
    await pumpEventQueue();
    // Still the first connect only.
    verifyConnectUser().called(1);

    closed.complete(const Result.success(none));

    expect((await disconnecting).isSuccess, isTrue);
    expect((await connecting).isSuccess, isTrue);
    verifyConnectUser().called(1);
    expect(connection().isConnected, isTrue);
  });

  test('disconnect unregisters the push device', () async {
    await fixture.streamVideo.connect();

    await fixture.streamVideo.disconnect();

    verify(push.unregisterDevice).called(1);
    verify(fixture.client.disconnectUser).called(1);
    expect(connection().isDisconnected, isTrue);
  });

  test(
    'a connect after a disconnect registers the push device again',
    () async {
      await fixture.streamVideo.connect();
      await fixture.streamVideo.disconnect();

      await fixture.streamVideo.connect();

      verify(push.registerDevice).called(2);
    },
  );

  test(
    'dispose disconnects without unregistering the push device, and refuses '
    'a later connect',
    () async {
      await fixture.streamVideo.connect();

      await fixture.streamVideo.dispose();

      verify(fixture.client.disconnectUser).called(1);
      verifyNever(push.unregisterDevice);
      expect(connection().isDisconnected, isTrue);

      final result = await fixture.streamVideo.connect();
      expect(result.isFailure, isTrue);
      verifyConnectUser().called(1);
    },
  );

  test('a dispose during a connect leaves the user disconnected', () async {
    final opened = Completer<Result<None>>();
    connectUserAnswers(() => opened.future);

    final connecting = fixture.streamVideo.connect();
    await pumpEventQueue();
    final disposing = fixture.streamVideo.dispose();
    await pumpEventQueue();
    // The dispose waits for the connect, so the socket is not closed under it.
    verifyNever(fixture.client.disconnectUser);
    opened.complete(const Result.success(none));

    await connecting;
    await disposing;
    verify(fixture.client.disconnectUser).called(1);
    expect(connection().isDisconnected, isTrue);
  });

  test('a failed connect leaves the connection failed', () async {
    connectUserAnswers(
      () async => const Result.failure(
        StreamVideoException(message: 'refused'),
      ),
    );

    final result = await fixture.streamVideo.connect();

    expect(result.isFailure, isTrue);
    expect(connection().isFailed, isTrue);
    verifyNever(push.registerDevice);
  });

  test('a connect that throws leaves the connection failed', () async {
    connectUserAnswers(() async => throw StateError('socket'));

    final result = await fixture.streamVideo.connect();

    expect(result.isFailure, isTrue);
    expect(connection().isFailed, isTrue);
  });

  test('the socket\'s own events move the connection state', () async {
    await fixture.streamVideo.connect();

    fixture.events.emit(
      const CoordinatorDisconnectedEvent(userId: 'test-user'),
    );
    await pumpEventQueue();
    expect(connection().isDisconnected, isTrue);

    fixture.events.emit(
      const CoordinatorConnectedEvent(
        userId: 'test-user',
        connectionId: 'connection-id',
      ),
    );
    await pumpEventQueue();
    expect(connection().isConnected, isTrue);
  });

  test('rejects a connect for an anonymous user', () async {
    final anonymous = StreamVideoFixture(user: User.anonymous());
    addTearDown(anonymous.dispose);

    final result = await anonymous.streamVideo.connect();

    expect(result.isFailure, isTrue);
    verifyNever(
      () => anonymous.client.connectUser(
        any(),
        includeUserDetails: any(named: 'includeUserDetails'),
      ),
    );
  });

  test('a token that cannot be used leaves the connection failed', () async {
    final client = StreamVideo.forTesting(
      'test-api-key',
      user: fixture.user,
      // Issued for another user, so it is refused before the socket opens.
      userToken: fakeJwt('someone-else'),
      options: StreamVideoOptions(autoConnect: false),
      coordinatorClient: fixture.client,
    );
    addTearDown(client.dispose);

    final result = await client.connect();

    expect(result.isFailure, isTrue);
    expect(client.state.connection.value.isFailed, isTrue);
    verifyNever(
      () => fixture.client.connectUser(
        any(),
        includeUserDetails: any(named: 'includeUserDetails'),
      ),
    );
  });

  test('stays connected when setting up the connection throws', () async {
    when(() => fixture.client.events).thenThrow(StateError('events'));

    final result = await fixture.streamVideo.connect();

    expect(result.isSuccess, isTrue);
    expect(connection().isConnected, isTrue);
    verify(push.registerDevice).called(1);
  });

  test('a push registration that throws is tried again', () async {
    when(push.registerDevice).thenThrow(StateError('push'));

    final result = await fixture.streamVideo.connect();
    expect(result.isSuccess, isTrue);

    when(push.registerDevice).thenReturn(null);
    await fixture.streamVideo.connect();

    verify(push.registerDevice).called(2);
  });

  test('a disconnect after the socket dropped still closes it', () async {
    await fixture.streamVideo.connect();
    fixture.events.emit(
      const CoordinatorDisconnectedEvent(userId: 'test-user'),
    );
    await pumpEventQueue();
    expect(connection().isDisconnected, isTrue);

    await fixture.streamVideo.disconnect();

    verify(push.unregisterDevice).called(1);
    verify(fixture.client.disconnectUser).called(1);
    // The socket coming back no longer reaches the client.
    fixture.events.emit(
      const CoordinatorConnectedEvent(
        userId: 'test-user',
        connectionId: 'connection-id',
      ),
    );
    await pumpEventQueue();
    expect(connection().isDisconnected, isTrue);
  });

  test('a disconnect, connect and disconnect run in order', () async {
    await fixture.streamVideo.connect();

    final results = await Future.wait([
      fixture.streamVideo.disconnect(),
      fixture.streamVideo.connect(),
      fixture.streamVideo.disconnect(),
    ]);

    expect(results.every((result) => result.isSuccess), isTrue);
    verifyConnectUser().called(2);
    verify(fixture.client.disconnectUser).called(2);
    expect(connection().isDisconnected, isTrue);
  });

  test('a failed unregister does not stop the disconnect', () async {
    await fixture.streamVideo.connect();
    when(push.unregisterDevice).thenThrow(StateError('push'));

    final result = await fixture.streamVideo.disconnect();

    expect(result.isSuccess, isTrue);
    verify(fixture.client.disconnectUser).called(1);
    expect(connection().isDisconnected, isTrue);
  });

  test(
    'a socket that fails to close still leaves the user disconnected',
    () async {
      await fixture.streamVideo.connect();
      when(fixture.client.disconnectUser).thenAnswer(
        (_) async => const Result.failure(StreamVideoException(message: 'ws')),
      );

      final result = await fixture.streamVideo.disconnect();

      expect(result.isFailure, isTrue);
      expect(connection().isDisconnected, isTrue);
    },
  );

  test('a connected event watches the watched calls again', () async {
    when(
      () => fixture.client.queryCalls(
        filterConditions: any(named: 'filterConditions'),
        next: any(named: 'next'),
        prev: any(named: 'prev'),
        sorts: any(named: 'sorts'),
        limit: any(named: 'limit'),
        watch: any(named: 'watch'),
      ),
    ).thenAnswer((_) async => failureWithError('offline'));
    await fixture.streamVideo.connect();
    final call = fixture.streamVideo.makeCall(
      callType: StreamCallType.defaultType(),
      id: 'watched',
    );
    fixture.streamVideo.state.setWatchedCall(call);

    fixture.events.emit(
      const CoordinatorConnectedEvent(
        userId: 'test-user',
        connectionId: 'connection-id',
      ),
    );
    await pumpEventQueue();

    verify(
      () => fixture.client.queryCalls(
        filterConditions: {
          'cid': {
            r'$in': [call.callCid.value],
          },
        },
        next: any(named: 'next'),
        prev: any(named: 'prev'),
        sorts: any(named: 'sorts'),
        limit: any(named: 'limit'),
        watch: true,
      ),
    ).called(1);
  });
}
