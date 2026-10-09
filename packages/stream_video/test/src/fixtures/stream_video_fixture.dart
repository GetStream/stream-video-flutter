import 'dart:async';
import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/lifecycle/lifecycle_state.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

/// A JWT with a fake signature carrying [userId]; [UserToken] parses it
/// without verifying.
String fakeJwt(String userId) {
  String encode(Map<String, dynamic> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  final header = encode({'alg': 'HS256', 'typ': 'JWT'});
  final payload = encode({'user_id': userId});
  final signature = encode({'sig': 'fake'});
  return '$header.$payload.$signature';
}

/// Builds a [StreamVideo] on a mocked [client], and holds the [events] and
/// [appState] the test drives it with.
///
/// The default options turn `autoConnect` off; options a test passes keep
/// their own. With an `initialState`, each connect first gets that state, as
/// the app's lifecycle stream emits the current state on listen.
class StreamVideoFixture {
  StreamVideoFixture({
    StreamVideoOptions? options,
    this.user = const User(id: 'test-user', name: 'Test User'),
    PNManagerProvider? pushNotificationManagerProvider,
    LifecycleState? initialState,
  }) {
    registerFallbackValue(const UserInfo(id: 'fallback'));
    when(() => client.events).thenAnswer((_) => events);
    when(
      () => client.connectUser(
        any(),
        includeUserDetails: any(named: 'includeUserDetails'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
    when(client.openConnection).thenAnswer(
      (_) async => const Result.success(none),
    );
    when(client.closeConnection).thenAnswer(
      (_) async => const Result.success(none),
    );
    when(client.disconnectUser).thenAnswer(
      (_) async => const Result.success(none),
    );
    // Connected unless a test says otherwise; a resume reads it.
    when(() => client.isConnected).thenReturn(true);

    streamVideo = StreamVideo.forTesting(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: options ?? StreamVideoOptions(autoConnect: false),
      pushNotificationManagerProvider: pushNotificationManagerProvider,
      coordinatorClient: client,
      appState: () => initialState == null
          ? appState.stream
          : appState.stream.startWith(initialState),
    );
  }

  final User user;
  final client = MockCoordinatorClient();
  final events = MutableSharedEmitter<CoordinatorEvent>();

  /// The app states each connect listens to. Broadcast, so a reconnect can
  /// listen again.
  final appState = StreamController<LifecycleState>.broadcast();
  late final StreamVideo streamVideo;

  Future<void> dispose() async {
    await streamVideo.dispose();
    await appState.close();
    await events.close();
  }
}
