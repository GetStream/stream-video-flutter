import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/lifecycle/lifecycle_state.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/stream_video_fixture.dart';

/// Pins the seams [StreamVideo.forTesting] opens: the coordinator client
/// and the app lifecycle stream.
void main() {
  setUpAll(() {
    registerFallbackValue(const UserInfo(id: 'fallback'));
  });

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
}
