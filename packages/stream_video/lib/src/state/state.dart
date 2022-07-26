import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_video/events/events.dart';
import 'package:stream_video/protobuf/video_events/events.pb.dart';
import 'package:stream_video/protobuf/video_models/models.pb.dart';
import 'package:stream_video/src/state/broadcast_controller.dart';
import 'package:stream_video/src/state/call_controller.dart';
import 'package:stream_video/src/state/participant_controller.dart';

class ClientState {
  //ingest this in state

  final _currentUserController = BehaviorSubject<User?>();

  set currentUser(User? user) {
    // _computeUnreadCounts(user);
    _currentUserController.add(user);
  }

  /// The current user
  User? get currentUser => _currentUserController.valueOrNull;

  final _healthcheckController = BehaviorSubject<Healthcheck>();

  set healthcheck(Healthcheck healthcheck) =>
      _healthcheckController.add(healthcheck);

  /// The current connection status value
  Healthcheck get healthcheck => _healthcheckController.value;

  /// This notifies of Healthcheck changes
  Stream<Healthcheck> get healthcheckStream =>
      _healthcheckController.stream.distinct();

  final calls = CallController();

  final participants = ParticipantController();

  final broadcasts = BroadcastController();

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

  // Call this method to dispose this object
  Future<void> dispose() async {
    await Future.wait([calls.dispose(), participants.dispose()]);
  }
}
