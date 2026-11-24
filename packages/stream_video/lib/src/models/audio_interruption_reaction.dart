/// What a call does while the platform interrupts its audio, such as for a
/// phone call, an alarm or another app playing audio.
///
/// The interruption is reported on `CallState.isAudioInterrupted` whichever
/// reaction is set.
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
  /// turns it on or the call ends.
  muteMicrophone,
}
