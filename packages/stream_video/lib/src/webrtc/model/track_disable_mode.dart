/// Controls how a local media track is disabled when the user mutes it.
enum TrackDisableMode {
  /// Keep the local track and the underlying capture session alive, and only
  /// flip `enabled = false` on the track so WebRTC stops encoding frames.
  ///
  /// Pros:
  /// - On iOS the shared `AVAudioSession` is not torn down, so playback of
  ///   other participants is not interrupted when the user mutes/unmutes.
  ///
  /// Cons:
  /// - The microphone/camera capture hardware keeps running, so the system
  ///   privacy indicator (orange mic dot / green camera dot on iOS, the
  ///   equivalent indicators on Android 12+) remains visible while muted.
  disableTracks,

  /// Stop the local track and release the capture hardware on mute, then
  /// recreate it via `getUserMedia` on unmute.
  ///
  /// Pros:
  /// - The system privacy indicator turns off while muted, matching the
  ///   behaviour users expect from native voice apps.
  ///
  /// Cons:
  /// - On iOS, disposing the local `MediaStream` tears down the shared
  ///   `AVAudioSession` via the native `streamDispose` path, which briefly
  ///   ducks playback of the other participants for ~1–2 seconds while the
  ///   audio graph restarts. This might be noticeable in audio rooms.
  stopTracks,
}
