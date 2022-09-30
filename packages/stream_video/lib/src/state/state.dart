import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/coordinator/client_v1_rpc/websocket.pb.dart';
import 'package:stream_video/protobuf/video/coordinator/event_v1/event.pb.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/state/controllers/call_members_controller.dart';
import 'package:stream_video/src/state/controllers/controllers.dart';
import 'package:stream_video/src/state/controllers/sfu_controller.dart';
import 'package:stream_video/src/state/controllers/track_controller.dart';

class StreamCallState {
  final String? userId;
  final String? clientId;
  final String? callType;
  final String? callId;
  final bool? video;
  final bool? audio;

  StreamCallState({
    this.userId,
    this.clientId,
    this.callType,
    this.callId,
    this.video,
    this.audio,
  });
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

  final _currentUserController = BehaviorSubject<UserInfo?>();

  final _callStateController = BehaviorSubject.seeded(StreamCallState());

  set callState(StreamCallState state) => _callStateController.add(state);

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

  final _healthcheckController = BehaviorSubject<WebsocketHealthcheck>();

  set healthcheck(WebsocketHealthcheck healthcheck) =>
      _healthcheckController.add(healthcheck);

  /// The current connection status value
  WebsocketHealthcheck get healthcheck => _healthcheckController.value;

  /// This notifies of Healthcheck changes
  Stream<WebsocketHealthcheck> get healthcheckStream =>
      _healthcheckController.stream.distinct();

  final _roomController = RoomController();

  //TODO: set participants

  SfuController get sfu => _roomController.sfu;

  TrackController get tracks => _roomController.tracks;

  CallController get calls => _roomController.calls;

  ParticipantController get participants => _roomController.participants;

  BroadcastController get broadcasts => _roomController.broadcasts;

  // ScreenshareController get screenshares => _roomController.screenshares;

  // AudioController get audios => _roomController.audios;

  // VideoController get videos => _roomController.videos;

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
    //TODO: dispose other controllers
    await Future.wait([_roomController.disposeCall()]);
  }
}
