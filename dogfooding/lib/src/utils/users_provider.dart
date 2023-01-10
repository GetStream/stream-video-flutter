import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/participant_info/users_provider.dart';

class MockUsersProvider extends StreamUsersProvider {
  @override
  Future<List<UserInfo>> providerUsers() async {
    return List<UserInfo>.generate(
      20,
      (index) => UserInfo(
        id: "user$index",
        role: "admin",
        name: "John $index",
      ),
    );
  }
}
