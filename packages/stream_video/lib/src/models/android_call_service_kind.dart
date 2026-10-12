/// The Android foreground service a call runs in.
///
/// Android requires a foreground service to declare the kind of work it does,
/// and Google Play requires every declared kind to match what the app visibly
/// does. The SDK therefore runs a call in one of two services, each declaring
/// only the types it can need, so an app is only asked to justify the types
/// it actually uses.
///
/// The kind is read from the call's effective `AudioConfigurationPolicy`:
/// the viewer policy resolves to [livestreamViewer], every other predefined
/// policy to [call], and a custom policy can name one explicitly.
///
/// On Android 14 and newer a service only requests a type whose
/// `FOREGROUND_SERVICE_*` permission is still declared, so an app without a
/// feature removes that one permission from its merged manifest with
/// `tools:node="remove"`: `FOREGROUND_SERVICE_MEDIA_PLAYBACK` without a
/// viewer mode, `FOREGROUND_SERVICE_PHONE_CALL` and `MANAGE_OWN_CALLS` for a
/// livestream host app with no calls, `FOREGROUND_SERVICE_CAMERA` for
/// audio-only calls.
enum AndroidCallServiceKind {
  /// A voice or video call.
  ///
  /// Runs in `StreamCallService`, which requests `phoneCall`, plus
  /// `microphone` and `camera` when those permissions are granted.
  call,

  /// A livestream viewer, who only plays remote media.
  ///
  /// Runs in `StreamLivestreamViewerService`, which requests `mediaPlayback`
  /// alone.
  livestreamViewer,
}
