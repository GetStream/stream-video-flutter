import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import '../../stream_video.dart';
import '../webrtc/model/stats/rtc_audio_source.dart';
import '../webrtc/model/stats/rtc_stats_mapper.dart';

class AudioRecognitionWebRTC implements AudioRecognition {
  AudioRecognitionWebRTC({this.config = const AudioRecognitionConfig()}) {
    _init();
  }

  Completer<void>? _initCompleter;
  AudioRecognitionConfig config;

  late RTCPeerConnection _pc1;
  late RTCPeerConnection _pc2;
  MediaStream? _audioStream;

  VoidCallback? _disposeTimers;

  @override
  Future<void> start({
    required SoundStateChangedCallback onSoundStateChanged,
  }) async {
    if (_initCompleter case final completer?) await completer.future;

    _disposeTimers = _startListening(onSoundStateChanged);
  }

  @override
  Future<void> stop() async {
    _disposeTimers?.call();
    _disposeTimers = null;
  }

  @override
  Future<void> dispose() async {
    await stop();
    await Future.wait([_pc1.close(), _pc2.close()]);
    await _cleanupAudioStream();
  }

  Future<void> _init() async {
    _initCompleter = Completer<void>();
    try {
      _pc1 = await rtc.createPeerConnection(const RTCConfiguration().toMap());
      _pc2 = await rtc.createPeerConnection(const RTCConfiguration().toMap());

      final audioStream = await rtc.navigator.mediaDevices.getUserMedia(
        const AudioConstraints().toMap(),
      );
      _audioStream = audioStream;

      _pc1.onIceCandidate = _pc2.addCandidate;
      _pc2.onIceCandidate = _pc1.addCandidate;

      audioStream.getAudioTracks().forEach((track) {
        _pc1.addTrack(track, audioStream);
      });

      final offer = await _pc1.createOffer();
      await _pc2.setRemoteDescription(offer);
      await _pc1.setLocalDescription(offer);

      final answer = await _pc2.createAnswer();
      await _pc1.setRemoteDescription(answer);
      await _pc2.setLocalDescription(answer);
      _initCompleter?.complete();
      _initCompleter = null;
    } catch (e, trace) {
      _initCompleter?.completeError(e, trace);
    }
  }

  VoidCallback _startListening(SoundStateChangedCallback onSoundStateChanged) {
    var baselineNoiseLevel = config.initialBaselineNoiseLevel;
    var speechDetected = false;
    Timer? speechTimer;
    Timer? silenceTimer;
    final audioLevelHistory =
        <double>[]; // Store recent audio levels for smoother detection

    Future<void> checkAudioLevel(Timer timer) async {
      final stats = await _pc1.getStats();
      final audioMediaSourceStats = stats
          .map((stat) => stat.toRtcStats())
          .whereType<RtcAudioSource>()
          .firstOrNull;

      final audioLevel = audioMediaSourceStats?.audioLevel;
      if (audioLevel == null) return;

      // Update audio level history (with max historyLength sized list)
      audioLevelHistory.add(audioLevel);
      if (audioLevelHistory.length > config.historyLength) {
        audioLevelHistory.removeAt(0);
      }

      if (audioLevelHistory.length < 5) return;

      // Calculate average audio level
      final averageAudioLevel =
          audioLevelHistory.reduce((a, b) => a + b) / audioLevelHistory.length;

      // Update baseline (if necessary) based on silence detection
      if (averageAudioLevel < baselineNoiseLevel * config.silenceThreshold) {
        silenceTimer ??= Timer(config.silenceTimeout, () {
          baselineNoiseLevel = math.min(
            averageAudioLevel * config.resetThreshold,
            baselineNoiseLevel,
          );
        });
      } else {
        silenceTimer?.cancel();
        silenceTimer = null;
      }

      // Check for speech detection
      if (averageAudioLevel > baselineNoiseLevel * config.speechThreshold) {
        if (!speechDetected) {
          speechDetected = true;
          onSoundStateChanged(
            SoundState(
              isSpeaking: true,
              audioLevel: averageAudioLevel,
            ),
          );
        }

        speechTimer?.cancel();
        speechTimer = Timer(config.speechTimeout, () {
          speechDetected = false;
          onSoundStateChanged(
            SoundState(isSpeaking: false, audioLevel: averageAudioLevel),
          );
          speechTimer = null;
        });
      }
    }

    final interval = Timer.periodic(
      const Duration(milliseconds: 100),
      checkAudioLevel,
    );

    return () {
      speechTimer?.cancel();
      silenceTimer?.cancel();
      interval.cancel();
    };
  }

  Future<void> _cleanupAudioStream() async {
    _audioStream?.getAudioTracks().forEach((track) {
      track.stop();
    });
    await _audioStream?.dispose();
    _audioStream = null;
  }
}

class AudioRecognitionConfig {
  const AudioRecognitionConfig({
    this.initialBaselineNoiseLevel = 0.13,
    this.historyLength = 10,
    this.silenceThreshold = 1.1,
    this.speechThreshold = 5,
    this.resetThreshold = 0.9,
    this.speechTimeout = const Duration(milliseconds: 500),
    this.silenceTimeout = const Duration(seconds: 5),
  });

  final double initialBaselineNoiseLevel;
  final int historyLength;
  final double silenceThreshold;
  final double speechThreshold;
  final double resetThreshold;
  final Duration speechTimeout;
  final Duration silenceTimeout;
}
