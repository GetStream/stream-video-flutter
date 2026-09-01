import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// A widget that can be shown before joining a call. Measures latencies
/// and selects the best SFU. This speeds up the process of joining when
/// the user decides to enter the call.
class StreamLobbyVideo extends StatefulWidget {
  /// Creates a new instance of [StreamLobbyView].
  const StreamLobbyVideo({
    super.key,
    required this.call,
    this.cardBackgroundColor,
    this.userAvatarTheme,
    this.onMicrophoneTrackSet,
    this.onCameraTrackSet,
    this.streamVideo,
    this.additionalActionsBuilder,
    this.initialCameraDevice,
  });

  /// Represents a call.
  final Call call;

  /// The color of the focus border.
  final Color? cardBackgroundColor;

  final RtcMediaDevice? initialCameraDevice;

  /// Theme for the avatar.
  final StreamUserAvatarThemeData? userAvatarTheme;

  /// Called with the microphone track whenever it is created, and with null
  /// when it is stopped.
  ///
  /// The track becomes the caller's to manage: this widget never stops one it
  /// has handed over, because the track may well outlive it. Passing it to
  /// `CallConnectOptions.microphone` as a [TrackOption.provided] carries a
  /// warmed-up microphone into the call rather than opening a second one.
  /// Whoever takes it is responsible for stopping it.
  final FutureOr<void> Function(RtcLocalAudioTrack?)? onMicrophoneTrackSet;

  /// Called with the camera track whenever it is created, and with null when it
  /// is stopped.
  ///
  /// The track becomes the caller's to manage — see [onMicrophoneTrackSet].
  final FutureOr<void> Function(RtcLocalCameraTrack?)? onCameraTrackSet;

  final List<Widget> Function(BuildContext, Call)? additionalActionsBuilder;

  /// An instance of [StreamVideo].
  ///
  /// If not provided, it will be obtained via StreamVideo.instance
  final StreamVideo? streamVideo;

  @override
  State<StreamLobbyVideo> createState() => _StreamLobbyVideoState();
}

class _StreamLobbyVideoState extends State<StreamLobbyVideo> {
  late final _logger = taggedLogger(tag: 'SV:LobbyView');

  RtcLocalAudioTrack? _microphoneTrack;
  RtcLocalCameraTrack? _cameraTrack;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final callSettings = widget.call.state.value.settings;
      if (callSettings.audio.micDefaultOn) {
        toggleMicrophone();
      }

      if (callSettings.video.cameraDefaultOn) {
        toggleCamera();
      }
    });
  }

  Future<void> toggleCamera() async {
    if (_cameraTrack != null) {
      await _cameraTrack?.stop();
      await widget.onCameraTrackSet?.call(null);

      return setState(() => _cameraTrack = null);
    }

    try {
      final nativeFactory = await widget.call.ensureNativeFactory();
      final cameraTrack = await RtcLocalTrack.camera(
        constraints: CameraConstraints(
          deviceId: widget.initialCameraDevice?.id,
        ),
        nativeFactory: nativeFactory,
      );
      await widget.onCameraTrackSet?.call(cameraTrack);

      return setState(() => _cameraTrack = cameraTrack);
    } catch (e) {
      _logger.w(() => 'Error creating camera track: $e');
    }
  }

  Future<void> toggleMicrophone() async {
    if (_microphoneTrack != null) {
      await _microphoneTrack?.stop();
      await widget.onMicrophoneTrackSet?.call(null);

      return setState(() => _microphoneTrack = null);
    }

    try {
      final nativeFactory = await widget.call.ensureNativeFactory();
      final microphoneTrack = await RtcLocalTrack.audio(
        nativeFactory: nativeFactory,
      );
      await widget.onMicrophoneTrackSet?.call(microphoneTrack);

      return setState(() => _microphoneTrack = microphoneTrack);
    } catch (e) {
      _logger.w(() => 'Error creating microphone track: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamLobbyViewTheme.of(context);
    final cardBackgroundColor =
        widget.cardBackgroundColor ?? theme.cardBackgroundColor;
    final userAvatarTheme = widget.userAvatarTheme ?? theme.userAvatarTheme;

    final currentUser =
        (widget.streamVideo ?? StreamVideo.instance).currentUser;

    final cameraEnabled = _cameraTrack != null;
    final microphoneEnabled = _microphoneTrack != null;
    const minRatio = 178 / 127;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final maxHeight = constraints.maxWidth / minRatio;
              final height = math.min(360, maxHeight).toDouble();
              return SizedBox(
                height: height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: cardBackgroundColor),
                    child: Builder(
                      builder: (context) {
                        Widget placeHolderBuilder(BuildContext context) {
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
                                mirror:
                                    _cameraTrack!.mediaConstraints.facingMode ==
                                    FacingMode.user,
                                videoTrack: _cameraTrack!,
                                placeholderBuilder: placeHolderBuilder,
                              )
                            else
                              placeHolderBuilder(context),
                            Align(
                              alignment: AlignmentDirectional.bottomStart,
                              child: Padding(
                                padding: EdgeInsets.all(
                                  context.streamSpacing.sm,
                                ),
                                child: StreamParticipantLabel(
                                  name: currentUser.name,
                                  isAudioEnabled: microphoneEnabled,
                                  isSpeaking: false,
                                  isVideoEnabled: cameraEnabled,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CallControlButton(
                icon: Icon(
                  microphoneEnabled
                      ? context.streamIcons.voiceFill
                      : context.streamIcons.voiceOffFill,
                ),
                state: microphoneEnabled ? .neutral : .negative,
                onPressed: toggleMicrophone,
              ),
              CallControlButton(
                icon: Icon(
                  cameraEnabled
                      ? context.streamIcons.videoFill
                      : context.streamIcons.videoOffFill,
                ),
                state: cameraEnabled ? .neutral : .negative,
                onPressed: toggleCamera,
              ),
              if (widget.additionalActionsBuilder != null)
                ...widget.additionalActionsBuilder!(context, widget.call),
            ],
          ),
        ],
      ),
    );
  }
}
