import 'package:rxdart/rxdart.dart';
import 'package:stream_video_dart/protobuf/video_events/events.pb.dart';
import 'package:stream_video_dart/protobuf/video_models/models.pb.dart';

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

  final _callRingingController = BehaviorSubject<CallRinging>();

  set callRinging(CallRinging callRinging) =>
      _callRingingController.add(callRinging);

  /// The current connection status value
  CallRinging get callRinging => _callRingingController.value;

  /// This notifies of Healthcheck changes
  Stream<CallRinging> get callRingingStream =>
      _callRingingController.stream.distinct();

  final _callCreatedController = BehaviorSubject<CallCreated>();

  set callCreated(CallCreated callCreated) =>
      _callCreatedController.add(callCreated);

  /// The current connection status value
  CallCreated get callCreated => _callCreatedController.value;

  /// This notifies of Healthcheck changes
  Stream<CallCreated> get callCreatedStream =>
      _callCreatedController.stream.distinct();

  final _callUpdatedController = BehaviorSubject<CallUpdated>();

  set callUpdated(CallUpdated callUpdated) =>
      _callUpdatedController.add(callUpdated);

  /// The current connection status value
  CallUpdated get callUpdated => _callUpdatedController.value;

  /// This notifies of Healthcheck changes
  Stream<CallUpdated> get callUpdatedStream =>
      _callUpdatedController.stream.distinct();

  final _callEndedController = BehaviorSubject<CallEnded>();

  set callEnded(CallEnded callEnded) => _callEndedController.add(callEnded);

  /// The current connection status value
  CallEnded get callEnded => _callEndedController.value;

  /// This notifies of Healthcheck changes
  Stream<CallEnded> get callEndedStream =>
      _callEndedController.stream.distinct();

  final _callDeletedController = BehaviorSubject<CallDeleted>();

  set callDeleted(CallDeleted callDeleted) =>
      _callDeletedController.add(callDeleted);

  /// The current connection status value
  CallDeleted get callDeleted => _callDeletedController.value;

  /// This notifies of Healthcheck changes
  Stream<CallDeleted> get callDeletedStream =>
      _callDeletedController.stream.distinct();

  final _userUpdatedController = BehaviorSubject<UserUpdated>();

  set userUpdated(UserUpdated userUpdated) =>
      _userUpdatedController.add(userUpdated);

  /// The current connection status value
  UserUpdated get userUpdated => _userUpdatedController.value;

  /// This notifies of Healthcheck changes
  Stream<UserUpdated> get userUpdatedStream =>
      _userUpdatedController.stream.distinct();

  final _participantInvitedController = BehaviorSubject<ParticipantInvited>();

  set participantInvited(ParticipantInvited participantInvited) =>
      _participantInvitedController.add(participantInvited);

  /// The current connection status value
  ParticipantInvited get participantInvited =>
      _participantInvitedController.value;

  /// This notifies of Healthcheck changes
  Stream<ParticipantInvited> get participantInvitedStream =>
      _participantInvitedController.stream.distinct();

  final _participantUpdatedController = BehaviorSubject<ParticipantUpdated>();

  set participantUpdated(ParticipantUpdated participantUpdated) =>
      _participantUpdatedController.add(participantUpdated);

  /// The current connection status value
  ParticipantUpdated get participantUpdated =>
      _participantUpdatedController.value;

  /// This notifies of Healthcheck changes
  Stream<ParticipantUpdated> get participantUpdatedStream =>
      _participantUpdatedController.stream.distinct();

  final _participantDeletedController = BehaviorSubject<ParticipantDeleted>();

  set participantDeleted(ParticipantDeleted participantDeleted) =>
      _participantDeletedController.add(participantDeleted);

  /// The current connection status value
  ParticipantDeleted get participantDeleted =>
      _participantDeletedController.value;

  /// This notifies of Healthcheck changes
  Stream<ParticipantDeleted> get participantDeletedStream =>
      _participantDeletedController.stream.distinct();

  final _participantJoinedController = BehaviorSubject<ParticipantJoined>();

  set participantJoined(ParticipantJoined participantJoined) =>
      _participantJoinedController.add(participantJoined);

  /// The current connection status value
  ParticipantJoined get participantJoined => _participantJoinedController.value;

  /// This notifies of Healthcheck changes
  Stream<ParticipantJoined> get participantJoinedStream =>
      _participantJoinedController.stream.distinct();

  final _participantLeftController = BehaviorSubject<ParticipantLeft>();

  set participantLeft(ParticipantLeft participantLeft) =>
      _participantLeftController.add(participantLeft);

  /// The current connection status value
  ParticipantLeft get participantLeft => _participantLeftController.value;

  /// This notifies of Healthcheck changes
  Stream<ParticipantLeft> get participantLeftStream =>
      _participantLeftController.stream.distinct();

  final _broadcastStartedController = BehaviorSubject<BroadcastStarted>();

  set broadcastStarted(BroadcastStarted broadcastStarted) =>
      _broadcastStartedController.add(broadcastStarted);

  /// The current connection status value
  BroadcastStarted get broadcastStarted => _broadcastStartedController.value;

  /// This notifies of Healthcheck changes
  Stream<BroadcastStarted> get broadcastStartedStream =>
      _broadcastStartedController.stream.distinct();

  final _broadcastEndedController = BehaviorSubject<BroadcastEnded>();

  set broadcastEnded(BroadcastEnded broadcastEnded) =>
      _broadcastEndedController.add(broadcastEnded);

  /// The current connection status value
  BroadcastEnded get broadcastEnded => _broadcastEndedController.value;

  /// This notifies of Healthcheck changes
  Stream<BroadcastEnded> get broadcastEndedStream =>
      _broadcastEndedController.stream.distinct();

  final _authPayloadController = BehaviorSubject<AuthPayload>();

  set authPayload(AuthPayload authPayload) =>
      _authPayloadController.add(authPayload);

  /// The current connection status value
  AuthPayload get authPayload => _authPayloadController.value;

  /// This notifies of Healthcheck changes
  Stream<AuthPayload> get authPayloadStream =>
      _authPayloadController.stream.distinct();

  /// Call this method to dispose this object
  Future<void> dispose() async {
    await Future.wait([
      _currentUserController.close(),
      _healthcheckController.close(),
      _callRingingController.close(),
      _callCreatedController.close(),
      _callUpdatedController.close(),
      _callEndedController.close(),
      _callDeletedController.close(),
      _userUpdatedController.close(),
      _participantInvitedController.close(),
      _participantInvitedController.close(),
      _participantDeletedController.close(),
      _participantJoinedController.close(),
      _participantLeftController.close(),
      _broadcastStartedController.close(),
      _broadcastEndedController.close(),
      _broadcastEndedController.close()
    ]);
  }
}
