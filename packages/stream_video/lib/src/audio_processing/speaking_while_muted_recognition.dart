import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../stream_video.dart';
import 'audio_recognition_webrtc.dart';

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
  })  : _audioRecognition = audioRecognition ?? AudioRecognitionWebRTC(),
        super(const SpeakingWhileMutedState._(isSpeakingWhileMuted: false)) {
    _init();
  }

  final Call call;
  final AudioRecognition _audioRecognition;
  StreamSubscription<void>? _callStateSubscription;
  bool _isActive = false;

  void _init() {
    _callStateSubscription = call
        .partialState(
      (state) => (
        isAudioEnabled: state.isAudioEnabled,
        canSendAudio: state.canSendAudio,
        status: state.status,
      ),
    )
        .listen((state) {
      if (state.status.isDisconnected) _stop();
      if (!(state.status.isJoined || state.status.isConnected)) return;

      if (state.isAudioEnabled) {
        _stop();
      } else if (state.canSendAudio) {
        start();
      }
    });
  }

  /// Starts the audio detection.
  ///
  /// This method is called automatically when the user mutes themselves or is being muted.
  ///
  /// If you want to start the audio detection when the user joins a call muted, you can use the [start] method.
  /// If detection is already active, this method does nothing.
  Future<void> start() async {
    if (_isActive) return;
    _isActive = true;
    try {
      await _audioRecognition.start(
        onSoundStateChanged: (soundState) {
          state = SpeakingWhileMutedState._(
            isSpeakingWhileMuted: soundState.isSpeaking,
          );
        },
      );
    } catch (e, trace) {
      _isActive = false;
      _logger.e(() => 'Error starting audio recognition: $e\n$trace');
    }
  }

  Future<void> _stop() async {
    if (!_isActive) return;
    _isActive = false;
    state = const SpeakingWhileMutedState._(isSpeakingWhileMuted: false);
    await _audioRecognition.stop();
  }

  @override
  Future<void> dispose() async {
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
