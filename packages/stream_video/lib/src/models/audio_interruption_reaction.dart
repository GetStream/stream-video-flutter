/// What a call does while the platform interrupts its audio, such as for a
/// phone call, an alarm or another app playing audio.
///
/// The interruption is reported on `CallState.isAudioInterrupted` whichever
/// reaction is set.
///
/// On Android, the interruption comes from the call's audio focus: another
/// app taking focus starts it, including only to duck the call's audio, such
/// as for a navigation prompt, and the focus coming back ends it. An app that
/// takes focus for good, such as a video player or another calling app, does
/// not give it back, so the interruption lasts until the call ends, unless
/// the app regains focus with
/// `PlatformAudioController.instance.regainAndroidAudioFocus`.
enum AudioInterruptionReaction {
  /// The call changes nothing.
  none,

  /// The microphone is turned off while the call's audio is interrupted, and
  /// back on when the interruption ends, unless the microphone was already
  /// off, or the app turned it on or off during the interruption. An
  /// interruption that ends while the app is in the background with
  /// `StreamVideoOptions.muteAudioWhenInBackground` set turns it back on when
  /// the app comes back.
  ///
  /// On iOS, a call CallKit holds is told the interruption ended whenever
  /// CallKit activates its audio session again, such as when the call comes
  /// off hold after a phone call. For a call not reported to CallKit, iOS does
  /// not always report the end; the microphone then stays off until the app
  /// turns it on or the call ends. On Android, the same happens when another
  /// app takes the call's audio focus for good.
  muteMicrophone,
}
