import 'third_party/webrtc_interface/media_stream.dart';
import 'third_party/webrtc_interface/rtc_peerconnection.dart';

/// A peer connection factory owned by one call, with its own audio device
/// module. Built by `WebRtcEngine.createPeerConnectionFactory` where
/// `WebRtcCapabilities.supportsPerCallFactory` is true.
abstract class PeerConnectionFactory {
  /// The id the platform gave the factory.
  String get factoryId;

  /// Builds a peer connection inside this factory.
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]);

  /// Captures the camera or microphone into this factory.
  Future<MediaStream> getUserMedia(Map<String, dynamic> mediaConstraints);

  /// Captures the screen into this factory.
  Future<MediaStream> getDisplayMedia(Map<String, dynamic> mediaConstraints);

  /// Asks the user to allow screen capture into this factory. Returns whether
  /// they allowed it. [fullScreenOnly] leaves out sharing a single app where
  /// the system offers it. Android.
  Future<bool> requestCapturePermission({bool fullScreenOnly = false});

  /// Mutes or unmutes the microphone in the audio device module, which keeps
  /// running and reports speech while muted. Throws [UnsupportedError] where
  /// `WebRtcAudio.supportsAudioModuleMicrophoneMute` is false.
  Future<void> setMicrophoneMuted(bool muted);

  /// Whether the audio device module's microphone is muted. False also when
  /// the module cannot be asked. Throws [UnsupportedError] where
  /// `WebRtcAudio.supportsAudioModuleMicrophoneMute` is false.
  Future<bool> isMicrophoneMuted();

  /// Stops this factory's audio capture and playout, so another factory can
  /// use the microphone and speaker.
  Future<void> suspendAudio();

  /// Starts the audio [suspendAudio] stopped.
  Future<void> resumeAudio();

  /// Releases the factory. Dispose every peer connection it built first.
  Future<void> dispose();
}
