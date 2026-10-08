import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/stream_video_fixture.dart';

/// Pins how a client starts up: the `ready` future, replacing the singleton,
/// and who sets up logging.
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
      options: StreamVideoOptions(autoConnect: true),
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

  test('ready completes when the auto connect fails', () async {
    final fixture = StreamVideoFixture(
      options: StreamVideoOptions(autoConnect: true),
    );
    addTearDown(fixture.dispose);
    when(
      () => fixture.client.connectUser(
        any(),
        includeUserDetails: any(named: 'includeUserDetails'),
      ),
    ).thenAnswer((_) async => failureWithError('refused'));

    await expectLater(fixture.streamVideo.ready, completes);
  });

  test('replacing the singleton disposes the old client', () async {
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
    await pumpEventQueue();

    expect(first.isDisposed, isTrue);
    expect(StreamVideo.instance, same(second));
    await second.dispose();
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
