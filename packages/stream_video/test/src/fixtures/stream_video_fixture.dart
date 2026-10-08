import 'dart:async';
import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/lifecycle/lifecycle_state.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

/// An unsigned JWT carrying [userId], enough for [UserToken]'s parsing.
String fakeJwt(String userId) {
  String encode(Map<String, dynamic> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  final header = encode({'alg': 'HS256', 'typ': 'JWT'});
  final payload = encode({'user_id': userId});
  final signature = encode({'sig': 'fake'});
  return '$header.$payload.$signature';
}

/// A [StreamVideo] on a mocked coordinator client and a lifecycle stream the
/// test drives.
class StreamVideoFixture {
  StreamVideoFixture({
    StreamVideoOptions? options,
    this.user = const User(id: 'test-user', name: 'Test User'),
    PNManagerProvider? pushNotificationManagerProvider,
  }) {
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

    streamVideo = StreamVideo.forTesting(
      'test-api-key',
      user: user,
      userToken: fakeJwt(user.id),
      options: options ?? StreamVideoOptions(autoConnect: false),
      pushNotificationManagerProvider: pushNotificationManagerProvider,
      coordinatorClient: client,
      appState: appState.stream,
    );
  }

  final User user;
  final client = MockCoordinatorClient();
  final events = MutableSharedEmitter<CoordinatorEvent>();
  final appState = StreamController<LifecycleState>.broadcast();
  late final StreamVideo streamVideo;

  Future<void> dispose() async {
    await streamVideo.dispose();
    await appState.close();
  }
}
