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
    verifyConnectUser().called(1);
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
}
