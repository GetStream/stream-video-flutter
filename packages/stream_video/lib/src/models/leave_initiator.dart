/// Who or what made a call leave.
enum LeaveInitiator {
  /// The user asked to leave, for example with a hang-up button.
  user,

  /// The integration left on its own, for example on dispose, or to make
  /// way for another call.
  app,

  /// The system call UI ended the call: CallKit on iOS, Telecom on Android.
  callkit,

  /// An event from the backend or another participant ended the call.
  remoteEvent,

  /// The SDK gave up after an error.
  sdkError,

  /// The source is not known.
  unknown,
}
