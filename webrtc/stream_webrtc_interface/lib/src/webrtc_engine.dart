import 'package:meta/meta.dart';

import 'first_frame_watcher.dart';
import 'peer_connection_factory.dart';
import 'peer_connection_factory_options.dart';
import 'platform_events.dart';
import 'rtc_audio_renderer.dart';
import 'third_party/flutter_webrtc/e2ee/encryption_manager.dart';
import 'third_party/flutter_webrtc/e2ee/encryption_types.dart';
import 'third_party/webrtc_interface/media_stream.dart';
import 'third_party/webrtc_interface/mediadevices.dart';
import 'third_party/webrtc_interface/rtc_peerconnection.dart';
import 'webrtc_audio.dart';
import 'webrtc_camera.dart';
import 'webrtc_capabilities.dart';

export 'first_frame_watcher.dart';
export 'peer_connection_factory.dart';
export 'webrtc_audio.dart';
export 'webrtc_camera.dart';

/// The WebRTC implementation of the platform the app runs on.
///
/// An engine is registered in [instance] before WebRTC is used; a test
/// registers a fake one.
///
/// Implemented by the WebRTC packages only.
@sealed
abstract class WebRtcEngine {
  static WebRtcEngine? _instance;

  /// The registered engine. Throws a [StateError] when none is registered.
  static WebRtcEngine get instance {
    final engine = _instance;
    if (engine == null) {
      throw StateError(
        'No WebRtcEngine is registered. Add stream_video_flutter to the app, '
        'or set WebRtcEngine.instance before using WebRTC.',
      );
    }
    return engine;
  }

  /// Registers [engine], replacing the one registered before.
  static set instance(WebRtcEngine engine) => _instance = engine;

  /// Whether an engine is registered.
  static bool get isRegistered => _instance != null;

  /// Removes the registered engine, for tests.
  @visibleForTesting
  static void debugUnregister() => _instance = null;

  /// What this implementation can do.
  WebRtcCapabilities get capabilities;

  /// The events the platform reports outside of a peer connection, a track or
  /// a renderer.
  WebRtcPlatformEvents get events;

  /// The cameras, microphones and audio outputs, and capture from them.
  MediaDevices get mediaDevices;

  /// The app-wide audio.
  WebRtcAudio get audio;

  /// The running camera capture.
  WebRtcCamera get camera;

  /// Sets the options the shared peer connection factory is built with the
  /// next time it is built, its Android and Apple audio configuration
  /// included. Applies only once unless [refresh] is true. Throws
  /// [UnsupportedError] where there is no shared factory to configure.
  Future<void> configureDefaultFactory({
    PeerConnectionFactoryOptions? options,
    bool refresh = false,
  });

  /// Builds a peer connection in the shared factory.
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, {
    Map<String, dynamic> constraints = const {},
  });

  /// Builds a factory for one call. Throws [UnsupportedError] where
  /// `WebRtcCapabilities.supportsPerCallFactory` is false.
  Future<PeerConnectionFactory> createPeerConnectionFactory({
    PeerConnectionFactoryOptions options = const PeerConnectionFactoryOptions(),
  });

  /// Asks the user to allow screen capture. Returns whether they allowed it.
  /// [fullScreenOnly] leaves out sharing a single app where the system offers
  /// it. Android; throws elsewhere.
  Future<bool> requestCapturePermission({bool fullScreenOnly = false});

  /// Creates the renderer of the remote audio track [id].
  RTCAudioRenderer createAudioRenderer(
    String id, {
    AudioRendererTraceHandler? onTrace,
  });

  /// Calls [onFirstFrame] once, when the first frame of the video in [stream]
  /// is decoded.
  Future<FirstFrameWatcher> watchFirstFrame(
    MediaStream stream, {
    required void Function(FirstVideoFrame frame) onFirstFrame,
  });

  /// Builds an [EncryptionManager] that encrypts outgoing frames as [userId].
  /// Throws [UnsupportedError] where `WebRtcCapabilities.supportsEncryption`
  /// is false.
  EncryptionManager createEncryptionManager({
    required String userId,
    EncryptionAlgorithm algorithm = EncryptionAlgorithm.aes128Gcm,
  });
}
