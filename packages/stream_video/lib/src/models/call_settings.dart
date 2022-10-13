
/// Represents the settings for a call.
class CallSettings {
  /// Whether the audio is on for the current user.
  final bool audioOn;

  /// Whether the video is on for the current user.
  final bool videoOn;

  /// Whether the sepaker is on for the current user.
  final bool speakerOn;

  /// The camera position for the current user.
  final CameraPosition cameraPosition;
  
  const CallSettings({
    this.audioOn = true,
    this.videoOn = true,
    this.speakerOn = true,
    this.cameraPosition = CameraPosition.front,
  });
}

/// The camera position.
enum CameraPosition {
  front,
  back,
}
