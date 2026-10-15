import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/coordinator/models/coordinator_events.dart';
import 'package:stream_video/src/coordinator/open_api/coordinator_client_open_api.dart';
import 'package:stream_video/src/coordinator/open_api/coordinator_ws.dart';
import 'package:stream_video/src/latency/latency_service.dart';
import 'package:stream_video/src/latency/latency_settings.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/retry/retry_policy.dart';
import 'package:stream_video/src/token/token_source.dart';
import 'package:stream_video/src/utils/none.dart';

/// A socket that connects as soon as it is asked to, and can be dropped.
class _FakeSocket extends Mock implements CoordinatorWebSocket {
  _FakeSocket(this.userId, {required this.includeUserDetails}) {
    when(() => isDisconnected).thenAnswer((_) => !_connected && !_recovering);
    when(() => isConnected).thenAnswer((_) => _connected);
    when(() => events).thenAnswer((_) => _events);
    when(connect).thenAnswer((_) async {
      connects++;
      _connected = true;
      _events.emit(
        CoordinatorConnectedEvent(connectionId: 'c$connects', userId: userId),
      );
      return const Result.success(none);
    });
    when(disconnect).thenAnswer((_) async {
      drop();
      return const Result.success(none);
    });
    when(dispose).thenAnswer((_) async {});
  }

  final String userId;
  final bool includeUserDetails;
  final _events = MutableSharedEmitter<CoordinatorEvent>();
  bool _connected = false;
  bool _recovering = false;
  int connects = 0;

  /// Drops the connection, as a lost network does. With [recovering], the
  /// socket reconnects by itself, as core's recovery does, until [recover].
  void drop({bool recovering = false}) {
    _connected = false;
    _recovering = recovering;
    _events.emit(CoordinatorDisconnectedEvent(userId: userId));
  }

  /// Ends the recovery of a socket dropped with `recovering`.
  void recover() {
    _recovering = false;
    _connected = true;
    _events.emit(
      CoordinatorConnectedEvent(connectionId: 'recovered', userId: userId),
    );
  }

  /// Emits [event] as if the server sent it.
  void emit(CoordinatorEvent event) => _events.emit(event);
}

/// Pins that connecting a user again reconnects the socket they already have,
/// instead of leaving it running next to a new one.
void main() {
  late List<_FakeSocket> sockets;
  late CoordinatorClientOpenApi client;

  setUp(() {
    sockets = [];
    client = CoordinatorClientOpenApi(
      rpcUrl: 'https://localhost:0',
      wsUrl: 'wss://localhost:0',
      apiKey: 'test-key',
      tokenSource: TokenSource(
        TokenManager(
          userId: 'user-1',
          tokenProvider: TokenProvider.static(UserToken.anonymous()),
        ),
      ),
      latencyService: LatencyService(settings: const LatencySettings()),
      retryPolicy: const RetryPolicy(),
      webSocketFactory: (user, {required includeUserDetails}) {
        final socket = _FakeSocket(
          user.id,
          includeUserDetails: includeUserDetails,
        );
        sockets.add(socket);
        return socket;
      },
    );
  });

  test('reconnects the dropped socket of the same user', () async {
    const user = UserInfo(id: 'user-1');
    expect((await client.connectUser(user)).isSuccess, isTrue);

    sockets.single.drop();
    await pumpEventQueue();
    expect((await client.connectUser(user)).isSuccess, isTrue);

    expect(sockets, hasLength(1));
    expect(sockets.single.connects, 2);
    expect(client.isConnected, isTrue);
  });

  test(
    'a dropped socket forwards each event once after reconnecting',
    () async {
      const user = UserInfo(id: 'user-1');
      await client.connectUser(user);
      sockets.single.drop();
      await pumpEventQueue();
      await client.connectUser(user);

      final received = <CoordinatorEvent>[];
      final subscription = client.events.listen(received.add);
      addTearDown(subscription.cancel);
      sockets.single.drop();
      await pumpEventQueue();

      expect(received.whereType<CoordinatorDisconnectedEvent>(), hasLength(1));
    },
  );

  test('closes and disposes the socket of another user', () async {
    await client.connectUser(const UserInfo(id: 'user-1'));
    sockets.single.drop();
    await pumpEventQueue();

    await client.connectUser(const UserInfo(id: 'user-2'));

    expect(sockets, hasLength(2));
    verifyNever(sockets.first.disconnect);
    verify(sockets.first.dispose).called(1);
    expect(client.isConnected, isTrue);
  });

  test('waits for a socket that is reconnecting by itself', () async {
    const user = UserInfo(id: 'user-1');
    await client.connectUser(user);
    sockets.single.drop(recovering: true);
    await pumpEventQueue();

    final connecting = client.connectUser(user);
    await pumpEventQueue();
    sockets.single.recover();

    expect((await connecting).isSuccess, isTrue);
    expect(sockets, hasLength(1));
    expect(sockets.single.connects, 1);
  });

  test('replaces the socket when the user details are asked for', () async {
    const user = UserInfo(id: 'user-1');
    await client.connectUser(user);
    sockets.single.drop();
    await pumpEventQueue();

    await client.connectUser(user, includeUserDetails: true);

    expect(sockets, hasLength(2));
    expect(sockets.last.includeUserDetails, isTrue);
    verify(sockets.first.dispose).called(1);
  });

  test('replaces the socket when the user changed', () async {
    await client.connectUser(const UserInfo(id: 'user-1', name: 'Old'));
    sockets.single.drop();
    await pumpEventQueue();

    await client.connectUser(const UserInfo(id: 'user-1', name: 'New'));

    expect(sockets, hasLength(2));
    verify(sockets.first.dispose).called(1);
  });

  test('closes a recovering socket of another user', () async {
    await client.connectUser(const UserInfo(id: 'user-1'));
    sockets.single.drop(recovering: true);
    await pumpEventQueue();

    await client.connectUser(const UserInfo(id: 'user-2'));

    verify(sockets.first.disconnect).called(1);
    verify(sockets.first.dispose).called(1);
  });

  test('stops forwarding the events of a replaced socket', () async {
    await client.connectUser(const UserInfo(id: 'user-1'));
    sockets.single.drop();
    await pumpEventQueue();
    await client.connectUser(const UserInfo(id: 'user-2'));

    final received = <CoordinatorEvent>[];
    final subscription = client.events.listen(received.add);
    addTearDown(subscription.cancel);
    sockets.first.emit(const CoordinatorDisconnectedEvent(userId: 'user-1'));
    await pumpEventQueue();

    expect(received, isEmpty);
  });

  test(
    'a failing teardown still disposes, and the next socket connects',
    () async {
      await client.connectUser(const UserInfo(id: 'user-1'));
      sockets.single.drop(recovering: true);
      await pumpEventQueue();
      when(sockets.single.disconnect).thenThrow(StateError('boom'));

      final result = await client.connectUser(const UserInfo(id: 'user-2'));

      expect(result.isSuccess, isTrue);
      verify(sockets.first.dispose).called(1);
      expect(client.isConnected, isTrue);
    },
  );

  test('a disconnect closes and disposes the socket', () async {
    await client.connectUser(const UserInfo(id: 'user-1'));

    await client.disconnectUser();

    verify(sockets.single.disconnect).called(1);
    verify(sockets.single.dispose).called(1);
    expect(client.isConnected, isFalse);
  });
}
