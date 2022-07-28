import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/models/events/events.dart';
import 'package:stream_video/protobuf/video_events/events.pb.dart';
import 'package:stream_video/protobuf/video_models/models.pb.dart';
import 'package:stream_video/src/models/user_info.dart';
import 'package:stream_video/src/state/controllers/controllers.dart';
import 'package:stream_video/src/state/controllers/room_controller.dart';

class ClientState {
  //ingest this in state

  final _currentUserController = BehaviorSubject<UserInfo?>();

  set currentUser(UserInfo? user) {
    // _computeUnreadCounts(user);
    _currentUserController.add(user);
  }

  /// The current user
  UserInfo? get currentUser => _currentUserController.valueOrNull;

  final _healthcheckController = BehaviorSubject<Healthcheck>();

  set healthcheck(Healthcheck healthcheck) =>
      _healthcheckController.add(healthcheck);

  /// The current connection status value
  Healthcheck get healthcheck => _healthcheckController.value;

  /// This notifies of Healthcheck changes
  Stream<Healthcheck> get healthcheckStream =>
      _healthcheckController.stream.distinct();

  final _roomController = RoomController();

  //TODO: set participants

  CallController get calls => _roomController.calls;

  ParticipantController get participants => _roomController.participants;

  BroadcastController get broadcasts => _roomController.broadcasts;

  ScreenshareController get screenshares => _roomController.screenshares;

  AudioController get audios => _roomController.audios;

  VideoController get videos => _roomController.videos;

  RecordingController get recordings => _roomController.recordings;

  final _userUpdatedController = BehaviorSubject<UserUpdated>();

  set userUpdated(UserUpdated userUpdated) =>
      _userUpdatedController.add(userUpdated);

  /// The current connection status value
  UserUpdated get userUpdated => _userUpdatedController.value;

  /// This notifies of Healthcheck changes
  Stream<UserUpdated> get userUpdatedStream =>
      _userUpdatedController.stream.distinct();

  final _authPayloadController = BehaviorSubject<AuthPayload>();

  set authPayload(AuthPayload authPayload) =>
      _authPayloadController.add(authPayload);

  /// The current connection status value
  AuthPayload get authPayload => _authPayloadController.value;

  /// This notifies of Healthcheck changes
  Stream<AuthPayload> get authPayloadStream =>
      _authPayloadController.stream.distinct();

  Future<void> dispose() async {
    //TODO: dispose other controllers
    await Future.wait([_roomController.disposeCall()]);
  }
}
