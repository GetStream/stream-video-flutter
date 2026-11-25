import 'third_party/webrtc_interface/media_stream_track.dart';

/// Receives the playback traces of an [RTCAudioRenderer], tagged with one of
/// [AudioRendererTraceTag].
typedef AudioRendererTraceHandler = void Function(String tag, Object? data);

/// The tags of the traces an [RTCAudioRenderer] reports.
abstract final class AudioRendererTraceTag {
  /// Playback paused or suspended unexpectedly.
  static const String paused = 'mediaPlayback.paused';

  /// The autoplay policy blocks playback until [RTCAudioRenderer.resume] runs
  /// in a user gesture.
  static const String blocked = 'audioPlaybackBlocked';

  /// Playback runs again after an outage.
  static const String recovered = 'mediaPlayback.recover.success';

  /// Playback keeps failing; recovery goes on at the longest backoff.
  static const String stalled = 'mediaPlayback.recover.stalled';
}

/// Plays a remote audio track.
///
/// In the browser it owns an audio element, starts playback explicitly and
/// recovers it when it pauses, suspends or fails. Native platforms play remote
/// audio themselves, so there it does nothing and is never blocked.
abstract class RTCAudioRenderer {
  /// The id the renderer was created with.
  String get id;

  /// Plays [track], replacing the track played before.
  void attach(MediaStreamTrack track);

  /// Stops playing and stops recovering playback, keeping the element and the
  /// track, so [attach] can start the same track again.
  void detach();

  /// The track last given to [attach]. Null before the first one.
  MediaStreamTrack? get track;

  /// Whether the renderer plays [track], as the same underlying track rather
  /// than the same wrapper object.
  bool isAttachedTo(MediaStreamTrack track);

  /// Whether a track is attached and not [detach]ed.
  bool get isAttached;

  /// Whether the output is muted. Playback keeps running while muted.
  bool get muted;
  set muted(bool muted);

  /// Plays out on the audio output [deviceId]. Throws [UnsupportedError] where
  /// the output cannot be picked per renderer.
  Future<void> setSinkId(String deviceId);

  /// Whether the browser's autoplay policy blocks playback.
  bool get isBlocked;

  /// Emits whenever [isBlocked] changes.
  Stream<bool> get playbackBlocked;

  /// Whether playback stopped unexpectedly and is being recovered.
  bool get isRecovering;

  /// Retries playback right away. Call it in a user gesture to lift an
  /// autoplay block.
  Future<void> resume();

  /// Stops playing and releases the element.
  Future<void> dispose();
}
