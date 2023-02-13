import 'package:stream_video_flutter/stream_video_flutter.dart';

/// Provides users for the invite screen.
class MockUsersProvider extends StreamUsersProvider {
  @override
  Future<List<UserInfo>> providerUsers() async {
    return List<UserInfo>.generate(
      20,
      (index) => UserInfo(
        id: 'user$index',
        role: 'admin',
        name: 'John $index',
      ),
    );
  }
}
