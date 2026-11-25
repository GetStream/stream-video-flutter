/// Shows the system picker of the app's broadcast upload extension. iOS only.
///
/// Throws an [UnsupportedError] on the web.
Future<void> presentiOSBroadcastPicker() async {
  throw UnsupportedError('presentiOSBroadcastPicker is only supported on iOS');
}

/// Asks the app's broadcast upload extension to finish its broadcast. iOS
/// only.
///
/// Throws an [UnsupportedError] on the web.
Future<void> stopiOSBroadcast() async {
  throw UnsupportedError('stopiOSBroadcast is only supported on iOS');
}
