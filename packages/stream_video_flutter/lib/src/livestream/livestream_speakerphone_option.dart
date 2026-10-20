import 'dart:async';

import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// A livestream control that mutes and unmutes playback of the stream's
/// audio, like the speaker button of a video player.
///
/// Muting pauses remote audio playout through
/// [RtcMediaDeviceNotifier.pauseAudioPlayout]; it does not change the audio
/// output device, so audio keeps following the system route (speaker,
/// headphones or Bluetooth). The icon follows
/// [RtcMediaDeviceNotifier.isAudioPlayoutPaused], so it also reflects playout
/// paused or resumed elsewhere in the app.
///
/// Playout is app-wide. If this widget muted it, it unmutes it again when it
/// is removed from the tree, so leaving the livestream does not leave the next
/// call silent.
///
/// Pausing playout is supported on Android, iOS, macOS and web
/// ([RtcMediaDeviceNotifier.isAudioPlayoutPauseSupported]); elsewhere the
/// button is not shown.
class LivestreamSpeakerphoneOption extends StatefulWidget {
  /// Creates a new instance of [LivestreamSpeakerphoneOption].
  const LivestreamSpeakerphoneOption({
    super.key,
    required this.call,
    this.enabledSpeakerphoneIconTheme = const IconThemeData(
      color: Colors.white,
    ),
    this.disabledSpeakerphoneIconTheme = const IconThemeData(
      color: Colors.white,
    ),
  });

  /// Represents a call.
  final Call call;

  /// The theme that is applied while the stream's audio is playing.
  final IconThemeData enabledSpeakerphoneIconTheme;

  /// The theme that is applied while the stream's audio is muted.
  final IconThemeData disabledSpeakerphoneIconTheme;

  @override
  State<LivestreamSpeakerphoneOption> createState() => _ToggleSpeakerState();
}

class _ToggleSpeakerState extends State<LivestreamSpeakerphoneOption> {
  final _deviceNotifier = RtcMediaDeviceNotifier.instance;
  StreamSubscription<bool>? _pausedSubscription;

  late var _muted = _deviceNotifier.isAudioPlayoutPaused;

  /// Whether this widget is the one that paused playout, so it only undoes
  /// its own mute on dispose. Set before the pause is sent, so leaving while
  /// it is in flight still unmutes, and cleared whenever playout is resumed,
  /// by anyone, so a later pause from elsewhere is left alone.
  var _pausedByThisWidget = false;

  /// The pause or resume currently in flight. Taps are ignored while it runs,
  /// and dispose waits for it before unmuting.
  Future<void>? _inFlight;

  @override
  void initState() {
    super.initState();
    _pausedSubscription = _deviceNotifier.audioPlayoutPausedChanges.listen((
      paused,
    ) {
      if (!paused) _pausedByThisWidget = false;
      if (paused != _muted) setState(() => _muted = paused);
    });
  }

  Future<void> _toggle() async {
    if (_inFlight != null) return;

    final mute = !_muted;
    final previouslyPausedByThisWidget = _pausedByThisWidget;
    _pausedByThisWidget = mute;

    final operation = mute
        ? _deviceNotifier.pauseAudioPlayout()
        : _deviceNotifier.resumeAudioPlayout();
    _inFlight = operation;

    try {
      await operation;
    } catch (_) {
      _pausedByThisWidget = previouslyPausedByThisWidget;
    } finally {
      _inFlight = null;
    }
  }

  @override
  void dispose() {
    _pausedSubscription?.cancel();
    if (_pausedByThisWidget) {
      final inFlight = _inFlight ?? Future<void>.value();
      unawaited(
        inFlight
            .catchError((_) {})
            .then((_) => _deviceNotifier.resumeAudioPlayout())
            .catchError((_) {}),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_deviceNotifier.isAudioPlayoutPauseSupported) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: _muted
          ? IconTheme(
              data: widget.disabledSpeakerphoneIconTheme,
              child: const Icon(Icons.volume_off_rounded),
            )
          : IconTheme(
              data: widget.enabledSpeakerphoneIconTheme,
              child: const Icon(Icons.volume_up_rounded),
            ),
      onPressed: _toggle,
      padding: const EdgeInsets.all(16),
    );
  }
}
