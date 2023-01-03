import 'package:stream_video/stream_video.dart';

/// Used to expose a mechanism that allows the SDK to fetch users.
/// These users can then be invited to calls, explored in isolation and more.
abstract class StreamUsersProvider {
  /// Provides a single instance of a user list that can be presented on the UI.
  Future<List<UserInfo>> providerUsers();
}

/// Default empty implementation of [StreamUsersProvider].
/// Useful if you don't want to provide any users in your UI or call flow.
class EmptyUsersProvider {
  static final EmptyUsersProvider _instance = EmptyUsersProvider._();

  factory EmptyUsersProvider() {
    return _instance;
  }

  EmptyUsersProvider._();
}
