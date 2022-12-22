import 'package:stream_video/stream_video.dart';

abstract class StreamUsersProvider {
  Future<List<UserInfo>> providerUsers();
}
