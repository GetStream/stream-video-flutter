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
/// Opens the lobby's microphone track.
///
/// Injectable because [RtcLocalTrack]'s factories are static, so a test has no
/// other way to produce a track.
@visibleForTesting
typedef LobbyAudioTrackOpener = Future<RtcLocalAudioTrack> Function();

/// Opens the lobby's camera track on `deviceId`, or on the system default when
/// it is null. See [LobbyAudioTrackOpener].
@visibleForTesting
typedef LobbyCameraTrackOpener =
    Future<RtcLocalCameraTrack> Function(String? deviceId);

class StreamLobbyController extends ChangeNotifier {
  /// Creates a new instance of [StreamLobbyController].
  StreamLobbyController({
    required this.call,
    StreamVideo? streamVideo,
    RtcMediaDeviceNotifier? deviceNotifier,
    @visibleForTesting LobbyAudioTrackOpener? openMicrophoneTrack,
    @visibleForTesting LobbyCameraTrackOpener? openCameraTrack,
  }) : _streamVideo = streamVideo,
       _openMicrophoneTrack = openMicrophoneTrack,
       _openCameraTrack = openCameraTrack {
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
  bool _callDefaultsApplied = false;

  final LobbyAudioTrackOpener? _openMicrophoneTrack;
  final LobbyCameraTrackOpener? _openCameraTrack;

  /// Set by [dispose]. Every `await` here outlives the widget that owns this
  /// controller, so anything resuming after one has to check it: notifying a
  /// disposed [ChangeNotifier] throws, and a track that lands late has no
  /// owner left to stop it.
  bool _disposed = false;

  /// Whether a track is already being opened. Opening lasts as long as the
  /// permission prompt is up, which is ample time for a second tap.
  bool _openingMicrophone = false;
  bool _openingCamera = false;

  RtcLocalAudioTrack? _microphoneTrack;
  RtcLocalCameraTrack? _cameraTrack;
  Object? _microphoneError;
  Object? _cameraError;

  Object? _fetchError;

  /// Why the call could not be fetched, or null.
  ///
  /// [participants] is empty while this is set, which is not the same thing
  /// as an empty call — a host that wants to tell the two apart, or offer a
  /// retry, reads this.
  Object? get fetchError => _fetchError;

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

  /// Whether the microphone is not usable right now.
  ///
  /// True when opening it failed — permission refused, or a device another
  /// app is holding — and when the platform has stopped reporting any
  /// microphone since. A control for an unavailable device carries an error
  /// badge rather than the state a deliberate mute gets, so a permission
  /// problem is not mistaken for a choice the user made. Joining stays
  /// possible with the device disabled.
  ///
  /// This says how the control should *look*. Whether it can be pressed is
  /// [microphoneMissing]: a failure is often worth another try, so the badge
  /// alone does not disable the button.
  bool get microphoneUnavailable =>
      _microphoneError != null || microphoneMissing;

  /// Whether the camera is not usable right now. See [microphoneUnavailable].
  bool get cameraUnavailable => _cameraError != null || cameraMissing;

  /// Whether the platform reports no microphone to open at all.
  ///
  /// The retryable half of [microphoneUnavailable]. A failed open can be
  /// transient — another app was holding the device, or the user has since
  /// granted permission in system settings — and a retry is the only thing
  /// that clears the error, so a control whose *open* failed stays pressable
  /// and keeps its badge until one succeeds. With no device to open there is
  /// nothing a retry could achieve, so that control is disabled outright.
  ///
  /// Guarded on having opened the device rather than merely on
  /// [StreamMediaDevicesController.hasEnumerated], which is the weaker check a
  /// call can use: before permission the platform may name no device at all
  /// even where one exists, so an empty list only means something once
  /// `getUserMedia` has succeeded.
  /// A track that is open is itself proof the device exists, whatever the
  /// enumeration says, so a live microphone is never missing — otherwise an
  /// empty device list would badge a working microphone and take away the
  /// user's only way to mute it.
  bool get microphoneMissing =>
      _microphoneTrack == null &&
      _hasOpenedMicrophone &&
      devices.audioInputs.isEmpty;

  /// Whether the platform reports no camera to open at all. See
  /// [microphoneMissing].
  bool get cameraMissing =>
      _cameraTrack == null && _hasOpenedCamera && devices.videoInputs.isEmpty;

  /// Whether the microphone has been opened at least once.
  ///
  /// Device labels only arrive once `getUserMedia` has succeeded, so a
  /// microphone picker has nothing to show before this is true. Not a
  /// permission check — nothing here asks the platform what it would grant.
  bool get hasOpenedMicrophone => _hasOpenedMicrophone;
  bool _hasOpenedMicrophone = false;

  /// Whether the camera has been opened at least once. See
  /// [hasOpenedMicrophone].
  bool get hasOpenedCamera => _hasOpenedCamera;
  bool _hasOpenedCamera = false;

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
      final track = _microphoneTrack;
      _microphoneTrack = null;
      _notify();
      await track?.stop();
      return;
    }

    if (_openingMicrophone) return;
    _openingMicrophone = true;
    try {
      final track = await _openMicrophone();
      // The lobby was left while the device was opening. Nothing will ever
      // hand this track to a call, so this is the only chance to stop it.
      if (_disposed) return await track.stop();

      _microphoneTrack = track;
      _microphoneError = null;
      _hasOpenedMicrophone = true;
    } catch (e, stk) {
      // The stack trace is what separates a refused permission from a device
      // another app is holding, so it is worth keeping.
      _logger.e(() => 'Error creating microphone track: $e\n$stk');
      _microphoneError = e;
    } finally {
      _openingMicrophone = false;
    }

    _notify();
  }

  /// Turns the camera on if it is off, and off if it is on.
  Future<void> toggleCamera() async {
    if (_cameraTrack != null) {
      final track = _cameraTrack;
      _cameraTrack = null;
      _notify();
      await track?.stop();
      return;
    }

    await _openCamera();
  }

  Future<void> _openCamera() async {
    if (_openingCamera) return;
    _openingCamera = true;
    try {
      final track = await _openCameraTrackFor(devices.selectedVideoInput?.id);
      // See toggleMicrophone.
      if (_disposed) return await track.stop();

      _cameraTrack = track;
      _cameraError = null;
      _hasOpenedCamera = true;
    } catch (e, stk) {
      _logger.e(() => 'Error creating camera track: $e\n$stk');
      _cameraError = e;
    } finally {
      _openingCamera = false;
    }

    _notify();
  }

  /// Reopens the preview on the newly picked camera.
  ///
  /// A camera the user has turned off stays off: picking a device is not a
  /// request to start filming.
  Future<void> _restartCamera() async {
    final track = _cameraTrack;
    if (track == null) return;

    _cameraTrack = null;
    _notify();
    await track.stop();

    await _openCamera();
  }

  Future<RtcLocalAudioTrack> _openMicrophone() async {
    if (_openMicrophoneTrack case final open?) return open();
    return RtcLocalTrack.audio(nativeFactory: await call.ensureNativeFactory());
  }

  Future<RtcLocalCameraTrack> _openCameraTrackFor(String? deviceId) async {
    if (_openCameraTrack case final open?) return open(deviceId);
    return RtcLocalTrack.camera(
      constraints: CameraConstraints(deviceId: deviceId),
      nativeFactory: await call.ensureNativeFactory(),
    );
  }

  /// [notifyListeners], unless this controller is already disposed.
  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  /// Opens whatever the call says should be on when someone arrives.
  ///
  /// Called from the fetch, because that is where the settings arrive: a
  /// `CallState` starts out carrying `const CallSettings()`, whose defaults
  /// are both on, until the call's metadata lands.
  void _applyCallDefaults(CallSettings settings) {
    if (_disposed || _callDefaultsApplied) return;
    _callDefaultsApplied = true;

    if (settings.audio.micDefaultOn) unawaited(toggleMicrophone());
    if (settings.video.cameraDefaultOn) unawaited(toggleCamera());
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
          _fetchError = null;
          _applyCallDefaults(metadata.settings);
          _notify();
        },
        onFailure: (error, stackTrace) {
          _logger.e(() => '[fetchCall] failed: $error\n$stackTrace');
          _fetchError = error;
          // The call's own settings are unknowable now, so fall back to what
          // its state carries. A lobby that cannot reach the coordinator is
          // still a lobby: the user gets a preview and the join button, which
          // is where the failure will surface properly.
          _applyCallDefaults(call.state.value.settings);
          _notify();
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

        _notify();
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

        _notify();
      }
    });
  }

  @override
  void dispose() {
    // Set before anything else: an open already in flight checks this to
    // decide whether the track it is about to produce has an owner.
    _disposed = true;
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

  /// Whether the tracks now belong to the call rather than to this lobby.
  ///
  /// Once true, [dispose] leaves the microphone and camera running: the call
  /// is publishing them, and stopping them here would cut its audio and video.
  bool get tracksHandedOver => _tracksHandedOver;

  /// Marks the tracks as belonging to the call, so [dispose] leaves them
  /// running.
  ///
  /// Call this when [connectOptions] has been passed to a join.
  void handOverTracks() => _tracksHandedOver = true;

  /// Takes the tracks back, so [dispose] stops them again.
  ///
  /// Call this when a join [handOverTracks] was called for did not happen
  /// after all and the lobby carries on with its preview.
  void reclaimTracks() => _tracksHandedOver = false;
}
