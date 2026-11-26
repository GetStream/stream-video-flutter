import 'package:meta/meta.dart';

import 'third_party/webrtc_interface/media_stream_track.dart';

/// Receives the playback traces of an [RTCAudioRenderer].
typedef AudioRendererTraceHandler = void Function(AudioRendererTrace trace);

/// A playback trace of an [RTCAudioRenderer].
@immutable
final class AudioRendererTrace {
  const AudioRendererTrace(this.tag, this.data);

  /// One of [AudioRendererTraceTag].
  final String tag;

  /// The details of the trace, such as the track id and the error.
  final Map<String, Object?> data;

  @override
  String toString() => 'AudioRendererTrace($tag, $data)';
}

/// The playback state of an [RTCAudioRenderer].
enum AudioRendererState {
  /// No track is attached, or the track was detached.
  detached,

  /// The attached track plays, or is starting to play.
  playing,

  /// Playback stopped unexpectedly and is being recovered.
  recovering,

  /// The browser's autoplay policy blocks playback until
  /// [RTCAudioRenderer.resume] runs in a user gesture.
  blocked,
}

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
///
/// Implemented by the WebRTC packages only.
@sealed
abstract class RTCAudioRenderer {
  /// The id the renderer was created with.
  String get id;

  /// Plays [track], replacing the track played before. Throws an
  /// [ArgumentError] for a track of another WebRTC implementation.
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

  /// Whether the output is muted. Playback keeps running while muted. Kept
  /// across [attach] and [detach].
  bool get muted;
  set muted(bool muted);

  /// Plays out on the audio output [deviceId], from now on or from the next
  /// [attach]. Throws [UnsupportedError] where the browser cannot pick the
  /// output per element. Does nothing on native platforms, where the audio
  /// output is picked for the whole app.
  Future<void> setSinkId(String deviceId);

  /// The playback state.
  AudioRendererState get state;

  /// Emits [state] whenever it changes. A broadcast stream.
  Stream<AudioRendererState> get stateChanges;

  /// Retries playback right away. Call it in a user gesture to lift an
  /// autoplay block.
  Future<void> resume();

  /// Stops playing and releases the element.
  Future<void> dispose();
}
