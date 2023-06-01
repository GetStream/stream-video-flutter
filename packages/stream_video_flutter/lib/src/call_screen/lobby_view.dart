import 'dart:async';

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../call_participants/participant_label.dart';

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

  @override
  State<StreamLobbyView> createState() => _StreamLobbyViewState();
}

class _StreamLobbyViewState extends State<StreamLobbyView> {
  RtcLocalAudioTrack? _microphoneTrack;
  RtcLocalCameraTrack? _cameraTrack;
  bool _isJoiningCall = false;

  Future<void> toggleCamera() async {
    if (_cameraTrack != null) {
      await _cameraTrack?.stop();
      return setState(() => _cameraTrack = null);
    }

    try {
      final cameraTrack = await RtcLocalTrack.camera();
      return setState(() => _cameraTrack = cameraTrack);
    } catch (e) {
      streamLog.w('SV:LobbyView', () => 'Error creating camera track: $e');
    }
  }

  Future<void> toggleMicrophone() async {
    if (_microphoneTrack != null) {
      await _microphoneTrack?.stop();
      return setState(() => _microphoneTrack = null);
    }

    try {
      final microphoneTrack = await RtcLocalTrack.audio();
      return setState(() => _microphoneTrack = microphoneTrack);
    } catch (e) {
      streamLog.w('SV:LobbyView', () => 'Error creating microphone track: $e');
    }
  }

  void onJoinCallPressed() {
    _isJoiningCall = true;

    var options = const CallConnectOptions();

    final cameraTrack = _cameraTrack;
    if (cameraTrack != null) {
      options = options.copyWith(
        camera: TrackOption.provided(cameraTrack),
      );
    }

    final microphoneTrack = _microphoneTrack;
    if (microphoneTrack != null) {
      options = options.copyWith(
        microphone: TrackOption.provided(microphoneTrack),
      );
    }

    widget.onJoinCallPressed(options);
  }

  @override
  void initState() {
    super.initState();
    // Obtains SFU credentials and picks the best server, but doesn't
    // connect to the call yet.
    widget.call.join();
  }

  @override
  void dispose() {
    // Dispose tracks if we closed lobby screen without joining the call.
    if (!_isJoiningCall) {
      _cameraTrack?.stop();
      _microphoneTrack?.stop();
    }

    _cameraTrack = null;
    _microphoneTrack = null;
    super.dispose();
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

    final currentUser = StreamVideo.instance.currentUser;

    final cameraEnabled = _cameraTrack != null;
    final microphoneEnabled = _microphoneTrack != null;

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
                Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  height: 280,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: cardBackgroundColor),
                      child: Builder(
                        builder: (context) {
                          Widget placeHolderBuilder(BuildContext context) {
                            if (currentUser == null) return Container();
                            return Center(
                              child: StreamUserAvatarTheme(
                                data: userAvatarTheme,
                                child: StreamUserAvatar(
                                  user: currentUser,
                                ),
                              ),
                            );
                          }

                          return Stack(
                            children: [
                              if (cameraEnabled)
                                VideoTrackRenderer(
                                  mirror: true,
                                  videoFit: VideoFit.cover,
                                  videoTrack: _cameraTrack!,
                                  placeholderBuilder: placeHolderBuilder,
                                )
                              else
                                placeHolderBuilder(context),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: StreamParticipantLabel(
                                        isAudioEnabled: microphoneEnabled,
                                        isSpeaking: false,
                                        participantName:
                                            currentUser?.name ?? '',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CallControlOption(
                      icon: microphoneEnabled
                          ? const Icon(Icons.mic_rounded)
                          : const Icon(Icons.mic_off_rounded),
                      onPressed: toggleMicrophone,
                    ),
                    const SizedBox(width: 16),
                    CallControlOption(
                      icon: cameraEnabled
                          ? const Icon(Icons.videocam_rounded)
                          : const Icon(Icons.videocam_off_rounded),
                      onPressed: toggleCamera,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                                'You are about to join a call. 0 more people are in the call.',
                                style: textTheme.title3,
                              ),
                            ),
                            const SizedBox(height: 16),
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
                            )
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
