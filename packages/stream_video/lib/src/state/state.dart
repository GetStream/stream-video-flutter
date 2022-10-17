import 'dart:async';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pb.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/state/controllers/call_members_controller.dart';
import 'package:stream_video/src/state/controllers/call_participant_controller.dart';
import 'package:stream_video/src/state/controllers/controllers.dart';
import 'package:stream_video/src/state/controllers/sfu_controller.dart';
import 'package:stream_video/src/state/controllers/track_controller.dart';

class StreamCallState {
  final String? userId;
  final String? clientId;
  final String? callType;
  final String? callId;
  final String? sfuUrl;
  final String? sfuToken;
  final bool? video;
  final bool? audio;

  StreamCallState({
    this.userId,
    this.clientId,
    this.callType,
    this.callId,
    this.video,
    this.audio,
    this.sfuUrl,
    this.sfuToken,
  });

  @override
  String toString() => '''StreamCallState(
    userId: $userId,
    clientId: $clientId,
    callType: $callType,
    callId: $callId,
    video: $video,
    audio: $audio,
    sfuUrl: $sfuUrl,
    sfuToken: $sfuToken,
  )''';
}

enum ConnectionStatus {
  authenticating,
  initialized,
  disconnecting,
  connecting,
  reconnecting,
  disconnected,
  connected(pingOK: PingOK.received);

  const ConnectionStatus({
    this.pingOK = PingOK.notReceived,
  });
  final PingOK? pingOK;
}

enum PingOK { received, notReceived }

class ClientState {
  //ingest this in state
  final Logger? logger;
  ClientState(this.logger);
  final _currentUserController = BehaviorSubject<UserInfo?>();

  final _callStateController = BehaviorSubject.seeded(StreamCallState());

  set callState(StreamCallState state) {
    logger?.info("setting call state to $state");
    _callStateController.add(state);
  }

  StreamCallState get callState => _callStateController.value;

  final _connectionStatusController =
      BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set connectionStatus(ConnectionStatus status) =>
      _connectionStatusController.add(status);
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  set currentUser(UserInfo? user) {
    // _computeUnreadCounts(user);
    _currentUserController.add(user);
  }

  /// The current user
  UserInfo? get currentUser => _currentUserController.valueOrNull;

  final _roomController = RoomController();

  SfuController get sfu => _roomController.sfu;

  TrackController get tracks => _roomController.tracks;

  CallController get calls => _roomController.calls;

  CallParticipantController get participants => _roomController.participants;

  // @internal
  // ParticipantController get participants => _roomController.participants;

  BroadcastController get broadcasts => _roomController.broadcasts;

  RecordingController get recordings => _roomController.recordings;
  CallMembersController get callMembers => _roomController.callMembers;

  final _userUpdatedController = BehaviorSubject<UserUpdated>();

  set userUpdated(UserUpdated userUpdated) =>
      _userUpdatedController.add(userUpdated);

  /// The current connection status value
  UserUpdated get userUpdated => _userUpdatedController.value;

  /// This notifies of Healthcheck changes
  Stream<UserUpdated> get userUpdatedStream =>
      _userUpdatedController.stream.distinct();

  final _authPayloadController = BehaviorSubject<WebsocketAuthRequest>();

  set authPayload(WebsocketAuthRequest authPayload) =>
      _authPayloadController.add(authPayload);

  /// The current connection status value
  WebsocketAuthRequest get authPayload => _authPayloadController.value;

  /// This notifies of Healthcheck changes
  Stream<WebsocketAuthRequest> get authPayloadStream =>
      _authPayloadController.stream.distinct();

  Future<void> dispose() async {
    await Future.wait([
      _roomController.disposeCall(),
      _callStateController.close(),
      _connectionStatusController.close(),
      _currentUserController.close(),
      _userUpdatedController.close(),
      _authPayloadController.close(),
    ]);
  }
}
