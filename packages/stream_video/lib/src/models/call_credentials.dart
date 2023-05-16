import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class CallCredentials with EquatableMixin {
  const CallCredentials({
    required this.sfuServer,
    required this.sfuToken,
    required this.iceServers,
  });

  final CallSfuServer sfuServer;
  final String sfuToken;
  final List<CallIceServer> iceServers;

  @override
  List<Object> get props => [sfuServer, sfuToken, iceServers];

  @override
  String toString() {
    return 'CallCredentials{sfuToken.length: ${sfuToken.length}, '
        'edgeServer: $sfuServer, iceServers: $iceServers}';
  }
}

@immutable
class CallSfuServer with EquatableMixin {
  const CallSfuServer({
    required this.name,
    required this.url,
    required this.wsEndpoint,
  });

  final String name;
  final String url;
  final String wsEndpoint;

  @override
  List<Object> get props => [name, url, wsEndpoint];

  @override
  String toString() {
    return 'CallSfuServer{name: $name, url: $url, wsEndpoint: $wsEndpoint}';
  }
}

@immutable
class CallIceServer with EquatableMixin {
  const CallIceServer({
    required this.username,
    required this.password,
    required this.urls,
  });

  final String username;
  final String password;
  final List<String> urls;

  @override
  List<Object> get props => [username, password, urls];

  @override
  String toString() {
    return 'CallIceServer{username: $username, '
        'password: $password, urls: $urls}';
  }
}
