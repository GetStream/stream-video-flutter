import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'dart:math' as math;

import '../../stream_video.dart';
import '../webrtc/model/stats/rtc_audio_source.dart';
import '../webrtc/model/stats/rtc_stats_mapper.dart';

typedef SoundStateChangedCallback = void Function(bool isSpeaking);
final _logger = taggedLogger(tag: 'SV:SpeechRecognition');

class SpeechRecognition {
  SpeechRecognition();

  Future<void> _init() async {
    _pc1 = await rtc.createPeerConnection(const RTCConfiguration().toMap());
    _pc2 = await rtc.createPeerConnection(const RTCConfiguration().toMap());
    _isInitialized = true;
  }

  late RTCPeerConnection _pc1;
  late RTCPeerConnection _pc2;
  MediaStream? _audioStream;

  bool _isInitialized = false;

  VoidCallback? _disposeTimers;

  Future<void> start({
    required SoundStateChangedCallback onSoundStateChanged,
  }) async {
    if (!_isInitialized) await _init();
    try {
      if (_disposeTimers != null) {
        _logger.w(
          () =>
              'Started speech recognition while already running. Stopping previous instance.',
        );
        await stop();
      }

      final audioStream = await rtc.navigator.mediaDevices.getUserMedia(
        const AudioConstraints().toMap(),
      );
      _audioStream = audioStream;

      _pc1.onIceCandidate = _pc2.addCandidate;
      _pc2.onIceCandidate = _pc1.addCandidate;

// we might need to set the volume to 0
      // _pc2.onTrack = (event) {
      //   event.streams[0].getAudioTracks().forEach((track) {
      //     track.enabled = false;
      //   });
      // };

      audioStream.getAudioTracks().forEach((track) {
        _pc1.addTrack(track, audioStream);
      });

      final offer = await _pc1.createOffer();
      await _pc2.setRemoteDescription(offer);
      await _pc1.setLocalDescription(offer);

      final answer = await _pc2.createAnswer();
      await _pc1.setRemoteDescription(answer);
      await _pc2.setLocalDescription(answer);

      _disposeTimers = _startListening(onSoundStateChanged);
    } catch (e, trace) {
      print('SpeechRecognition test start error: $e\n$trace');
    }
  }

  Future<void> stop() async {
    _isInitialized = false;
    _disposeTimers?.call();
    _disposeTimers = null;
    await Future.wait([_pc1.close(), _pc2.close()]);
    await _cleanupAudioStream();
  }

  VoidCallback _startListening(SoundStateChangedCallback onSoundStateChanged) {
    const initialBaselineNoiseLevel = 0.13;
    var baselineNoiseLevel = initialBaselineNoiseLevel;
    var speechDetected = false;
    Timer? speechTimer;
    Timer? silenceTimer;
    final audioLevelHistory =
        <double>[]; // Store recent audio levels for smoother detection
    const historyLength = 10;
    const silenceThreshold = 1.1;
    const speechThreshold = 2.5;
    const resetThreshold = 0.9;
    // Speech is set to true after 500ms of audio detection
    const speechTimeout = Duration(milliseconds: 500);
    const silenceTimeout =
        Duration(seconds: 5); // Reset baseline after 5 seconds of silence

    Future<void> checkAudioLevel(Timer timer) async {
      final stats = await _pc1.getStats();
      final audioMediaSourceStats = stats
              .map((stat) => stat.toRtcStats())
              .firstWhereOrNull((rtcStat) => rtcStat is RtcAudioSource)
          as RtcAudioSource?;

      final audioLevel = audioMediaSourceStats?.audioLevel;
      if (audioLevel == null) return;

      // Update audio level history (with max historyLength sized list)
      audioLevelHistory.add(audioLevel);
      if (audioLevelHistory.length > historyLength) {
        audioLevelHistory.removeAt(0);
      }

      if (audioLevelHistory.length < 5) return;

      // Calculate average audio level
      final averageAudioLevel =
          audioLevelHistory.reduce((a, b) => a + b) / audioLevelHistory.length;

      // Update baseline (if necessary) based on silence detection
      if (averageAudioLevel < baselineNoiseLevel * silenceThreshold) {
        silenceTimer ??= Timer(silenceTimeout, () {
          baselineNoiseLevel = math.min(
            averageAudioLevel * resetThreshold,
            initialBaselineNoiseLevel,
          );
        });
      } else {
        silenceTimer?.cancel();
        silenceTimer = null;
      }

      // Check for speech detection
      if (averageAudioLevel > baselineNoiseLevel * speechThreshold) {
        if (!speechDetected) {
          speechDetected = true;
          onSoundStateChanged(true);
        }

        speechTimer?.cancel();
        speechTimer = Timer(speechTimeout, () {
          speechDetected = false;
          onSoundStateChanged(false);
          speechTimer = null;
        });
      }
    }

    final interval =
        Timer.periodic(const Duration(milliseconds: 100), checkAudioLevel);

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
