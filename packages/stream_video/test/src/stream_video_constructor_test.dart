import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/stream_video_fixture.dart';

/// Pins how a client starts up: the `ready` future, installing and replacing
/// the singleton, and who sets up logging.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const UserInfo(id: 'fallback'));
  });

  const user = User(id: 'test-user', name: 'Test User');

  tearDown(() async {
    await StreamVideo.reset();
    StreamLog()
      ..logger = const SilentStreamLogger()
      ..priority = Priority.none;
  });

  test('ready completes once the auto connect has run', () async {
    final fixture = StreamVideoFixture(
      options: StreamVideoOptions(),
    );
    addTearDown(fixture.dispose);

    await fixture.streamVideo.ready;

    verify(
      () => fixture.client.connectUser(
        any(),
        includeUserDetails: any(named: 'includeUserDetails'),
      ),
    ).called(1);
    expect(fixture.streamVideo.state.connection.value.isConnected, isTrue);
  });

  /// Builds a fixture whose auto connect waits on [connecting].
  StreamVideoFixture connectingFixture(Completer<Result<None>> connecting) {
    final fixture = StreamVideoFixture(
      options: StreamVideoOptions(),
    );
    addTearDown(fixture.dispose);
    when(
      () => fixture.client.connectUser(
        any(),
        includeUserDetails: any(named: 'includeUserDetails'),
      ),
    ).thenAnswer((_) => connecting.future);
    return fixture;
  }

  test(
    'ready waits for the auto connect, and completes when it fails',
    () async {
      final connecting = Completer<Result<None>>();
      final fixture = connectingFixture(connecting);
      var ready = false;
      unawaited(fixture.streamVideo.ready.then((_) => ready = true));

      await pumpEventQueue();
      expect(ready, isFalse);

      connecting.complete(failureWithError('refused'));
      await fixture.streamVideo.ready;
      expect(fixture.streamVideo.state.connection.value.isConnected, isFalse);
    },
  );

  test('ready completes when the auto connect throws', () async {
    final connecting = Completer<Result<None>>();
    final fixture = connectingFixture(connecting);
    await pumpEventQueue();

    connecting.completeError(StateError('socket'));

    await expectLater(fixture.streamVideo.ready, completes);
  });

  test('ready does not connect without auto connect', () async {
    final fixture = StreamVideoFixture(
      options: StreamVideoOptions(autoConnect: false),
    );
    addTearDown(fixture.dispose);

    await fixture.streamVideo.ready;

    verifyNever(
      () => fixture.client.connectUser(
        any(),
        includeUserDetails: any(named: 'includeUserDetails'),
      ),
    );
  });

  test('a second singleton is rejected before it is built', () async {
    final first = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(autoConnect: false),
    );
    addTearDown(first.dispose);
    final logged = <String>[];

    expect(
      () => StreamVideo(
        'test-api-key',
        user: user,
        userToken: fakeJwt(user.id),
        options: StreamVideoOptions(
          autoConnect: false,
          logPriority: Priority.verbose,
          logHandlerFunction: (priority, tag, message, [error, stackTrace]) =>
              logged.add(message()),
        ),
      ),
      throwsException,
    );

    streamLog.w('probe', () => 'probe');
    expect(logged, isEmpty);
    expect(StreamVideo.instance, same(first));
  });

  test('replacing the singleton leaves the old client alone', () async {
    final first = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(autoConnect: false),
    );

    final second = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(autoConnect: false),
      failIfSingletonExists: false,
    );
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await pumpEventQueue();

    expect(StreamVideo.instance, same(second));
    expect(first.isDisposed, isFalse);
  });

  test('only the singleton sets up logging from its options', () async {
    final logged = <String>[];
    void handler(
      Priority priority,
      String tag,
      MessageBuilder message, [
      Object? error,
      StackTrace? stackTrace,
    ]) => logged.add(message());
    void probe() => streamLog.w('probe', () => 'probe');

    final created = StreamVideo.create(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(
        autoConnect: false,
        logPriority: Priority.verbose,
        logHandlerFunction: handler,
      ),
    );
    addTearDown(created.dispose);
    probe();
    expect(logged, isNot(contains('probe')));

    final singleton = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(
        autoConnect: false,
        logPriority: Priority.verbose,
        logHandlerFunction: handler,
      ),
    );
    addTearDown(singleton.dispose);
    probe();
    expect(logged, contains('probe'));
  });
}
