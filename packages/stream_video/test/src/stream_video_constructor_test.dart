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

  test('replacing the singleton hands the old client over', () async {
    final first = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(autoConnect: false),
    );
    addTearDown(first.dispose);

    final replaced = <StreamVideo>[];
    final second = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(autoConnect: false),
      onInstanceReplaced: replaced.add,
    );
    addTearDown(second.dispose);
    await pumpEventQueue();

    expect(StreamVideo.instance, same(second));
    expect(replaced, [same(first)]);
    expect(first.isDisposed, isFalse);
  });

  test('the old client is handed over after the new one is installed, '
      'without waiting for it', () async {
    final first = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(autoConnect: false),
    );
    addTearDown(first.dispose);

    StreamVideo? installedWhenCalled;
    final handedOver = Completer<void>();
    final second = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(autoConnect: false),
      onInstanceReplaced: (previous) {
        installedWhenCalled = StreamVideo.instance;
        return handedOver.future;
      },
    );
    addTearDown(second.dispose);

    expect(installedWhenCalled, same(second));
    handedOver.complete();
  });

  test('a failing onInstanceReplaced does not throw', () async {
    final first = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(autoConnect: false),
    );
    addTearDown(first.dispose);

    final second = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(autoConnect: false),
      onInstanceReplaced: (previous) async => throw StateError('boom'),
    );
    addTearDown(second.dispose);
    await pumpEventQueue();

    expect(StreamVideo.instance, same(second));
  });

  test('the replaced client is not handed over when none was installed', () {
    final replaced = <StreamVideo>[];
    final client = StreamVideo(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: StreamVideoOptions(autoConnect: false),
      onInstanceReplaced: replaced.add,
    );
    addTearDown(client.dispose);

    expect(replaced, isEmpty);
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
