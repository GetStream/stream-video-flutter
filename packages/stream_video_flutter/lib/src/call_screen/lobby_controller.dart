import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../../stream_video_flutter.dart';

/// Everything the lobby knows before the call is joined: the warmed-up
/// microphone and camera tracks, the devices they run on, and who is already
/// in the call.
///
/// The lobby's action widgets are handed to [StreamLobbyView] as a plain list
/// of widgets, so they cannot take callbacks through their constructors. They
/// read this from the tree through [StreamLobbyScope] instead, which is why
/// all of the state that used to be spread across the view, its preview and
/// the device pickers lives here.
///
/// Tracks created here are handed to the call as [TrackOption.provided], so
/// the call carries on with the microphone and camera the user was already
/// previewing rather than opening a second pair.
class StreamLobbyController extends ChangeNotifier {
  /// Creates a new instance of [StreamLobbyController].
  StreamLobbyController({
    required this.call,
    StreamVideo? streamVideo,
    RtcMediaDeviceNotifier? deviceNotifier,
  }) : _streamVideo = streamVideo {
    devices = StreamMediaDevicesController(
      deviceNotifier: deviceNotifier,
      // Switching camera while previewing means tearing the preview down and
      // opening it again on the new device; nothing else can do this, which is
      // why the controller takes the effect as a hook rather than performing
      // it itself.
      onVideoInputSelected: (_) => _restartCamera(),
    );

    // StreamLobbyScope listens to this controller, not to the device one, so
    // a device list arriving or a selection changing has to be forwarded or
    // the pickers never rebuild.
    devices.addListener(notifyListeners);

    _fetchCall();
    _listenEvents();
    _applyCallDefaults();
  }

  late final _logger = taggedLogger(tag: 'SV:LobbyController');

  /// The call the lobby is a waiting room for.
  final Call call;

  final StreamVideo? _streamVideo;

  StreamVideo get _video => _streamVideo ?? StreamVideo.instance;

  /// The device lists and the current selection.
  ///
  /// Shared by every action that offers a device choice.
  late final StreamMediaDevicesController devices;

  StreamSubscription<Object>? _fetchSubscription;
  StreamSubscription<Object>? _eventSubscription;

  RtcLocalAudioTrack? _microphoneTrack;
  RtcLocalCameraTrack? _cameraTrack;
  Object? _microphoneError;
  Object? _cameraError;

  List<CallParticipant> _participants = const [];
  Map<String, CallUser> _users = {};

  /// The live microphone track, or null when the microphone is off.
  RtcLocalAudioTrack? get microphoneTrack => _microphoneTrack;

  /// The live camera track, or null when the camera is off.
  RtcLocalCameraTrack? get cameraTrack => _cameraTrack;

  /// Whether the microphone is on.
  bool get microphoneEnabled => _microphoneTrack != null;

  /// Whether the camera is on.
  bool get cameraEnabled => _cameraTrack != null;

  /// The last failure opening the microphone, or null.
  ///
  /// Drives the error badge on the microphone control.
  Object? get microphoneError => _microphoneError;

  /// The last failure opening the camera, or null.
  Object? get cameraError => _cameraError;

  /// Whether the microphone cannot be used at all.
  ///
  /// True when opening it failed — permission refused, or nothing to open —
  /// and when the platform has stopped reporting any microphone since. A
  /// control for an unavailable device is drawn disabled with an error badge
  /// rather than in the state a deliberate mute gets, so a permission problem
  /// is not mistaken for a choice the user made. Joining stays possible with
  /// the device disabled.
  bool get microphoneUnavailable =>
      _microphoneError != null ||
      (_hasMicrophonePermission && devices.audioInputs.isEmpty);

  /// Whether the camera cannot be used at all. See [microphoneUnavailable].
  bool get cameraUnavailable =>
      _cameraError != null ||
      (_hasCameraPermission && devices.videoInputs.isEmpty);

  /// Whether the microphone has been opened at least once.
  ///
  /// Device labels only arrive once `getUserMedia` has succeeded, so a
  /// microphone picker has nothing to show before this is true.
  bool get hasMicrophonePermission => _hasMicrophonePermission;
  bool _hasMicrophonePermission = false;

  /// Whether the camera has been opened at least once. See
  /// [hasMicrophonePermission].
  bool get hasCameraPermission => _hasCameraPermission;
  bool _hasCameraPermission = false;

  /// The people already in the call, oldest first, excluding the local user.
  List<CallParticipant> get participants => _participants;

  /// The users behind [participants], by id.
  Map<String, CallUser> get users => _users;

  /// The user this lobby belongs to.
  UserInfo get currentUser => _video.currentUser;

  /// The local user as a participant, so the preview can be drawn with the
  /// same `StreamParticipantTile` the call itself uses.
  ///
  /// Nobody has joined yet, so there is no session and the tracks are not
  /// registered with the call: the ids are empty and the tile is handed its
  /// renderer directly. What is real is the mute state, which is what the tile
  /// draws its label and its outline from.
  CallParticipantState get localParticipant {
    final camera = cameraTrack;

    return CallParticipantState(
      userId: currentUser.id,
      name: currentUser.name,
      image: currentUser.image,
      roles: [currentUser.role],
      // ignore: deprecated_member_use, still required by the constructor
      custom: const {},
      sessionId: '',
      trackIdPrefix: '',
      isLocal: true,
      // Left false: the in-call speaking state comes from the SFU, and there
      // is no local mic level before joining. See FLU-714.
      publishedTracks: {
        SfuTrackType.audio: TrackState.local(
          muted: !microphoneEnabled,
          sourceDevice: devices.selectedAudioInput,
        ),
        SfuTrackType.video: TrackState.local(
          muted: !cameraEnabled,
          sourceDevice: devices.selectedVideoInput,
          cameraPosition: switch (camera?.mediaConstraints.facingMode) {
            FacingMode.user => CameraPosition.front,
            FacingMode.environment => CameraPosition.back,
            _ => null,
          },
        ),
      },
    );
  }

  /// How the call should be joined: the warmed-up tracks, and the devices the
  /// user picked for them.
  CallConnectOptions get connectOptions {
    var options = CallConnectOptions(
      audioInputDevice: devices.selectedAudioInput,
      audioOutputDevice: devices.selectedAudioOutput,
      videoInputDevice: devices.selectedVideoInput,
    );

    final cameraTrack = _cameraTrack;
    if (cameraTrack != null) {
      options = options.copyWith(camera: TrackOption.provided(cameraTrack));
    }

    final microphoneTrack = _microphoneTrack;
    if (microphoneTrack != null) {
      options = options.copyWith(
        microphone: TrackOption.provided(microphoneTrack),
      );
    }

    return options;
  }

  /// Turns the microphone on if it is off, and off if it is on.
  Future<void> toggleMicrophone() async {
    if (_microphoneTrack != null) {
      await _microphoneTrack?.stop();
      _microphoneTrack = null;
      return notifyListeners();
    }

    try {
      final nativeFactory = await call.ensureNativeFactory();
      _microphoneTrack = await RtcLocalTrack.audio(
        nativeFactory: nativeFactory,
      );
      _microphoneError = null;
      _hasMicrophonePermission = true;
    } catch (e) {
      _logger.w(() => 'Error creating microphone track: $e');
      _microphoneError = e;
    }

    notifyListeners();
  }

  /// Turns the camera on if it is off, and off if it is on.
  Future<void> toggleCamera() async {
    if (_cameraTrack != null) {
      await _cameraTrack?.stop();
      _cameraTrack = null;
      return notifyListeners();
    }

    await _openCamera();
  }

  Future<void> _openCamera() async {
    try {
      final nativeFactory = await call.ensureNativeFactory();
      _cameraTrack = await RtcLocalTrack.camera(
        constraints: CameraConstraints(
          deviceId: devices.selectedVideoInput?.id,
        ),
        nativeFactory: nativeFactory,
      );
      _cameraError = null;
      _hasCameraPermission = true;
    } catch (e) {
      _logger.w(() => 'Error creating camera track: $e');
      _cameraError = e;
    }

    notifyListeners();
  }

  /// Reopens the preview on the newly picked camera.
  ///
  /// A camera the user has turned off stays off: picking a device is not a
  /// request to start filming.
  Future<void> _restartCamera() async {
    final track = _cameraTrack;
    if (track == null) return;

    await track.stop();
    _cameraTrack = null;
    notifyListeners();

    await _openCamera();
  }

  void _applyCallDefaults() {
    // The call's settings arrive with its state, which is not populated yet
    // when the controller is constructed.
    Future.delayed(Duration.zero, () {
      final settings = call.state.value.settings;
      if (settings.audio.micDefaultOn) toggleMicrophone();
      if (settings.video.cameraDefaultOn) toggleCamera();
    });
  }

  void _fetchCall() {
    // Obtains SFU credentials and picks the best server, but doesn't connect
    // to the call yet.
    final currentUserId = _video.currentUser.id;
    _logger.d(() => '[fetchCall] currentUserId: $currentUserId');

    _fetchSubscription?.cancel();
    _fetchSubscription = call.getOrCreate().asStream().listen((result) {
      result.fold(
        onSuccess: (callData) {
          _logger.v(() => '[fetchCall] completed: $callData');
          final metadata = callData.data.metadata;

          // One `now` for the whole sort: `sortedBy` calls the key function
          // repeatedly, so a fresh DateTime.now() per element would not be a
          // stable ordering.
          final now = DateTime.now();

          _users = {...metadata.users};
          _participants = metadata.session.participants.values
              .where((it) => it.userId != currentUserId)
              .sortedBy((it) => it.joinedAt ?? now)
              .toList();
          notifyListeners();
        },
        onFailure: (error, stackTrace) {
          _logger.e(() => '[fetchCall] failed: $error');
        },
      );
    });
  }

  void _listenEvents() {
    _eventSubscription?.cancel();
    _eventSubscription = _video.events.listen((event) {
      if (event is CoordinatorCallSessionParticipantLeftEvent) {
        _logger.d(
          () =>
              '[listenEvents] #userLeft; user: ${event.user}, '
              'reason: ${event.reason}',
        );
        final remaining = [..._participants]
          ..removeWhere(
            (it) => it.userSessionId == event.participant.userSessionId,
          );
        _participants = remaining;

        final hasSameUser = remaining.any(
          (it) => it.userId == event.participant.userId,
        );
        if (!hasSameUser) _users = {..._users}..remove(event.user.id);

        notifyListeners();
      } else if (event is CoordinatorCallSessionParticipantJoinedEvent) {
        _logger.d(() => '[listenEvents] #userJoined; user: ${event.user}');

        final participant = event.participant;
        // The local user is filtered out of the fetched snapshot, so a join
        // event for them must not slip one back in.
        if (participant.userId == _video.currentUser.id) return;

        // Upsert rather than append. `getOrCreate` returns a snapshot of the
        // session while this subscription is already live, so a join that is
        // already reflected in that snapshot still arrives as an event — and
        // appending it blindly listed the same person twice. Identity is the
        // session, not the user: someone on a phone and a laptop is two
        // participants and belongs in the list twice.
        final index = _participants.indexWhere(
          (it) => it.userSessionId == participant.userSessionId,
        );

        _users = {..._users, event.user.id: event.user};
        _participants = [..._participants];
        if (index == -1) {
          _participants.add(participant);
        } else {
          _participants[index] = participant;
        }

        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _fetchSubscription?.cancel();
    _eventSubscription?.cancel();
    devices
      ..removeListener(notifyListeners)
      ..dispose();

    // Tracks are only stopped if they were not handed to a call. A track
    // passed as TrackOption.provided outlives the lobby, and stopping it here
    // would kill the microphone the user just joined with.
    if (!_tracksHandedOver) {
      _microphoneTrack?.stop();
      _cameraTrack?.stop();
    }
    _microphoneTrack = null;
    _cameraTrack = null;

    super.dispose();
  }

  bool _tracksHandedOver = false;

  /// Marks the tracks as belonging to the call, so [dispose] leaves them
  /// running.
  ///
  /// Call this when [connectOptions] has been passed to a join.
  void handOverTracks() => _tracksHandedOver = true;
}
