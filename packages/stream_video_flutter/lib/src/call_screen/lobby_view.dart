import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import 'lobby_participants_view.dart';

/// A widget that can be shown before joining a call. Measures latencies
/// and selects the best SFU. This speeds up the process of joining when
/// the user decides to enter the call.
class StreamLobbyView extends StatefulWidget {
  /// Creates a new instance of [StreamLobbyView].
  const StreamLobbyView({
    super.key,
    required this.call,
    required this.onJoinCallPressed,
    this.onCloseTap,
    this.backgroundColor,
    this.cardBackgroundColor,
    this.userAvatarTheme,
    this.participantAvatarTheme,
    this.streamVideo,
  });

  /// Represents a call.
  final Call call;

  /// The action to perform when pressing the "join call" button.
  final ValueSetter<CallConnectOptions> onJoinCallPressed;

  /// The action to perform when the back button is pressed.
  ///
  /// By default it calls [Navigator.pop].
  final VoidCallback? onCloseTap;

  /// The color of the background behind avatar.
  final Color? backgroundColor;

  /// The color of the focus border.
  final Color? cardBackgroundColor;

  /// Theme for the avatar.
  final StreamUserAvatarThemeData? userAvatarTheme;

  /// Theme for the participant avatar.
  final StreamUserAvatarThemeData? participantAvatarTheme;

  /// An instance of [StreamVideo].
  ///
  /// If not provided, it will be obtained via StreamVideo.instance
  final StreamVideo? streamVideo;

  @override
  State<StreamLobbyView> createState() => _StreamLobbyViewState();
}

class _StreamLobbyViewState extends State<StreamLobbyView> {
  late final _logger = taggedLogger(tag: 'SV:LobbyView');

  RtcLocalAudioTrack? _microphoneTrack;
  RtcLocalCameraTrack? _cameraTrack;
  List<CallParticipant> _participants = <CallParticipant>[];
  Map<String, CallUser> _users = <String, CallUser>{};

  StreamSubscription<Object>? _fetchSubscription;
  StreamSubscription<Object>? _eventSubscription;

  bool get hasCameraEnabled => _cameraTrack != null;

  bool get hasMicrophoneEnabled => _microphoneTrack != null;

  Future<void> toggleCamera() async {
    if (hasCameraEnabled) {
      await _cameraTrack?.stop();
      return setState(() => _cameraTrack = null);
    }

    try {
      final cameraTrack = await RtcLocalTrack.camera();
      return setState(() => _cameraTrack = cameraTrack);
    } catch (e) {
      _logger.w(() => 'Error creating camera track: $e');
    }
  }

  Future<void> toggleMicrophone() async {
    if (hasMicrophoneEnabled) {
      await _microphoneTrack?.stop();
      return setState(() => _microphoneTrack = null);
    }

    try {
      final microphoneTrack = await RtcLocalTrack.audio();
      return setState(() => _microphoneTrack = microphoneTrack);
    } catch (e) {
      _logger.w(() => 'Error creating microphone track: $e');
    }
  }

  void onJoinCallPressed() {
    var options = const CallConnectOptions();

    if (hasCameraEnabled) {
      options = options.copyWith(
        camera: TrackOption.enabled(),
      );
    }

    if (hasMicrophoneEnabled) {
      options = options.copyWith(
        microphone: TrackOption.enabled(),
      );
    }

    widget.onJoinCallPressed(options);
  }

  @override
  void initState() {
    super.initState();
    _fetchCall();
    _listenEvents();
  }

  @override
  void dispose() {
    _cameraTrack?.stop();
    _microphoneTrack?.stop();

    _cameraTrack = null;
    _microphoneTrack = null;
    _fetchSubscription?.cancel();
    _eventSubscription?.cancel();
    super.dispose();
  }

  void _fetchCall() {
    // Obtains SFU credentials and picks the best server, but doesn't
    // connect to the call yet.
    final currentUserId =
        (widget.streamVideo ?? StreamVideo.instance).currentUser.id;
    _logger.d(() => '[fetchCall] currentUserId: $currentUserId');
    _fetchSubscription?.cancel();
    _fetchSubscription = widget.call.getOrCreate().asStream().listen((result) {
      result.fold(
        success: (it) {
          _logger.v(() => '[fetchCall] completed: ${it.data}');
          final metadata = it.data.data.metadata;

          setState(() {
            _users = metadata.users;
            _participants = metadata.session.participants.values
                .sortedBy((it) => it.joinedAt ?? DateTime.now())
                .where((it) => it.userId != currentUserId)
                .toList();
          });
        },
        failure: (it) {
          _logger.e(() => '[fetchCall] failed: ${it.error}');
        },
      );
    });
  }

  void _listenEvents() {
    _eventSubscription?.cancel();
    _eventSubscription =
        (widget.streamVideo ?? StreamVideo.instance).events.listen((event) {
      if (event is CoordinatorCallSessionParticipantLeftEvent) {
        _logger.d(() => '[listenEvents] #userLeft; user: ${event.user}');
        _participants.removeWhere(
          (it) => it.userSessionId == event.participant.userSessionId,
        );
        final hasSameUser = _participants.firstWhereOrNull(
              (it) => it.userId == event.participant.userId,
            ) !=
            null;
        if (!hasSameUser) {
          _users.remove(event.user.id);
        }
        setState(() {});
      } else if (event is CoordinatorCallSessionParticipantJoinedEvent) {
        _logger.d(() => '[listenEvents] #userJoined; user: ${event.user}');
        _users[event.user.id] = event.user;
        _participants.add(event.participant);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;
    final colorTheme = streamVideoTheme.colorTheme;

    final theme = StreamLobbyViewTheme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.backgroundColor;
    final cardBackgroundColor =
        widget.cardBackgroundColor ?? theme.cardBackgroundColor;
    final userAvatarTheme = widget.userAvatarTheme ?? theme.userAvatarTheme;
    final participantAvatarTheme =
        widget.participantAvatarTheme ?? theme.participantAvatarTheme;

    final participants = _participants
        .map((it) => _users[it.userId])
        .nonNulls
        .map((e) => e.toUserInfo())
        .toList();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: colorTheme.textHighEmphasis,
            ),
            onPressed: () async {
              if (widget.onCloseTap != null) {
                widget.onCloseTap!();
              } else {
                await Navigator.maybePop(context);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  'Before Joining',
                  style: textTheme.title3.copyWith(
                    fontSize: 28,
                    color: colorTheme.textHighEmphasis,
                  ),
                ),
                Text(
                  'Setup your audio and video',
                  style: textTheme.title3.copyWith(
                    color: colorTheme.textLowEmphasis,
                  ),
                ),
                const SizedBox(height: 16),
                StreamLobbyVideo(
                  call: widget.call,
                  cardBackgroundColor: cardBackgroundColor,
                  userAvatarTheme: userAvatarTheme,
                  onMicrophoneTrackSet: (track) => _microphoneTrack = track,
                  onCameraTrackSet: (track) => _cameraTrack = track,
                ),
                const SizedBox(height: 24),
                Container(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.cardBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'You are about to join a call. ${participants.length} more people are in the call.',
                                style: textTheme.title3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (participants.isNotEmpty)
                              StreamLobbyParticipantsView(
                                participants: participants,
                                participantAvatarTheme: participantAvatarTheme,
                              ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorTheme.accentPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: const Size.fromHeight(40),
                              ),
                              onPressed: onJoinCallPressed,
                              child: Text(
                                'Join Call',
                                style: textTheme.title3Bold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 56),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on CallUser {
  UserInfo toUserInfo() {
    return UserInfo(
      id: id,
      name: name,
      image: image,
      role: roles.firstOrNull ?? '',
      teams: teams,
    );
  }
}
