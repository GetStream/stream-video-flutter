/// The Android foreground service a call runs in.
///
/// Android requires a foreground service to declare the kind of work it does,
/// and Google Play requires every declared kind to match what the app visibly
/// does. The SDK therefore runs a call in one of two services, each declaring
/// only the types it can need, so an app is only asked to justify the types
/// it actually uses.
///
/// The kind is read from the call's effective `AudioConfigurationPolicy` once,
/// when the call becomes active: the viewer policy resolves to
/// [livestreamViewer], every other predefined policy to [call], and a custom
/// policy can name one explicitly. A policy changed through the call
/// preferences afterwards does not move the call to another service.
///
/// On Android 14 and newer a service only requests a type whose
/// `FOREGROUND_SERVICE_*` permission is still declared, so an app without a
/// feature removes that one permission from its merged manifest with
/// `tools:node="remove"`: `FOREGROUND_SERVICE_MEDIA_PLAYBACK` without a
/// viewer mode, `FOREGROUND_SERVICE_CAMERA` for audio-only calls.
///
/// Keep `FOREGROUND_SERVICE_PHONE_CALL` and `MANAGE_OWN_CALLS` in any app that
/// makes calls or hosts livestreams. Phone call is the one type the call
/// service holds without a runtime grant, so it is what keeps a participant
/// without the microphone or camera permission in the foreground. Without it
/// such a call falls back to a `shortService`, which the system stops after
/// about three minutes.
enum AndroidCallServiceKind {
  /// A voice or video call.
  ///
  /// Runs in `StreamCallService`, which requests `phoneCall`, plus
  /// `microphone` and `camera` when those permissions are granted.
  call,

  /// A livestream viewer, whose call is media playback rather than a phone
  /// call.
  ///
  /// Runs in `StreamLivestreamViewerService`, which requests `mediaPlayback`
  /// in place of `phoneCall`, plus `microphone` and `camera` when those
  /// permissions are granted, so a viewer brought on stage keeps publishing in
  /// the background.
  livestreamViewer,
}
