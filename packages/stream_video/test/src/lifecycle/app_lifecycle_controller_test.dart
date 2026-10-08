import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/lifecycle/lifecycle_state.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/stream_video_fixture.dart';

class _MockCall extends Mock implements Call {}

/// Pins how the client follows the app into the background and back: the
/// connection is closed only with no active call, and reopened only when it
/// was closed or dropped.
void main() {
  setUpAll(() {
    registerFallbackValue(const UserInfo(id: 'fallback'));
  });

  late StreamVideoFixture fixture;

  Future<void> goTo(LifecycleState state) async {
    fixture.appState.add(state);
    await pumpEventQueue();
  }

  Future<void> connect({StreamVideoOptions? options}) async {
    fixture = StreamVideoFixture(options: options);
    when(() => fixture.client.isConnected).thenReturn(true);
    await fixture.streamVideo.connect();
  }

  tearDown(() => fixture.dispose());

  test('closes the connection in the background and reopens it', () async {
    await connect();

    await goTo(LifecycleState.paused);
    verify(fixture.client.closeConnection).called(1);

    when(() => fixture.client.isConnected).thenReturn(false);
    await goTo(LifecycleState.resumed);
    verify(fixture.client.openConnection).called(1);
  });

  test('keeps the connection with an active call', () async {
    await connect();
    final call = _MockCall();
    when(() => call.callCid).thenReturn(StreamCallCid(cid: 'default:active'));
    await fixture.streamVideo.state.setActiveCall(call);

    await goTo(LifecycleState.paused);
    await goTo(LifecycleState.resumed);

    verifyNever(fixture.client.closeConnection);
    verifyNever(fixture.client.openConnection);
  });

  test('keeps the connection when asked to keep it alive', () async {
    await connect(
      options: StreamVideoOptions(
        autoConnect: false,
        keepConnectionsAliveWhenInBackground: true,
      ),
    );

    await goTo(LifecycleState.paused);
    await goTo(LifecycleState.resumed);

    verifyNever(fixture.client.closeConnection);
    verifyNever(fixture.client.openConnection);
  });

  test('reopens a connection kept open that dropped meanwhile', () async {
    await connect(
      options: StreamVideoOptions(
        autoConnect: false,
        keepConnectionsAliveWhenInBackground: true,
      ),
    );

    await goTo(LifecycleState.paused);
    when(() => fixture.client.isConnected).thenReturn(false);
    await goTo(LifecycleState.resumed);

    verify(fixture.client.openConnection).called(1);
  });

  test('records the app state', () async {
    await connect();

    await goTo(LifecycleState.paused);

    expect(
      fixture.streamVideo.state.appLifecycleState.value,
      LifecycleState.paused,
    );
  });

  test('a close that throws does not stop the reopen', () async {
    await connect();
    when(fixture.client.closeConnection).thenThrow(StateError('socket'));

    await goTo(LifecycleState.paused);
    await goTo(LifecycleState.resumed);

    verify(fixture.client.openConnection).called(1);
  });
}
