import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../stream_video.dart';
import 'audio_recognition_factory_io.dart'
    if (dart.library.js_interop) 'audio_recognition_factory_web.dart';

/// The [SpeakingWhileMutedRecognition.stream] emits state changes when an increase in audio volume
/// is detected while the user is muted.
///
/// - When the user is not muted or no audio is detected,
///   [SpeakingWhileMutedState.isSpeakingWhileMuted] remains `false`.
///
/// - If audio is detected while the user is muted,
///   [SpeakingWhileMutedState.isSpeakingWhileMuted] becomes `true`.
///
/// - If no audio is detected for a period of time, or if the user unmutes,
///   the state reverts to `false`.
///
/// Platform behavior:
/// - Android/iOS/macOS: detection is driven by speech-activity events from the
///   native audio device module, no additional microphone capture is opened.
/// - iOS/macOS: events are only delivered while the audio engine keeps
///   capturing, so the microphone must be muted without stopping the track:
///   `call.setMicrophoneEnabled(enabled: false, stopTrackOnMute: false)`.
///   With the default mute (track stopped and released) no speech events
///   arrive on these platforms. Note that keeping the track alive leaves the
///   OS microphone-in-use indicator on while muted.
/// - Web: browsers expose no such events, so a dedicated microphone stream is
///   analysed with the Web Audio API while detection is active, which keeps
///   the browser's "microphone in use" indicator on while muted.
/// - Windows/Linux: not supported by the default implementation; supply a
///   custom [AudioRecognition] to enable it there.
///
/// Note:
/// - Audio detection begins only after the user mutes themselves or is muted by someone else.
/// - If the user joins a call already muted, audio detection won't start automatically.
///   To enable detection in such cases, use the [start] method manually.
///
/// Example usage:
/// ```dart
///   late StreamSubscription<SpeakingWhileMutedState> _speechSubscription;
///   late SpeakingWhileMutedRecognition _speakingWhileMutedRecognition;
///
///   @override
///   void initState() {
///     super.initState();
///     _speakingWhileMutedRecognition =
///         SpeakingWhileMutedRecognition(call: widget.call);
///     _speechSubscription = _speakingWhileMutedRecognition.stream.listen((state) {
///       final context = this.context;
///       if (state.isSpeakingWhileMuted && context.mounted) {
///         final colorTheme = StreamVideoTheme.of(context).colorTheme;
///
///         ScaffoldMessenger.maybeOf(context)?.showSnackBar(
///           SnackBar(
///             content: const Text('You are speaking while muted'),
///             behavior: SnackBarBehavior.floating,
///             backgroundColor: colorTheme.accentPrimary,
///           ),
///         );
///       }
///     });
///   }
///
///   @override
///   void dispose() {
///     _speechSubscription.cancel();
///     _speakingWhileMutedRecognition.dispose();
///     super.dispose();
///   }
class SpeakingWhileMutedRecognition
    extends StateNotifier<SpeakingWhileMutedState> {
  SpeakingWhileMutedRecognition({
    required this.call,
    AudioRecognition? audioRecognition,
  }) : super(const SpeakingWhileMutedState._(isSpeakingWhileMuted: false)) {
    _audioRecognition =
        audioRecognition ??
        createPlatformAudioRecognition(
          // Resolved lazily at each detection start so the web recognizer
          // always monitors the currently selected microphone.
          audioInputDeviceIdProvider: () =>
              call.state.value.audioInputDevice?.id,
        );
    _init();
  }

  final Call call;
  late final AudioRecognition _audioRecognition;
  StreamSubscription<void>? _callStateSubscription;

  /// Whether detection *should* be running, per the most recent call state.
  ///
  /// Updated synchronously by [start] / [_stop]; [_isRunning] catches up
  /// asynchronously once the queued transition runs.
  bool _shouldRun = false;

  /// Whether [_audioRecognition] is actually running right now.
  bool _isRunning = false;

  /// Serializes transitions so overlapping call-state events cannot interleave
  /// (e.g. an unmute arriving while a device-change restart is still tearing
  /// the previous capture down).
  Future<void> _transitions = Future<void>.value();

  bool _disposed = false;

  /// The selected audio input reported by the most recent call-state event.
  String? _lastSeenAudioInputDeviceId;

  /// The selected audio input at the time detection was started.
  String? _activeAudioInputDeviceId;

  void _init() {
    _callStateSubscription = call
        .partialState(
          (state) => (
            isAudioEnabled: state.isAudioEnabled,
            canSendAudio: state.canSendAudio,
            status: state.status,
            audioInputDeviceId: state.audioInputDevice?.id,
          ),
        )
        .listen((state) {
          _lastSeenAudioInputDeviceId = state.audioInputDeviceId;

          if (state.status.isDisconnected) _stop();
          if (!(state.status.isJoined || state.status.isConnected)) return;

          if (state.isAudioEnabled) {
            _stop();
          } else if (state.canSendAudio) {
            if (_shouldRun &&
                state.audioInputDeviceId != _activeAudioInputDeviceId) {
              // The selected microphone changed while detecting — restart so
              // detection follows the new device.
              _restart();
            } else {
              start();
            }
          }
        });
  }

  /// Starts the audio detection.
  ///
  /// This method is called automatically when the user mutes themselves or is being muted.
  ///
  /// If you want to start the audio detection when the user joins a call muted, you can use the [start] method.
  /// If detection is already active, this method does nothing.
  Future<void> start() {
    _shouldRun = true;
    return _enqueue(_applyShouldRun);
  }

  Future<void> _stop() {
    _shouldRun = false;
    return _enqueue(_applyShouldRun);
  }

  /// Tears the current capture down and brings it back up on the newly
  /// selected device.
  ///
  /// Both halves run inside a single queued transition, and the second half
  /// re-reads [_shouldRun] rather than starting unconditionally — so an unmute
  /// arriving while the old capture is still stopping wins, instead of being
  /// overwritten by a detection that should no longer be running.
  Future<void> _restart() {
    _shouldRun = true;
    return _enqueue(() async {
      await _stopRecognition();
      await _applyShouldRun();
    });
  }

  /// Brings [_audioRecognition] in line with [_shouldRun].
  Future<void> _applyShouldRun() async {
    if (_shouldRun && !_disposed) {
      await _startRecognition();
    } else {
      await _stopRecognition();
    }
  }

  Future<void> _startRecognition() async {
    if (_isRunning) return;
    _isRunning = true;
    _activeAudioInputDeviceId = _lastSeenAudioInputDeviceId;
    _logger.i(() => '[startRecognition] device: $_activeAudioInputDeviceId');
    try {
      await _audioRecognition.start(
        onSoundStateChanged: (soundState) {
          _logger.i(
            () =>
                '[onSoundStateChanged] isSpeakingWhileMuted: '
                '${soundState.isSpeaking}, audioLevel: ${soundState.audioLevel}',
          );

          state = SpeakingWhileMutedState._(
            isSpeakingWhileMuted: soundState.isSpeaking,
          );
        },
      );
    } catch (e, trace) {
      _isRunning = false;
      _logger.e(() => 'Error starting audio recognition: $e\n$trace');
    }
  }

  Future<void> _stopRecognition() async {
    if (!_isRunning) return;
    _isRunning = false;
    _logger.i(() => '[stopRecognition] no args');
    state = const SpeakingWhileMutedState._(isSpeakingWhileMuted: false);
    try {
      await _audioRecognition.stop();
    } catch (e, trace) {
      _logger.e(() => 'Error stopping audio recognition: $e\n$trace');
    }
  }

  /// Chains [action] after any transition that is still in flight.
  Future<void> _enqueue(Future<void> Function() action) {
    final next = _transitions.then((_) => action());
    // Keep the chain usable even if a transition blows up.
    _transitions = next.catchError((Object _) {});
    return next;
  }

  @override
  Future<void> dispose() async {
    // Prevents a queued transition from restarting detection after disposal.
    _disposed = true;
    _shouldRun = false;
    await _callStateSubscription?.cancel();
    await _audioRecognition.dispose();
    super.dispose();
  }
}

extension on CallState {
  bool get isAudioEnabled => localParticipant?.isAudioEnabled ?? false;
  bool get canSendAudio => ownCapabilities.contains(CallPermission.sendAudio);
}

class SpeakingWhileMutedState extends Equatable {
  const SpeakingWhileMutedState._({
    required this.isSpeakingWhileMuted,
  });

  final bool isSpeakingWhileMuted;

  @override
  List<Object?> get props => [isSpeakingWhileMuted];
}

final _logger = taggedLogger(tag: 'SV:SpeakingWhileMutedRecognition');
