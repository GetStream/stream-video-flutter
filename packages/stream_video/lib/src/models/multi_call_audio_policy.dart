/// Controls how the SDK manages audio between calls when more than one
/// `Call` is active at the same time.
enum MultiCallAudioPolicy {
  /// Default. Newest call wins.
  ///
  /// Suspends audio on other calls when a new call becomes active.
  /// Resumes audio on the previous call when the current call is removed.
  suspendExisting,

  /// First-joined call keeps focus.
  ///
  /// On `setActiveCall`, suspends audio on the new call if another call is active, otherwise leaves it unsuspended.
  /// No automatic resume on `removeActiveCall`. Integrator manages suspend/resume.
  suspendIncoming,

  /// The SDK does not suspend or resume anything automatically.
  ///
  /// Audio session handoff is manual: call `Call.suspendAudio()` and `Call.resumeAudio()` as needed.
  /// Warning: multiple active calls may conflict for mic/speaker—prefer this only if explicit control is required.
  manual,
}
