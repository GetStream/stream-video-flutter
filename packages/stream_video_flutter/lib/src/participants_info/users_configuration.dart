import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

/// Used to expose a mechanism that allows the SDK to fetch users. These users
/// can then be invited to calls, explored in isolation and more.
class StreamUsersConfiguration extends InheritedWidget {
  /// Creates a new instance of [StreamUsersConfiguration].
  const StreamUsersConfiguration({
    super.key,
    required this.usersProvider,
    required super.child,
  });

  /// The users provider that is hosted inside this widget.
  final StreamUsersProvider usersProvider;

  /// Retrieves the [StreamUsersProvider] from the closest
  /// [StreamUsersConfiguration] ancestor.
  static StreamUsersProvider of(BuildContext context) {
    final streamUsersConfiguration =
        context.dependOnInheritedWidgetOfExactType<StreamUsersConfiguration>();
    return streamUsersConfiguration?.usersProvider ?? EmptyUsersProvider();
  }

  @override
  bool updateShouldNotify(StreamUsersConfiguration oldWidget) {
    return oldWidget.usersProvider != usersProvider;
  }
}

/// Used to expose a mechanism that allows the SDK to fetch users.
/// These users can then be invited to calls, explored in isolation and more.
abstract class StreamUsersProvider {
  /// Provides a single instance of a user list that can be presented on the UI.
  Future<List<UserInfo>> providerUsers();
}

/// Default empty implementation of [StreamUsersProvider].
/// Useful if you don't want to provide any users in your UI or call flow.
class EmptyUsersProvider extends StreamUsersProvider {
  @override
  Future<List<UserInfo>> providerUsers() async {
    return List.empty();
  }
}
