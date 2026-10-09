import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/lifecycle/lifecycle_state.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/stream_video_fixture.dart';

// Pins the seams StreamVideo.forTesting opens: the coordinator client and
// the app lifecycle stream.
void main() {
  late StreamVideoFixture fixture;

  setUp(() => fixture = StreamVideoFixture());
  tearDown(() => fixture.dispose());

  test('connect goes through the given coordinator client', () async {
    final result = await fixture.streamVideo.connect();

    expect(result.isSuccess, isTrue);
    verify(
      () => fixture.client.connectUser(
        any(that: isA<UserInfo>().having((u) => u.id, 'id', 'test-user')),
        includeUserDetails: any(named: 'includeUserDetails'),
      ),
    ).called(1);
    expect(fixture.streamVideo.state.connection.value.isConnected, isTrue);
  });

  test('a coordinator event on the client reaches the client state', () async {
    await fixture.streamVideo.connect();

    fixture.events.emit(
      const CoordinatorDisconnectedEvent(
        userId: 'test-user',
        closeCode: 1000,
      ),
    );
    await pumpEventQueue();

    expect(fixture.streamVideo.state.connection.value.isDisconnected, isTrue);
  });

  test('follows the given lifecycle stream once connected', () async {
    await fixture.streamVideo.connect();

    fixture.appState.add(LifecycleState.paused);
    await pumpEventQueue();
    verify(fixture.client.closeConnection).called(1);
    expect(
      fixture.streamVideo.state.appLifecycleState.value,
      LifecycleState.paused,
    );

    fixture.appState.add(LifecycleState.resumed);
    await pumpEventQueue();
    verify(fixture.client.openConnection).called(1);
  });

  test(
    'a connect after a disconnect follows a fresh lifecycle stream',
    () async {
      var listens = 0;
      // Single subscription, as a real lifecycle stream is per listen.
      final states = <StreamController<LifecycleState>>[];
      final streamVideo = StreamVideo.forTesting(
        'test-api-key',
        user: fixture.user,
        userToken: fakeJwt(fixture.user.id),
        options: StreamVideoOptions(autoConnect: false),
        coordinatorClient: fixture.client,
        appState: () {
          listens++;
          final controller = StreamController<LifecycleState>();
          states.add(controller);
          return controller.stream;
        },
      );
      addTearDown(streamVideo.dispose);

      await streamVideo.connect();
      await streamVideo.disconnect();
      final reconnected = await streamVideo.connect();

      expect(reconnected.isSuccess, isTrue);
      expect(listens, 2);
      expect(states.first.hasListener, isFalse);

      states.last.add(LifecycleState.paused);
      await pumpEventQueue();
      verify(fixture.client.closeConnection).called(1);
    },
  );

  test('stops following the lifecycle stream once disconnected', () async {
    await fixture.streamVideo.connect();
    await fixture.streamVideo.disconnect();
    expect(fixture.appState.hasListener, isFalse);

    fixture.appState.add(LifecycleState.paused);
    await pumpEventQueue();
    verifyNever(fixture.client.closeConnection);

    await fixture.streamVideo.connect();
    fixture.appState.add(LifecycleState.paused);
    await pumpEventQueue();
    verify(fixture.client.closeConnection).called(1);
  });

  test('a connect gets the initial state the lifecycle stream emits', () async {
    final withInitial = StreamVideoFixture(
      initialState: LifecycleState.resumed,
    );
    addTearDown(withInitial.dispose);

    await withInitial.streamVideo.connect();
    await pumpEventQueue();

    expect(
      withInitial.streamVideo.state.appLifecycleState.value,
      LifecycleState.resumed,
    );
  });
}
