import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../stream_video_flutter.dart';
import '../call_participants/participant_label.dart';

/// A widget that can be shown before joining a call. Measures latencies
/// and selects the best SFU. This speeds up the process of joining when
/// the user decides to enter the call.
class StreamPreJoiningView extends StatefulWidget {
  /// Creates a new instance of [StreamPreJoiningView].
  const StreamPreJoiningView({
    super.key,
    required this.call,
    required this.onJoinCallTap,
    this.onCloseTap,
  });

  /// Represents a call.
  final CallV2 call;

  /// The action to perform when pressing the "join call" button.
  final VoidCallback onJoinCallTap;

  /// The action to perform when the back button is pressed.
  ///
  /// By default it calls [Navigator.pop].
  final VoidCallback? onCloseTap;

  @override
  State<StreamPreJoiningView> createState() => _StreamPreJoiningViewState();
}

class _StreamPreJoiningViewState extends State<StreamPreJoiningView> {
  /// Represents a call.
  CallV2 get call => widget.call;

  /// Video renderer for the local media stream.
  final _localVideoRenderer = RTCVideoRenderer();

  /// The media stream with local audio and video tracks.
  MediaStream? _localMediaStream;

  /// Whether the microphone is enabled.
  bool _isAudioEnabled = false;

  /// Whether the camera is enabled.
  bool _isVideoEnabled = false;

  /// If joining is still in progress.
  bool _isJoining = true;

  @override
  void initState() {
    super.initState();
    _initRenderer();
    _joinCall();
  }

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;
    final colorTheme = streamVideoTheme.colorTheme;
    final theme = streamVideoTheme.prejoiningViewTheme;

    final currentUser = StreamVideoV2.instance.currentUser;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
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
                await Navigator.of(context).maybePop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(color: theme.cardBackgroundColor),
                  child: Stack(
                    children: [
                      if (_isVideoEnabled)
                        RTCVideoView(
                          _localVideoRenderer,
                          filterQuality: FilterQuality.high,
                          mirror: true,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        )
                      else if (currentUser != null)
                        Center(
                          child: StreamUserAvatar(
                            avatarTheme: theme.avatarTheme,
                            user: currentUser,
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: StreamParticipantLabel(
                                isAudioEnabled: _isAudioEnabled,
                                isSpeaking: false,
                                participantName: currentUser?.name ?? '',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CallControlOption(
                  icon: _isAudioEnabled
                      ? const Icon(Icons.mic_rounded)
                      : const Icon(Icons.mic_off_rounded),
                  onPressed: _isAudioEnabled ? _disableAudio : _enableAudio,
                ),
                const SizedBox(width: 16),
                CallControlOption(
                  icon: _isVideoEnabled
                      ? const Icon(Icons.videocam_rounded)
                      : const Icon(Icons.videocam_off_rounded),
                  onPressed: _isVideoEnabled ? _disableVideo : _enableVideo,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              constraints: const BoxConstraints(maxWidth: 360),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(color: theme.cardBackgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'You are about to join a call. 0 more people are in the call.',
                            style: textTheme.title3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (!_isJoining)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorTheme.accentPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size.fromHeight(40),
                            ),
                            onPressed: () {
                              widget.onJoinCallTap();
                            },
                            child: Text(
                              'Join Call',
                              style: textTheme.title3Bold
                                  .copyWith(color: Colors.white),
                            ),
                          )
                        else
                          const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _removeVideoTracks();
    await _removeAudioTracks();
    await _localVideoRenderer.srcObject?.dispose();
    await _localVideoRenderer.dispose();
  }

  /// Initialize the video renderer.
  Future<void> _initRenderer() async {
    await _localVideoRenderer.initialize();
  }

  /// Obtains SFU credentials and picks the best server, but doesn't
  /// connect to the call yet.
  Future<void> _joinCall() async {
    final result = await call.joinCall();
    if (result.isSuccess) {
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }

  /// Enables camera.
  Future<void> _enableVideo() async {
    final newStream = await navigator.mediaDevices.getUserMedia(
      _getMediaConstraints(isVideoEnabled: true),
    );
    if (_localMediaStream != null) {
      await _removeVideoTracks();
      final tracks = newStream.getVideoTracks();
      for (final newTrack in tracks) {
        await _localMediaStream!.addTrack(newTrack);
      }
    } else {
      _localMediaStream = newStream;
    }

    setState(() {
      _localVideoRenderer.srcObject = _localMediaStream;
      _isVideoEnabled = true;
    });
  }

  /// Enables microphone.
  Future<void> _enableAudio() async {
    final newStream = await navigator.mediaDevices.getUserMedia(
      _getMediaConstraints(isAudioEnabled: true),
    );

    if (_localMediaStream != null) {
      await _removeAudioTracks();
      for (final newTrack in newStream.getAudioTracks()) {
        await _localMediaStream!.addTrack(newTrack);
      }
    } else {
      _localMediaStream = newStream;
    }

    setState(() {
      _isAudioEnabled = true;
    });
  }

  /// Returns media constraints.
  Map<String, dynamic> _getMediaConstraints({
    bool isAudioEnabled = false,
    bool isVideoEnabled = false,
  }) {
    return {
      'audio': isAudioEnabled,
      'video': isVideoEnabled
          ? {
              'mandatory': {
                'minWidth': '640',
                'minHeight': '480',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            }
          : false,
    };
  }

  /// Disables camera.
  Future<void> _disableVideo() async {
    await _removeVideoTracks();
    setState(() {
      _localVideoRenderer.srcObject = null;
      _isVideoEnabled = false;
    });
  }

  /// Disables microphone.
  Future<void> _disableAudio() async {
    await _removeAudioTracks();
    setState(() {
      _isAudioEnabled = false;
    });
  }

  /// Removes all the video tracks from local [MediaStream].
  Future<void> _removeVideoTracks() async {
    final tracks = _localMediaStream!.getVideoTracks();
    for (var i = tracks.length - 1; i >= 0; i--) {
      final track = tracks[i];
      await _localMediaStream!.removeTrack(track);
      await track.stop();
    }
  }

  /// Removes all the audio tracks from local [MediaStream].
  Future<void> _removeAudioTracks() async {
    final tracks = _localMediaStream!.getAudioTracks();
    for (var i = tracks.length - 1; i >= 0; i--) {
      final track = tracks[i];
      await _localMediaStream!.removeTrack(track);
      await track.stop();
    }
  }
}
