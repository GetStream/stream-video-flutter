/// What made a call leave, reported as `leave_initiator` with the join stages
/// a leave aborts, so they can be told apart from a failed join.
enum LeaveInitiator {
  /// The user asked to leave, for example with a hang-up button.
  user('user'),

  /// The integration left on its own, for example on dispose, or to make
  /// way for another call.
  app('app'),

  /// The system call UI ended the call: CallKit on iOS, Telecom on Android.
  callkit('callkit'),

  /// An event from the backend or another participant ended the call.
  remoteEvent('remote_event'),

  /// The SDK gave up after an error.
  sdkError('sdk_error'),

  /// The source is not known.
  unknown('unknown');

  const LeaveInitiator(this.wireValue);

  final String wireValue;
}
