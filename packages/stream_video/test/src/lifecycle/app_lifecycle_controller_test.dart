import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/stream_video_fixture.dart';

class _MockCall extends Mock implements Call {}

/// Pins how the client follows the app into the background and back: the
/// connection is closed only with no active call and when it is not kept
/// alive, and reopened only when it was closed or dropped.
void main() {
  setUpAll(() {
    registerFallbackValue(const UserInfo(id: 'fallback'));
  });

  late StreamVideoFixture fixture;

  Future<void> goTo(VideoLifecycleState state) async {
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

    await goTo(VideoLifecycleState.paused);
    verify(fixture.client.closeConnection).called(1);

    // The mocked client still reports connected, so only the close made
    // here triggers the reopen.
    await goTo(VideoLifecycleState.resumed);
    verify(fixture.client.openConnection).called(1);
  });

  test('keeps the connection with an active call', () async {
    await connect();
    final call = _MockCall();
    when(() => call.callCid).thenReturn(StreamCallCid(cid: 'default:active'));
    await fixture.streamVideo.state.setActiveCall(call);

    await goTo(VideoLifecycleState.paused);
    await goTo(VideoLifecycleState.resumed);

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

    await goTo(VideoLifecycleState.paused);
    await goTo(VideoLifecycleState.resumed);

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

    await goTo(VideoLifecycleState.paused);
    when(() => fixture.client.isConnected).thenReturn(false);
    await goTo(VideoLifecycleState.resumed);

    verify(fixture.client.openConnection).called(1);
  });

  test('records the app state', () async {
    await connect();

    await goTo(VideoLifecycleState.paused);

    expect(
      fixture.streamVideo.state.appLifecycleState.value,
      VideoLifecycleState.paused,
    );
  });

  test('a close that fails is not reopened on resume', () async {
    await connect();
    when(
      fixture.client.closeConnection,
    ).thenAnswer((_) async => failureWithError('not open'));

    await goTo(VideoLifecycleState.paused);
    await goTo(VideoLifecycleState.resumed);

    verifyNever(fixture.client.openConnection);
  });

  test('a reopen that fails is tried again on the next resume', () async {
    await connect();
    when(
      fixture.client.openConnection,
    ).thenAnswer((_) async => failureWithError('offline'));

    await goTo(VideoLifecycleState.paused);
    await goTo(VideoLifecycleState.resumed);
    verify(fixture.client.openConnection).called(1);

    when(() => fixture.client.isConnected).thenReturn(false);
    await goTo(VideoLifecycleState.inactive);
    await goTo(VideoLifecycleState.resumed);
    verify(fixture.client.openConnection).called(1);
  });

  test('does nothing while the app is inactive or hidden', () async {
    await connect();

    await goTo(VideoLifecycleState.inactive);
    await goTo(VideoLifecycleState.hidden);

    verifyNever(fixture.client.closeConnection);
    verifyNever(fixture.client.openConnection);
  });

  test('a resume while the close is in progress reopens after it', () async {
    await connect();
    final closing = Completer<Result<None>>();
    when(fixture.client.closeConnection).thenAnswer((_) => closing.future);

    await goTo(VideoLifecycleState.paused);
    await goTo(VideoLifecycleState.resumed);
    verifyNever(fixture.client.openConnection);

    closing.complete(const Result.success(none));
    await pumpEventQueue();

    verify(fixture.client.openConnection).called(1);
  });

  test('a resume queued behind a disconnect does not reopen', () async {
    await connect();
    final closing = Completer<Result<None>>();
    when(fixture.client.closeConnection).thenAnswer((_) => closing.future);

    // The resume waits for the close, and the disconnect is asked for
    // meanwhile.
    await goTo(VideoLifecycleState.paused);
    await goTo(VideoLifecycleState.resumed);
    final disconnecting = fixture.streamVideo.disconnect();
    await pumpEventQueue();
    closing.complete(const Result.success(none));
    await disconnecting;
    await pumpEventQueue();

    verifyNever(fixture.client.openConnection);
    expect(
      fixture.streamVideo.state.connection.value.isDisconnected,
      isTrue,
    );
  });

  test('a reopen that fails does not follow the socket again', () async {
    await connect();
    when(
      fixture.client.openConnection,
    ).thenAnswer((_) async => failureWithError('offline'));
    await goTo(VideoLifecycleState.paused);
    await goTo(VideoLifecycleState.resumed);

    fixture.events.emit(
      const CoordinatorDisconnectedEvent(userId: 'test-user'),
    );
    await pumpEventQueue();

    expect(fixture.streamVideo.state.connection.value.isConnected, isTrue);
  });

  test('forgets a background close once the user disconnects', () async {
    await connect();
    await goTo(VideoLifecycleState.paused);
    await fixture.streamVideo.disconnect();
    clearInteractions(fixture.client);

    await fixture.streamVideo.connect();
    await goTo(VideoLifecycleState.resumed);

    verifyNever(fixture.client.openConnection);
  });
}
